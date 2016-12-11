use "../version"

class Artifact is Stringable
  let name: String
  let version: Version
  let dependsOn: Array[Constraint]

  new create(
    name': String,
    version': Version,
    dependsOn': Array[Constraint] = Array[Constraint]
  ) =>
    name = name'
    version = version'
    dependsOn = dependsOn'

  fun string(): String iso^ =>
    let result = recover String() end
    result.append(name + " @ " + version.string() + " -> [" + ",".join(dependsOn) + "]")
    result
