use col = "collections"
use "debug"
use "files"
use "ponytest"
use "../../semver/range"
use "../../semver/solver"
use "../../semver/version"

class Scenario
  let name: String
  let source: InMemArtifactSource = InMemArtifactSource
  let constraints: Array[Constraint] = Array[Constraint]
  let expectations: col.Map[String, Version] = col.Map[String, Version]

  new create(name':String) =>
    name = name'

  fun ref run(): Bool ? =>
    let debugPrefix = "scenario " + name + " "
    Debug(debugPrefix + "is running...")

    let result = Solver(source).solve(constraints.values())
    Debug(debugPrefix + "picks: " + ", ".join(result.solution))

    if (result.isErr() and (expectations.size() > 0)) then
      Debug(debugPrefix + "has UNEXPECTED error: " + result.err)
      return false
    end

    for a in result.solution.values() do
      let expected =
        try
          expectations(a.name)
        else
          Debug(debugPrefix + "generated unexpected artifact: " + a.string())
          return false
        end
      
      if (expected != a.version) then
        Debug(
          debugPrefix + "generated unexpected version of artifact: " +
          " got " + a.version.string() +
          " expected " + expected.string()
        )
        return false
      end

      expectations.remove(a.name)
    end

    for (name', version) in expectations.pairs() do
      Debug(
        debugPrefix + "failed to generate expected artifact: " +
        name' + "@" + version.string()
      )
    end

    expectations.size() > 0

class TestSolverEngine is UnitTest
  fun name(): String =>
    "SolverEngine"
  
  fun apply(h: TestHelper) ? =>
    let failedScenarioNames = Array[String]
    let scenariosPath = FilePath(h.env.root as AmbientAuth, "test/solver/scenarios")

    for fileName in Directory(scenariosPath).entries().values() do
      let filePath = scenariosPath.join(fileName)
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
