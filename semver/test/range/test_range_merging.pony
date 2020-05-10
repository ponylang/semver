use "ponytest"
use "../../range"
use "../../version"

class TestRangeMerging is UnitTest
  fun name(): String =>
    "RangeMerging"

  fun apply(h: TestHelper) =>
    let v0 = ParseVersion("0.0.0")
    let v1 = ParseVersion("1.0.0")
    let v2 = ParseVersion("2.0.0")
    let v3 = ParseVersion("3.0.0")
    let v4 = ParseVersion("4.0.0")

    let mergeTests = [
      (Range(v1, v2), Range(v2, v3), Range(v1, v3))
      (Range(v1, v2), Range(v3, v4), Range(v1, v4))
      (Range(v1, v2, true, false), Range(v1, v2, false, true), Range(v1, v2))
      (Range(v2, v3), Range(v1, v4), Range(v1, v4))
      (Range(None, v1), Range(v0, v2), Range(None, v2))
      (Range(v1, None), Range(v0, v2), Range(v0, None))
      (Range(None, v1), Range(v0, None), Range(None, None))
    ]

    for (vr1, vr2, expected) in mergeTests.values() do
      h.assert_eq[Range](expected, vr1.merge(vr2))
    end
