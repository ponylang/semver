use "../range"

class Constraint is Stringable
  let artifactName: String
  let range: Range

  new create(artifactName': String, range': Range) =>
    artifactName = artifactName'
    range = range'

  fun string(): String iso^ =>
    let result = recover String() end
    result.append(artifactName + " [" + range.string() + "]")
    result