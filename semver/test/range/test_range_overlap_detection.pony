use "pony_test"
use "../../range"
use "../../version"

class \nodoc\ TestRangeOverlapDetection is UnitTest
  fun name(): String =>
    "RangeOverlapDetection"

  fun apply(h: TestHelper) =>
    let v0 = ParseVersion("0.0.0")
    let v1 = ParseVersion("1.0.0")
    let v2 = ParseVersion("2.0.0")
    let v3 = ParseVersion("3.0.0")
    let v4 = ParseVersion("4.0.0")

    let overlapTests = [
      (Range(v1, v2), Range(v2, v3), true)
      (Range(v1, v2), Range(v2, v3, false), false)
      (Range(v1, v3, true, false), Range(v2, v3, false, false), true)
      (Range(None, v3), Range(v0, v4), true)
      (Range(v2, None), Range(v3, v4), true)
      (Range(None, None), Range(None, None), true)
    ]

    for (vr1, vr2, expected) in overlapTests.values() do
      h.assert_eq[Bool](expected, vr1.overlaps(vr2),
        "vr1=[" + vr1.string() + "]" +
        ", vr2=[" + vr2.string() + "]"
      )
    end
