use "ponytest"
use "../semver"

class TestVersion is UnitTest
  fun name(): String =>
    "Version"

  fun apply(h: TestHelper) =>
    let v1 = Version(1)
    h.assert_eq[String](v1.majorMinorPatchString(), "1.0.0")
    h.assert_eq[String](v1.preReleaseString(), "")
    h.assert_eq[String](v1.buildString(), "")
    h.assert_eq[String](v1.string(), "1.0.0")

    let v2 = Version(2, 3, 4)
    h.assert_eq[String](v2.majorMinorPatchString(), "2.3.4")
    h.assert_eq[String](v2.preReleaseString(), "")
    h.assert_eq[String](v2.buildString(), "")
    h.assert_eq[String](v2.string(), "2.3.4")

    let v3 = Version(where major' = 3, prFields' = ["alpha", 0, "beta"])
    h.assert_eq[String](v3.majorMinorPatchString(), "3.0.0")
    h.assert_eq[String](v3.preReleaseString(), "alpha.0.beta")
    h.assert_eq[String](v3.buildString(), "")
    h.assert_eq[String](v3.string(), "3.0.0-alpha.0.beta")

    let v4 = Version(where major' = 4, buildFields' = ["buildinfo", "morebuildinfo"])
    h.assert_eq[String](v4.majorMinorPatchString(), "4.0.0")
    h.assert_eq[String](v4.preReleaseString(), "")
    h.assert_eq[String](v4.buildString(), "buildinfo.morebuildinfo")
    h.assert_eq[String](v4.string(), "4.0.0+buildinfo.morebuildinfo")

    let v5 = Version(where major' = 5, prFields' = ["alpha", 0, "beta"], buildFields' = ["buildinfo", "morebuildinfo"])
    h.assert_eq[String](v5.majorMinorPatchString(), "5.0.0")
    h.assert_eq[String](v5.preReleaseString(), "alpha.0.beta")
    h.assert_eq[String](v5.buildString(), "buildinfo.morebuildinfo")
    h.assert_eq[String](v5.string(), "5.0.0-alpha.0.beta+buildinfo.morebuildinfo")
