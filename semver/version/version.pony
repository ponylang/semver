use coll = "collections"

use "../../utils"

class Version is (ComparableMixin[Version] & Stringable)
  var major: U64 = 0
  var minor: U64 = 0
  var patch: U64 = 0
  let prFields: Array[PreReleaseField] = Array[PreReleaseField]
  let buildFields: Array[String] = Array[String]
  let errors: Array[String] = Array[String]

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
    prFields.append(prFields')
    buildFields.append(buildFields')
    errors.append(ValidateFields(prFields, buildFields))

  fun compare(that: Version box): Compare =>
    CompareVersions(this, that)

  fun isValid(): Bool =>
    errors.size() == 0

  fun string(): String iso^ =>
    let result = recover String(5) end // we always need at least 5 characters ("0.0.0")

    result.append(majorMinorPatchString())

    if (prFields.size() > 0) then
      result.append("-" + preReleaseString())
    end

    if (buildFields.size() > 0) then
      result.append("+" + buildString())
    end

    result

  fun majorMinorPatchString(): String =>
    ".".join([major, minor, patch])
  
  fun preReleaseString(): String =>
    ".".join(prFields)

  fun buildString(): String =>
    ".".join(buildFields)
