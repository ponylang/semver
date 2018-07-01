use "ponytest"
use "../../semver/version"

class TestVersionComparison is UnitTest
  fun name(): String =>
    "VersionComparison"

  fun apply(h: TestHelper) =>
    // Comparison rules

    let tests: Array[(String, String, Compare)] = [
      // major
      ("1.0.0", "1.0.0", Equal)
      ("2.0.0", "1.0.0", Greater)
      // minor
      ("1.2.0", "1.2.0", Equal)
      ("1.3.0", "1.2.0", Greater)
      // patch
      ("1.2.3", "1.2.3", Equal)
      ("1.2.4", "1.2.3", Greater)
      // pre-release
      ("1.2.3-foo", "1.2.3", Less)
      ("1.2.3-foo", "1.2.3-foo", Equal)
      ("1.2.3-foo.0", "1.2.3-foo.1", Less)
      ("1.2.3-foo.0", "1.2.3-foo.a", Less)
      ("1.2.3-foo.a", "1.2.3-foo.b", Less)
      ("1.2.3-foo.a", "1.2.3-foo.a", Equal)
      ("1.2.3-foo.a", "1.2.3-foo.a.b", Less)
    ]

    for (v1s, v2s, expected) in tests.values() do
      let v1 = ParseVersion(v1s)
      let v2 = ParseVersion(v2s)
      let expectedInverse =
        match expected
        | Less => Greater
        | Equal => Equal
        | Greater => Less
        end

      h.assert_eq[Compare](expected, v1.compare(v2), "v1=" + v1s + ", v2=" + v2s)
      h.assert_eq[Compare](expectedInverse, v2.compare(v1), "v1=" + v2s + ", v2=" + v1s)
    end

    // Operators

    h.assert_true(Version(1) == Version(1))
    h.assert_false(Version(1) == Version(2))

    h.assert_true(Version(1) != Version(2))
    h.assert_false(Version(1) != Version(1))

    h.assert_true(Version(1) < Version(2))
    h.assert_false(Version(1) < Version(1))

    h.assert_true(Version(1) <= Version(1))
    h.assert_true(Version(1) <= Version(2))
    h.assert_false(Version(2) <= Version(1))

    h.assert_true(Version(2) > Version(1))
    h.assert_false(Version(1) > Version(1))

    h.assert_true(Version(2) >= Version(1))
    h.assert_true(Version(2) >= Version(2))
    h.assert_false(Version(1) >= Version(2))
