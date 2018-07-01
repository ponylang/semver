use "files"
use "ponytest"
use "../../semver/range"
use "../../semver/solver"
use "../../semver/version"

class Scenario
  let name: String
  let source: InMemArtifactSource = InMemArtifactSource
  let constraints: Array[Constraint] = Array[Constraint]
  let expectedSolution: Array[Artifact] = Array[Artifact]

  new create(name':String) =>
    name = name'

  fun ref run(h: TestHelper) =>
    let label = "Scenario " + name

    let result = Solver(source).solve(constraints.values())

    if (expectedSolution.size() > 0) then
      h.assert_eq[String]("", result.err, label + " err:")
    end

    h.assert_array_eq_unordered[Artifact](expectedSolution, result.solution, label + " solution:")

class TestSolverEngine is UnitTest
  fun name(): String =>
    "SolverEngine"

  fun apply(h: TestHelper) ? =>
    let scenariosPath = FilePath(h.env.root as AmbientAuth, "test/solver/scenarios")?

    let foo = Directory(scenariosPath)?.entries()?

    for fileName in Directory(scenariosPath)?.entries()?.values() do
      let filePath = scenariosPath.join(fileName)?
      let scenario = parse(fileName, OpenFile(filePath) as File)?
      scenario.run(h)
    end

  fun parse(name': String, file: File): Scenario ? =>
    let scenario = Scenario(name')

    var section = String

    for line in file.lines() do
      if (line.at("#")) then continue end

      if (not line.at("\t")) then
        section = line.clone().>strip()
        continue
      end

      let l = recover ref line.clone().>strip() end

      match section
      | "Available" =>
        let parts = l.split_by(" -> ")
        let artifact = parseArtifact(parts(0)?, try parts(1)? else "" end)?
        scenario.source.add(artifact)
      | "Constraints" =>
        let constraint = parseConstraint(l)?
        scenario.constraints.push(constraint)
      | "Expect" =>
        let artifact = parseArtifact(l, "")?
        scenario.expectedSolution.push(artifact)
      end
    end

    scenario

  fun parseArtifact(id: String box, depList: String box): Artifact ? =>
    let deps = Array[Constraint]
    for dep in depList.split(",").values() do
      deps.push(parseConstraint(dep)?)
    end

    let idParts = id.split("@")
    Artifact(idParts(0)?, ParseVersion(idParts(1)?), deps)

  fun parseConstraint(c: String box): Constraint ? =>
    for rel in ["<="; "<"; ">="; ">"; "="].values() do
      try
        let relIndex = c.find(rel)?
        let cParts = c.split_by(rel)
        let version = ParseVersion(cParts(1)?)
        let fromVersion = if (rel.at("<")) then None else version end
        let toVersion = if (rel.at(">")) then None else version end
        let inclusive = (rel.contains("="))
        let range = Range(fromVersion, toVersion, inclusive, inclusive)
        return Constraint(cParts(0)?, range)
      end
    end

    error
