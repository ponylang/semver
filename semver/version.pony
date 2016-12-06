use "collections"

// TODO: review the ponylang discussion around constants
//       the runtime cost here every time is silly for what are supposed to be fixed values
primitive _VersionConsts
  fun alphas(): Set[U8] =>
    Set[U8].union("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-".values())
  fun nums(): Set[U8] =>
    Set[U8].union("0123456789".values())
  fun alphanums(): Set[U8] =>
    Set[U8].union(alphas().values()).union(nums().values())

primitive _VersionFieldValidator
  fun apply(pr: Array[PreReleaseField], build: Array[String]): Array[String] =>
    let errs = Array[String]

    for (i, field) in pr.pairs() do
      match field
      | let s: String =>
        let err = _validateStringField("pre-release", i, s)
        if (err != "") then
          errs.push(err)
        end
      end
    end

    for (i, field) in build.pairs() do
      let err = _validateStringField("build", i, field)
      if (err != "") then
        errs.push(err)
      end
    end

    errs

  fun _validateStringField(setName: String, i: USize, field: String): String =>
    let fieldId = setName + " field " + (i + 1).string()

    if (field == "") then
      fieldId + " is blank"
    elseif (Strings.containsOnly(field, _VersionConsts.alphanums()) == false) then
      fieldId + " contains non-alphanumeric characters"
    else 
      ""
    end

type PreReleaseField is (String | U64)

class Version is Stringable
  var major: U64
  var minor: U64
  var patch: U64
  let prFields: Array[PreReleaseField]
  let buildFields: Array[String]
  let errors: Array[String]

  new create(
    major': U64,
    minor': U64 = 0,
    patch': U64 = 0,
    prFields': Array[PreReleaseField] = Array[PreReleaseField],
    buildFields': Array[String] = Array[String]
  ) =>
    major = major'
    minor = minor'
    patch = patch'
    prFields = prFields'
    buildFields = buildFields'
    errors = _VersionFieldValidator(prFields, buildFields)

  // Parsing

  new parse(s: String) =>
    major = 0
    minor = 0
    patch = 0
    prFields = Array[PreReleaseField]
    buildFields = Array[String]

    errors = Array[String]

    if (s == "") then
      errors.push("version string blank")
      return
    end

    try
      let headAndBuild = s.split("+", 2)
      let headAndPreRel = headAndBuild(0).split("-", 2)

      let majMinPat = recover box headAndPreRel(0).split(".") end
      if (majMinPat.size() != 3) then
        errors.push("expected head of version string to be of the form 'major.minor.patch'")
        return
      end

      for m in majMinPat.values() do
        if ((m == "") or (not Strings.containsOnly(m, _VersionConsts.nums()))) then
          errors.push("expected major, minor and patch to be numeric")
          return
        end
      end

      major = majMinPat(0).u64()
      minor = majMinPat(1).u64()
      patch = majMinPat(2).u64()

      if (headAndPreRel.size() == 2) then
        for p in headAndPreRel(1).split(".").values() do
          if ((p != "") and (Strings.containsOnly(p, _VersionConsts.nums()))) then
            if (p.compare_sub("0", 1) is Equal) then
              errors.push("numeric pre-release fields cannot have leading zeros")
            else
              prFields.push(p.u64())
            end
          else
            prFields.push(p)
          end
        end
      end

      if (headAndBuild.size() == 2) then
        buildFields.append(headAndBuild(1).split("."))
      end
    else
      errors.push("unexpected internal error")
    end

    errors.append(_VersionFieldValidator(prFields, buildFields))

  // Validation

  fun isValid(): Bool =>
    errors.size() == 0

  // String inspection
  
  fun string() : String iso^ =>
    let result = recover String(5) end // we always need at least 5 characters ("0.0.0")

    result.append(majorMinorPatchString())

    if (prFields.size() > 0) then
      result.append("-" + preReleaseString())
    end

    if (buildFields.size() > 0) then
      result.append("+" + buildString())
    end

    result

  fun majorMinorPatchString() : String val =>
    ".".join([major, minor, patch])
  
  fun preReleaseString() : String val =>
    ".".join(prFields)

  fun buildString() : String val =>
    ".".join(buildFields)