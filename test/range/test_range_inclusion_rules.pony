use "ponytest"
use "../../semver/range"
use "../../semver/version"

class TestRangeInclusionRules is UnitTest
  fun name(): String =>
    "RangeInclusionRules"

  fun apply(h: TestHelper) =>
    let v1 = ParseVersion("1.0.0")
    let v2 = ParseVersion("2.0.0")

    let inc_tests = [
      (Range(v1, v2), true, true)
      (Range(v1, v2, false, false), false, false)
      (Range(None, v2, false, false), true, false)
      (Range(v1, None, false, false), false, true)
      (Range(v1, v1, false, false), true, true)
    ]

    for (vr, from_inc, to_inc) in inc_tests.values() do
      h.assert_array_eq[Bool]([from_inc; to_inc], [vr.from_inc; vr.to_inc],
        "from=" + vr.from.string() +
        ", to=" + vr.to.string()
      )
    end
