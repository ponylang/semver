use "ponytest"
use "../../semver/version"

class TestVersionStringification is UnitTest
  fun name(): String =>
    "VersionStringification"

  fun apply(h: TestHelper) =>
    let v1 = Version(1)
    h.assert_eq[String]("1.0.0", v1.major_minor_patch_string())
    h.assert_eq[String]("", v1.pre_release_string())
    h.assert_eq[String]("", v1.build_string())
    h.assert_eq[String]("1.0.0", v1.string())

    let v2 = Version(2, 3, 4)
    h.assert_eq[String]("2.3.4", v2.major_minor_patch_string())
    h.assert_eq[String]("", v2.pre_release_string())
    h.assert_eq[String]("", v2.build_string())
    h.assert_eq[String]("2.3.4", v2.string())

    let v3 = Version(where major' = 3, pr_fields' = ["alpha"; 0; "beta"])
    h.assert_eq[String]("3.0.0", v3.major_minor_patch_string())
    h.assert_eq[String]("alpha.0.beta", v3.pre_release_string())
    h.assert_eq[String]("", v3.build_string())
    h.assert_eq[String]("3.0.0-alpha.0.beta", v3.string())

    let v4 = Version(where major' = 4, build_fields' = ["buildinfo"; "morebuildinfo"])
    h.assert_eq[String]("4.0.0", v4.major_minor_patch_string())
    h.assert_eq[String]("", v4.pre_release_string())
    h.assert_eq[String]("buildinfo.morebuildinfo", v4.build_string())
    h.assert_eq[String]("4.0.0+buildinfo.morebuildinfo", v4.string())

    let v5 = Version(where major' = 5, pr_fields' = ["alpha"; 0; "beta"], build_fields' = ["buildinfo"; "morebuildinfo"])
    h.assert_eq[String]("5.0.0", v5.major_minor_patch_string())
    h.assert_eq[String]("alpha.0.beta", v5.pre_release_string())
    h.assert_eq[String]("buildinfo.morebuildinfo", v5.build_string())
    h.assert_eq[String]("5.0.0-alpha.0.beta+buildinfo.morebuildinfo", v5.string())
