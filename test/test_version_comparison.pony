use "ponytest"
use "../semver"

class TestVersionComparison is UnitTest
  fun name(): String =>
    "VersionComparison"

  fun apply(h: TestHelper) =>
    let v1 = Version(1)
    let v2 = Version(1)
    h.assert_eq[Compare](Equal, v1.compare(v2))
    h.assert_eq[Compare](Equal, v2.compare(v1))

    let v3 = Version(1)
    let v4 = Version(2)
    h.assert_eq[Compare](Less, v3.compare(v4))
    h.assert_eq[Compare](Greater, v4.compare(v3))

    // TODO: more tests