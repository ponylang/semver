use "ponytest"
use "../../semver/range"
use "../../semver/version"
use "../../utils"

class TestRangeMatching is UnitTest
  fun name(): String =>
    "RangeMatching"

  fun apply(h: TestHelper) =>
    let v0 = ParseVersion("0.0.0")
    let v1 = ParseVersion("1.0.0")
    let v2 = ParseVersion("2.0.0")
    let v3 = ParseVersion("3.0.0")
    let v4 = ParseVersion("4.0.0")

    let conTests = [
      (Range(v1, v3), [false; true; true; true; false])
      (Range(v1, v3, false), [false; false; true; true; false])
      (Range(v1, v3, true, false), [false; true; true; false; false])
      (Range(v1, v3, false, true), [false; false; true; true; false])
      (Range(v1, v3, false, false), [false; false; true; false; false])
      (Range(None, v3), [true; true; true; true; false])
      (Range(v1, None), [false; true; true; true; true])
      (Range(None, None), [true; true; true; true; true])
    ]

    let conTestVersions = [v0; v1; v2; v3; v4]

    for (vr, expecteds) in conTests.values() do
      for (e, v) in ZipIterator[Bool, Version](expecteds.values(), conTestVersions.values()) do
        h.assert_eq[Bool](e, vr.contains(v),
          "from=" + vr.from.string() +
          ", to=" + vr.to.string() +
          ", v=" + v.string()
        )
      end
    end
