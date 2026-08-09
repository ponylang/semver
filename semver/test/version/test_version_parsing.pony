use "pony_test"
use "../../version"

class \nodoc\ TestVersionParsing is UnitTest
  fun name(): String =>
    "VersionParsing"

  fun apply(h: TestHelper) ? =>
    let v1 = ParseVersion("")
    h.assert_false(v1.is_valid())
    h.assert_array_eq[String](
      ["version string blank"], v1.errors)

    let v2 = ParseVersion("1")
    h.assert_false(v2.is_valid())
    let v2_err =
      "expected head of version string" +
      " to be of the form 'major.minor.patch'"
    h.assert_array_eq[String](
      [v2_err], v2.errors)

    let v3 = ParseVersion("1..3")
    h.assert_false(v3.is_valid())
    let v3_err =
      "expected major, minor and patch" +
      " to be numeric"
    h.assert_array_eq[String](
      [v3_err], v3.errors)

    let v4 = ParseVersion("1.a.3")
    h.assert_false(v4.is_valid())
    h.assert_array_eq[String](
      [v3_err], v4.errors)

    let v5 = ParseVersion("1.2.3")
    h.assert_true(v5.is_valid())

    let v6 =
      ParseVersion("1.2.3-pre.$..01.0a.0.1")
    h.assert_false(v6.is_valid())
    let v6_pr_err =
      "numeric pre-release fields" +
      " cannot have leading zeros"
    let v6_f2_err =
      "pre-release field 2 contains" +
      " non-alphanumeric characters"
    h.assert_array_eq[String](
      [
        v6_pr_err
        v6_f2_err
        "pre-release field 3 is blank"
      ],
      v6.errors)

    let v7 = ParseVersion("1.2.3+build.$..1")
    h.assert_false(v7.is_valid())
    let v7_f2_err =
      "build field 2 contains" +
      " non-alphanumeric characters"
    h.assert_array_eq[String](
      [
        v7_f2_err
        "build field 3 is blank"
      ],
      v7.errors)

    let v8_str =
      "1.2.3-pre.$..01.0a.0.1" +
      "+build.$..1"
    let v8 = ParseVersion(v8_str)
    h.assert_false(v8.is_valid())
    h.assert_array_eq[String](
      [
        v6_pr_err
        v6_f2_err
        "pre-release field 3 is blank"
        v7_f2_err
        "build field 3 is blank"
      ],
      v8.errors)

    let v9_str =
      "1.2.3-pre.0a.0.1+build.1"
    let v9 = ParseVersion(v9_str)
    h.assert_true(v9.is_valid())
    h.assert_eq[U64](1, v9.major)
    h.assert_eq[U64](2, v9.minor)
    h.assert_eq[U64](3, v9.patch)
    h.assert_eq[String](
      "pre", v9.pr_fields(0)? as String)
    h.assert_eq[String](
      "0a", v9.pr_fields(1)? as String)
    h.assert_eq[U64](
      0, v9.pr_fields(2)? as U64)
    h.assert_eq[U64](
      1, v9.pr_fields(3)? as U64)
    h.assert_array_eq[String](
      ["build"; "1"], v9.build_fields)
