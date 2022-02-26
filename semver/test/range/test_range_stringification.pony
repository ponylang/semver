use "pony_test"
use "../../range"
use "../../version"

class \nodoc\ TestRangeStringification is UnitTest
  fun name(): String =>
    "RangeStringification"

  fun apply(h: TestHelper) =>
    let v1 = ParseVersion("1.0.0")
    let v2 = ParseVersion("2.0.0")

    h.assert_eq[String]("1.0.0 (incl) to 2.0.0 (incl)", Range(v1, v2).string())
    h.assert_eq[String]("1.0.0 (excl) to 2.0.0 (incl)", Range(v1, v2, false).string())
    h.assert_eq[String]("1.0.0 (incl) to 2.0.0 (excl)", Range(v1, v2, true, false).string())
    h.assert_eq[String]("1.0.0 (excl) to 2.0.0 (excl)", Range(v1, v2, false, false).string())
    h.assert_eq[String]("1.0.0 (incl) to None (incl)", Range(v1, None).string())
    h.assert_eq[String]("None (incl) to 2.0.0 (incl)", Range(None, v2).string())
    h.assert_eq[String]("None (incl) to None (incl)", Range(None, None).string())
