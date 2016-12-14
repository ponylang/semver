use col = "collections"
use "files"
use "ponytest"
use "../../semver/range"
use "../../semver/solver"
use "../../semver/version"

// use "debug"

class Scenario
  let name: String
  let source: InMemArtifactSource = InMemArtifactSource
  let constraints: Array[Constraint] = Array[Constraint]
  let expectations: col.Map[String, Version] = col.Map[String, Version]

  new create(name':String) =>
    name = name'

  fun run(): Bool =>
    false

class TestSolverEngine is UnitTest
  fun name(): String =>
    "SolverEngine"
  
  fun apply(h: TestHelper) ? =>
    let failedScenarioNames = Array[String]
    let scenariosPath = FilePath(h.env.root as AmbientAuth, "test/solver/scenarios")

    for fileName in Directory(scenariosPath).entries().values() do
      let filePath = scenariosPath.join(fileName)
      Debug(fileName)
      let scenario = parse(fileName, OpenFile(filePath) as File)
      if (not scenario.run()) then
        failedScenarioNames.push(scenario.name)
      end
    end

    if (failedScenarioNames.size() > 0) then
      h.env.out.print("** failed scenarios: " + ", ".join(failedScenarioNames) + " **")
    else
      h.env.out.print("** all scenarios passed **")
    end

  fun parse(name': String, file: File): Scenario ? =>
    let scenario = Scenario(name')

    var section = String

    for line in file.lines() do
      if (line.at("#")) then continue end

      if (not line.at("\t")) then
        section = line.clone().strip()
        continue
      end

      let l = line.clone().strip()

      match section
      | "Available" =>
        let parts = l.split_by(" -> ")
        let artifact = parseArtifact(parts(0), try parts(1) else "" end)
        scenario.source.add(artifact)
      | "Constraints" =>
        let constraint = parseConstraint(l)
        scenario.constraints.push(constraint)
      | "Expect" =>
        let artifact = parseArtifact(l, "")
        scenario.expectations(artifact.name) = artifact.version
      end
    end

    scenario
  
  fun parseArtifact(id: String box, depList: String box): Artifact ? =>
    let deps = Array[Constraint]
    for dep in depList.split(",").values() do
      deps.push(parseConstraint(dep))
    end

    let idParts = id.split("@")
    Artifact(idParts(0), ParseVersion(idParts(1)), deps)
  
  fun parseConstraint(c: String box): Constraint ? =>
    for rel in ["<=", "<", ">=", ">", "="].values() do
      try
        let relIndex = c.find(rel)
        let cParts = c.split_by(rel)
        let version = ParseVersion(cParts(1))
        let fromVersion = if (rel.at("<")) then None else version end
        let toVersion = if (rel.at(">")) then None else version end
        let inclusive = (rel.contains("="))
        let range = Range(fromVersion, toVersion, inclusive, inclusive)
        return Constraint(cParts(0), range)
      end
    end

    error
