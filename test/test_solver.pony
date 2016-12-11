use "ponytest"
use "../semver"
use "../semver_solver"

class TestSolver is UnitTest
  fun name(): String =>
    "Solver"
  
  fun apply(h: TestHelper) =>
    h.assert_eq[String](
      "foo [1.0.0 (incl) to 2.0.0 (incl)]",
      Constraint("foo", VersionRange(Version(1), Version(2))).string()
    )