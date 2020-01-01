use "ponytest"
use "../../semver/utils"

class TestUtilsIterators is UnitTest
  fun name(): String =>
    "UtilsIterators"

  fun apply(h: TestHelper) ? =>
    // Empty
    h.assert_false(EmptyIterator[None].create().has_next())

    // Zip
    let z = ZipIterator[U8, U8]("A2".values(), "B".values())
    h.assert_true(z.has_next())
    (let a, let b) = z.next()?
    h.assert_eq[U8]('A', a)
    h.assert_eq[U8]('B', b)
    h.assert_false(z.has_next())
