use "ponytest"
use "../../semver/version"

class TestVersionStringification is UnitTest
  fun name(): String =>
    "VersionStringification"

  fun apply(h: TestHelper) =>
    let v1 = Version(1)
    h.assert_eq[String]("1.0.0", v1.majorMinorPatchString())
    h.assert_eq[String]("", v1.preReleaseString())
    h.assert_eq[String]("", v1.buildString())
    h.assert_eq[String]("1.0.0", v1.string())

    let v2 = Version(2, 3, 4)
    h.assert_eq[String]("2.3.4", v2.majorMinorPatchString())
    h.assert_eq[String]("", v2.preReleaseString())
    h.assert_eq[String]("", v2.buildString())
    h.assert_eq[String]("2.3.4", v2.string())

    let v3 = Version(where major' = 3, prFields' = ["alpha", 0, "beta"])
    h.assert_eq[String]("3.0.0", v3.majorMinorPatchString())
    h.assert_eq[String]("alpha.0.beta", v3.preReleaseString())
    h.assert_eq[String]("", v3.buildString())
    h.assert_eq[String]("3.0.0-alpha.0.beta", v3.string())

    let v4 = Version(where major' = 4, buildFields' = ["buildinfo", "morebuildinfo"])
    h.assert_eq[String]("4.0.0", v4.majorMinorPatchString())
    h.assert_eq[String]("", v4.preReleaseString())
    h.assert_eq[String]("buildinfo.morebuildinfo", v4.buildString())
    h.assert_eq[String]("4.0.0+buildinfo.morebuildinfo", v4.string())

    let v5 = Version(where major' = 5, prFields' = ["alpha", 0, "beta"], buildFields' = ["buildinfo", "morebuildinfo"])
    h.assert_eq[String]("5.0.0", v5.majorMinorPatchString())
    h.assert_eq[String]("alpha.0.beta", v5.preReleaseString())
    h.assert_eq[String]("buildinfo.morebuildinfo", v5.buildString())
    h.assert_eq[String]("5.0.0-alpha.0.beta+buildinfo.morebuildinfo", v5.string())
