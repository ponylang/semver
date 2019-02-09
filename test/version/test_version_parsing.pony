use "ponytest"
use "../../semver/version"

class TestVersionParsing is UnitTest
  fun name(): String =>
    "VersionParsing"

  fun apply(h: TestHelper) ? =>
    let v1 = ParseVersion("")
    h.assert_false(v1.is_valid())
    h.assert_array_eq[String](["version string blank"], v1.errors)

    let v2 = ParseVersion("1")
    h.assert_false(v2.is_valid())
    h.assert_array_eq[String](["expected head of version string to be of the form 'major.minor.patch'"], v2.errors)

    let v3 = ParseVersion("1..3")
    h.assert_false(v3.is_valid())
    h.assert_array_eq[String](["expected major, minor and patch to be numeric"], v3.errors)

    let v4 = ParseVersion("1.a.3")
    h.assert_false(v4.is_valid())
    h.assert_array_eq[String](["expected major, minor and patch to be numeric"], v4.errors)

    let v5 = ParseVersion("1.2.3")
    h.assert_true(v5.is_valid())

    let v6 = ParseVersion("1.2.3-pre.$..01.0a.0.1")
    h.assert_false(v6.is_valid())
    h.assert_array_eq[String]([
      "numeric pre-release fields cannot have leading zeros"
      "pre-release field 2 contains non-alphanumeric characters"
      "pre-release field 3 is blank"
    ], v6.errors)

    let v7 = ParseVersion("1.2.3+build.$..1")
    h.assert_false(v7.is_valid())
    h.assert_array_eq[String]([
      "build field 2 contains non-alphanumeric characters"
      "build field 3 is blank"
    ], v7.errors)

    let v8 = ParseVersion("1.2.3-pre.$..01.0a.0.1+build.$..1")
    h.assert_false(v8.is_valid())
    h.assert_array_eq[String]([
      "numeric pre-release fields cannot have leading zeros"
      "pre-release field 2 contains non-alphanumeric characters"
      "pre-release field 3 is blank"
      "build field 2 contains non-alphanumeric characters"
      "build field 3 is blank"
    ], v8.errors)

    let v9 = ParseVersion("1.2.3-pre.0a.0.1+build.1")
    h.assert_true(v9.is_valid())
    h.assert_eq[U64](1, v9.major)
    h.assert_eq[U64](2, v9.minor)
    h.assert_eq[U64](3, v9.patch)
    // TODO: work out why we cant use a union type with assert_array_eq
    // h.assert_array_eq[PreReleaseField](v9.prFields, ["alpha", 0, "beta"])
    h.assert_eq[String]("pre", v9.pr_fields(0)? as String)
    h.assert_eq[String]("0a", v9.pr_fields(1)? as String)
    h.assert_eq[U64](0, v9.pr_fields(2)? as U64)
    h.assert_eq[U64](1, v9.pr_fields(3)? as U64)
    h.assert_array_eq[String](["build"; "1"], v9.build_fields)
