use col = "collections"
use "ponytest"
use "../../semver/range"
use "../../semver/solver"
use "../../semver/version"

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

    // Artifact Source

    let source = InMemArtifactSource
    h.assert_eq[USize](0, Array[Artifact].concat(source.allVersionsOf("foo")).size())

    source.add(Artifact("foo", Version(1)))
    source.add(Artifact("foo", Version(2)))
    h.assert_eq[USize](2, Array[Artifact].concat(source.allVersionsOf("foo")).size())

    source.add(Artifact("foo", Version(1), [Constraint("bar", Range(None, None))]))
    h.assert_eq[USize](2, Array[Artifact].concat(source.allVersionsOf("foo")).size())
    for a in source.allVersionsOf("foo") do
      if (a.version == Version(1)) then
        h.assert_eq[USize](1, a.dependsOn.size())
      end
    end
