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

    let vr1 = VersionRange(v1, v2)
    h.assert_true(vr1.fromInc)
    h.assert_true(vr1.toInc)

    let vr2 = VersionRange(v1, v2, false, false)
    h.assert_false(vr2.fromInc)
    h.assert_false(vr2.toInc)

    let vr3 = VersionRange(None, v2, false, false)
    h.assert_true(vr3.fromInc)
    h.assert_false(vr3.toInc)

    let vr4 = VersionRange(v1, None, false, false)
    h.assert_false(vr4.fromInc)
    h.assert_true(vr4.toInc)

    let vr5 = VersionRange(v1, v1, false, false)
    h.assert_true(vr5.fromInc)
    h.assert_true(vr5.toInc)

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

    // TODO: test merge

    // TODO: test overlapsWith
