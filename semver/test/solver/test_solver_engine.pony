use "files"
use "pony_test"
use "../../range"
use "../../solver"
use "../../version"

class \nodoc\ Scenario
  let name: String
  let source: InMemArtifactSource = source.create()
  let constraints: Array[Constraint] = Array[Constraint]
  let expected_solution: Array[Artifact] = Array[Artifact]
  var expected_error: String = ""

  new create(name':String) =>
    name = name'

  fun ref run(h: TestHelper) =>
    let result = Solver(source).solve(constraints.values())

    let label = "Scenario " + name
    h.assert_array_eq_unordered[Artifact](
      expected_solution,
      result.solution,
      label + " solution:")
    h.assert_eq[String](
      expected_error,
      result.err,
      label + " err:")

class \nodoc\ TestSolverEngine is UnitTest
  fun name(): String =>
    "SolverEngine"

  fun apply(h: TestHelper) ? =>
    let scenarios_path =
      FilePath(
        FileAuth(h.env.root),
        "semver/test/solver/scenarios")

    let foo = Directory(scenarios_path)?.entries()?

    for file_name in
      Directory(scenarios_path)?.entries()?.values()
    do
      let file_path = scenarios_path.join(file_name)?
      let scenario =
        parse(file_name, OpenFile(file_path) as File)?
      scenario.run(h)
    end

  fun parse(name': String, file: File): Scenario ? =>
    let scenario = Scenario(name')

    var section = String

    for line in file.lines() do
      if (line.at("#")) then continue end

      if (not line.at("\t")) then
        section = line.clone()
          .> strip()
        continue
      end

      let l =
        recover ref line.clone()
          .> strip()
        end

      match section
      | "Available" =>
        let parts = l.split_by(" -> ")
        let artifact =
          parse_artifact(
            parts(0)?,
            try parts(1)? else "" end)?
        scenario.source.add(artifact)
      | "Constraints" =>
        let constraint = parse_constraint(l)?
        scenario.constraints.push(constraint)
      | "Expect" =>
        let artifact = parse_artifact(l, "")?
        scenario.expected_solution.push(artifact)
      | "Error" =>
        scenario.expected_error = l.clone()
      end
    end

    scenario

  fun parse_artifact(
    id: String box,
    dep_list: String box)
    : Artifact ?
  =>
    let deps = Array[Constraint]
    for dep in dep_list.split(",").values() do
      deps.push(parse_constraint(dep)?)
    end

    let id_parts = id.split("@")
    Artifact(
      id_parts(0)?, ParseVersion(id_parts(1)?), deps)

  fun parse_constraint(c: String box): Constraint ? =>
    for rel in
      ["<="; "<"; ">="; ">"; "="].values()
    do
      try
        let rel_index = c.find(rel)?
        let c_parts = c.split_by(rel)
        let version = ParseVersion(c_parts(1)?)
        let from_version =
          if (rel.at("<")) then None else version end
        let to_version =
          if (rel.at(">")) then None else version end
        let inclusive = (rel.contains("="))
        let range =
          Range(
            from_version,
            to_version,
            inclusive,
            inclusive)
        return Constraint(c_parts(0)?, range)
      end
    end

    error
