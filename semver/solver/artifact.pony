use "collections"
use "../version"
use "../../utils"

class Artifact is (ComparableMixin[Artifact] & Hashable & Stringable)
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

  fun compare(that: Artifact box): Compare =>
    if (name != that.name) then return name.compare(that.name) end
    version.compare(that.version)

  fun hash(): USize =>
    name.hash() xor version.hash()

  fun string(): String iso^ =>
    let result = recover String() end
    result.append(name + " @ " + version.string() + " -> [" + ",".join(dependsOn.values()) + "]")
    result
