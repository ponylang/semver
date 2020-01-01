use "collections"
use "ponytest"
use "../../semver/utils"

class TestUtilsStrings is UnitTest
  fun name(): String =>
    "UtilsStrings"

  fun apply(h: TestHelper) =>
    let abc = Set[U8].>union("abc".values())
    h.assert_true(Strings.contains_only("a", abc))
    h.assert_true(Strings.contains_only("abcabc", abc))
    h.assert_false(Strings.contains_only("d", abc))
    h.assert_false(Strings.contains_only("abcd", abc))
