use "../semver"

class Constraint is Stringable
  let artifactName: String
  let range: VersionRange

  new create(artifactName': String, range': VersionRange) =>
    artifactName = artifactName'
    range = range'

  fun string(): String iso^ =>
    let result = recover String() end
    result.append(artifactName + " [" + range.string() + "]")
    result