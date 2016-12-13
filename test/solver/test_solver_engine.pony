use col = "collections"
use "ponytest"
use "../../semver/range"
use "../../semver/solver"
use "../../semver/version"

class TestSolverEngine is UnitTest
  fun name(): String =>
    "SolverEngine"
  
  fun apply(h: TestHelper) =>
    None

    // TODO: for each file in ./scenarios
    // - parse scenario from it
    // - run scenario
    // - note if failed
    // summarize results
