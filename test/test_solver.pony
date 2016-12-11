use "ponytest"
use "../semver"
use "../semver_solver"

class TestSolver is UnitTest
  fun name(): String =>
    "Solver"
  
  fun apply(h: TestHelper) =>
    // Constraint

    h.assert_eq[String](
      "foo [1.0.0 (incl) to 2.0.0 (incl)]",
      Constraint("foo", Range(Version(1), Version(2))).string()
    )

    // Artifact

    h.assert_eq[String](
      "foo @ 1.0.0 -> [bar [1.0.0 (incl) to 2.0.0 (incl)]]",
      Artifact(
        "foo",
        Version(1),
        [Constraint("bar", Range(Version(1), Version(2)))]
      ).string()
    )
