use "ponytest"
use "../semver"
use "../utils"

class TestVersionRange is UnitTest
  fun name(): String =>
    "VersionRange"

  fun apply(h: TestHelper) =>
    let v0 = ParseVersion("0.0.0")
    let v1 = ParseVersion("1.0.0")
    let v2 = ParseVersion("2.0.0")
    let v3 = ParseVersion("3.0.0")
    let v4 = ParseVersion("4.0.0")

    // Inclusive / exclusive boundaries

    let incTests = [
      (VersionRange(v1, v2), true, true),
      (VersionRange(v1, v2, false, false), false, false),
      (VersionRange(None, v2, false, false), true, false),
      (VersionRange(v1, None, false, false), false, true),
      (VersionRange(v1, v1, false, false), true, true)
    ]

    for (vr, fromInc, toInc) in incTests.values() do
      h.assert_array_eq[Bool]([fromInc, toInc], [vr.fromInc, vr.toInc],
        "from=" + vr.from.string() +
        ", to=" + vr.to.string()
      )
    end

    // Contains

    let conTests = [
      (VersionRange(v1, v3), [false, true, true, true, false]),
      (VersionRange(v1, v3, false), [false, false, true, true, false]),
      (VersionRange(v1, v3, true, false), [false, true, true, false, false]),
      (VersionRange(v1, v3, false, true), [false, false, true, true, false]),
      (VersionRange(v1, v3, false, false), [false, false, true, false, false]),
      (VersionRange(None, v3), [true, true, true, true, false]),
      (VersionRange(v1, None), [false, true, true, true, true]),
      (VersionRange(None, None), [true, true, true, true, true])
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
      (VersionRange(v1, v2), VersionRange(v2, v3), VersionRange(v1, v3)),
      (VersionRange(v1, v2), VersionRange(v3, v4), VersionRange(v1, v4)),
      (VersionRange(v1, v2, true, false), VersionRange(v1, v2, false, true), VersionRange(v1, v2)),
      (VersionRange(v2, v3), VersionRange(v1, v4), VersionRange(v1, v4)),
      (VersionRange(None, v1), VersionRange(v0, v2), VersionRange(None, v2)),
      (VersionRange(v1, None), VersionRange(v0, v2), VersionRange(v0, None)),
      (VersionRange(None, v1), VersionRange(v0, None), VersionRange(None, None))
    ]

    for (vr1, vr2, expected) in mergeTests.values() do
      h.assert_eq[VersionRange](expected, vr1.merge(vr2))
    end

    // Overlap testing

    let overlapTests = [
      (VersionRange(v1, v2), VersionRange(v2, v3), true),
      (VersionRange(v1, v2), VersionRange(v2, v3, false), false),
      (VersionRange(v1, v3, true, false), VersionRange(v2, v3, false, false), true),
      (VersionRange(None, v3), VersionRange(v0, v4), true),
      (VersionRange(v2, None), VersionRange(v3, v4), true),
      (VersionRange(None, None), VersionRange(None, None), true)
    ]

    for (vr1, vr2, expected) in overlapTests.values() do
      h.assert_eq[Bool](expected, vr1.overlaps(vr2),
        "vr1=[" + vr1.string() + "]" +
        ", vr2=[" + vr2.string() + "]"
      )
    end
