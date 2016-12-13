use "collections"
use "../version"

class Artifact is (Equatable[Artifact] & Hashable & Stringable)
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

  fun eq(that: Artifact box): Bool =>
    (name == that.name) and (version == that.version)

  fun hash(): U64 =>
    name.hash() xor version.hash()

  fun string(): String iso^ =>
    let result = recover String() end
    result.append(name + " @ " + version.string() + " -> [" + ",".join(dependsOn) + "]")
    result
