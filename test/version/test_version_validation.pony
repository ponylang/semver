use "ponytest"
use "../../semver/version"

class TestVersionValidation is UnitTest
  fun name(): String =>
    "VersionValidation"

  fun apply(h: TestHelper) =>
    let v1 = Version(1)
    h.assert_true(v1.is_valid())

    let v2 = Version(where major' = 1, pr_fields' = ["good"; "b$d"; ""; 1; "fine"], build_fields' = ["good"; "b$d"; ""; "fine"])
    h.assert_false(v2.is_valid())
    h.assert_array_eq[String]([
        "pre-release field 2 contains non-alphanumeric characters"
        "pre-release field 3 is blank"
        "build field 2 contains non-alphanumeric characters"
        "build field 3 is blank"
      ],
      v2.errors
    )
