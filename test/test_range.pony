use "ponytest"
use "../semver"
use "../utils"

class TestRange is UnitTest
  fun name(): String =>
    "Range"

  fun apply(h: TestHelper) =>
    let v0 = ParseVersion("0.0.0")
    let v1 = ParseVersion("1.0.0")
    let v2 = ParseVersion("2.0.0")
    let v3 = ParseVersion("3.0.0")
    let v4 = ParseVersion("4.0.0")

    // Inclusive / exclusive boundaries

    let incTests = [
      (Range(v1, v2), true, true),
      (Range(v1, v2, false, false), false, false),
      (Range(None, v2, false, false), true, false),
      (Range(v1, None, false, false), false, true),
      (Range(v1, v1, false, false), true, true)
    ]

    for (vr, fromInc, toInc) in incTests.values() do
      h.assert_array_eq[Bool]([fromInc, toInc], [vr.fromInc, vr.toInc],
        "from=" + vr.from.string() +
        ", to=" + vr.to.string()
      )
    end

    // Contains

    let conTests = [
      (Range(v1, v3), [false, true, true, true, false]),
      (Range(v1, v3, false), [false, false, true, true, false]),
      (Range(v1, v3, true, false), [false, true, true, false, false]),
      (Range(v1, v3, false, true), [false, false, true, true, false]),
      (Range(v1, v3, false, false), [false, false, true, false, false]),
      (Range(None, v3), [true, true, true, true, false]),
      (Range(v1, None), [false, true, true, true, true]),
      (Range(None, None), [true, true, true, true, true])
    ]

    let conTestVersions = [v0, v1, v2, v3, v4]

    for (vr, expecteds) in conTests.values() do
      for (e, v) in ZipIterator[Bool, Version](expecteds.values(), conTestVersions.values()) do
        h.assert_eq[Bool](e, vr.contains(v),
          "from=" + vr.from.string() +
          ", to=" + vr.to.string() +
          ", v=" + v.string()
        )
      end
    end

    // Merge

    let mergeTests = [
      (Range(v1, v2), Range(v2, v3), Range(v1, v3)),
      (Range(v1, v2), Range(v3, v4), Range(v1, v4)),
      (Range(v1, v2, true, false), Range(v1, v2, false, true), Range(v1, v2)),
      (Range(v2, v3), Range(v1, v4), Range(v1, v4)),
      (Range(None, v1), Range(v0, v2), Range(None, v2)),
      (Range(v1, None), Range(v0, v2), Range(v0, None)),
      (Range(None, v1), Range(v0, None), Range(None, None))
    ]

    for (vr1, vr2, expected) in mergeTests.values() do
      h.assert_eq[Range](expected, vr1.merge(vr2))
    end

    // Overlap testing

    let overlapTests = [
      (Range(v1, v2), Range(v2, v3), true),
      (Range(v1, v2), Range(v2, v3, false), false),
      (Range(v1, v3, true, false), Range(v2, v3, false, false), true),
      (Range(None, v3), Range(v0, v4), true),
      (Range(v2, None), Range(v3, v4), true),
      (Range(None, None), Range(None, None), true)
    ]

    for (vr1, vr2, expected) in overlapTests.values() do
      h.assert_eq[Bool](expected, vr1.overlaps(vr2),
        "vr1=[" + vr1.string() + "]" +
        ", vr2=[" + vr2.string() + "]"
      )
    end

    // String inspection

    h.assert_eq[String]("1.0.0 (incl) to 2.0.0 (incl)", Range(v1, v2).string())
    h.assert_eq[String]("1.0.0 (excl) to 2.0.0 (incl)", Range(v1, v2, false).string())
    h.assert_eq[String]("1.0.0 (incl) to 2.0.0 (excl)", Range(v1, v2, true, false).string())
    h.assert_eq[String]("1.0.0 (excl) to 2.0.0 (excl)", Range(v1, v2, false, false).string())
    h.assert_eq[String]("1.0.0 (incl) to None (incl)", Range(v1, None).string())
    h.assert_eq[String]("None (incl) to 2.0.0 (incl)", Range(None, v2).string())
    h.assert_eq[String]("None (incl) to None (incl)", Range(None, None).string())
