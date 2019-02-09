use col = "collections"
use "ponytest"
use "../../semver/range"
use "../../semver/solver"
use "../../semver/version"

class TestSolverSupportClasses is UnitTest
  fun name(): String =>
    "SolverSupportClasses"

  fun apply(h: TestHelper) =>
    // Constraint

    h.assert_eq[String](
      "foo [1.0.0 (incl) to 2.0.0 (incl)]",
      Constraint("foo", Range(Version(1), Version(2))).string()
    )

    // Artifact

    let a1 = Artifact("foo", Version(1),
      [Constraint("bar", Range(Version(1), Version(2)))]
    )
    let a2 = Artifact("foo", Version(1))
    let a3 = Artifact("foo", Version(2))
    let a4 = Artifact("bar", Version(3))

    h.assert_eq[String]("foo @ 1.0.0 -> [bar [1.0.0 (incl) to 2.0.0 (incl)]]", a1.string())
    h.assert_eq[String]("foo @ 1.0.0 -> []", a2.string())
    h.assert_eq[String]("foo @ 2.0.0 -> []", a3.string())
    h.assert_eq[String]("bar @ 3.0.0 -> []", a4.string())

    h.assert_eq[Compare](Equal, a1.compare(a2))
    h.assert_eq[Compare](Less, a1.compare(a3))
    h.assert_eq[Compare](Greater, a1.compare(a4))

    // Artifact Source

    let source = InMemArtifactSource
    h.assert_eq[USize](0, Array[Artifact].>concat(source.all_versions_of("foo")).size())

    source.add(Artifact("foo", Version(1)))
    source.add(Artifact("foo", Version(2)))
    h.assert_eq[USize](2, Array[Artifact].>concat(source.all_versions_of("foo")).size())

    source.add(Artifact("foo", Version(1), [Constraint("bar", Range(None, None))]))
    h.assert_eq[USize](2, Array[Artifact].>concat(source.all_versions_of("foo")).size())
    for a in source.all_versions_of("foo") do
      if (a.version == Version(1)) then
        h.assert_eq[USize](1, a.depends_on.size())
      end
    end
