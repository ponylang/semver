use "collections"

primitive _Alphanum
  fun bytes(): Iterator[U8] =>
    "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".values()
  fun byteSet(): Set[U8] =>
    Set[U8].union(bytes())

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
    elseif (_stringContainsOnly(field, _Alphanum.byteSet()) == false) then
      fieldId + " contains at least one non-alphanumeric character"
    else 
      ""
    end

  // TODO: break out into util module
  fun tag _stringContainsOnly(s: String, bytes: Set[U8]): Bool =>
    for byte in s.values() do
      if (bytes.contains(byte) == false) then
        return false
      end
    end
    true

type PreReleaseField is (String | U64)

class Version is Stringable
  let major: U64
  let minor: U64
  let patch: U64
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
    errors = Array[String]
    // TODO: parse the string, adding raw parse errors to parseErrors
    major = 0
    minor = 0
    patch = 0
    prFields = Array[PreReleaseField]
    buildFields = Array[String]

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