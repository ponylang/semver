use "ponytest"
use "../semver"

class TestVersionComparison is UnitTest
  fun name(): String =>
    "VersionComparison"

  fun apply(h: TestHelper) =>
    let tests = [
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
      
      
      // TODO: more tests
    ]

    for (v1s, v2s, expected) in tests.values() do
      let v1 = ParseVersion(v1s)
      let v2 = ParseVersion(v2s)
      let expectedInverse =
        match expected
        | Less => Greater
        | Equal => Equal
        | Greater => Less
        else
          Equal // should never get here but compiler complains without it
        end

      h.assert_eq[Compare](expected, v1.compare(v2), "v1=" + v1s + ", v2=" + v2s)
      h.assert_eq[Compare](expectedInverse, v2.compare(v1), "v1=" + v2s + ", v2=" + v1s)
    end
    