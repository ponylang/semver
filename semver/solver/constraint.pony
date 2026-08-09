use "../range"

class Constraint is Stringable
  """
  A named artifact paired with the version range it must satisfy.
  """
  let artifact_name: String
  let range: Range

  new create(artifact_name': String, range': Range) =>
    artifact_name = artifact_name'
    range = range'

  fun string(): String iso^ =>
    (recover String() end)
      .> append(artifact_name + " [" + range.string() + "]")
