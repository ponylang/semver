type PreReleaseField is (String | U64)

class Version is Stringable
  let major: U64
  let minor: U64
  let patch: U64
  let prFields: Array[PreReleaseField]
  let buildFields: Array[String]

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