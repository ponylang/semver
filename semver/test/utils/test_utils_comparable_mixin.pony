use "pony_test"
use "../../utils"

class \nodoc\ AlwaysComparesAs is ComparableMixin[AlwaysComparesAs]
  let value: Compare

  new create(value': Compare) =>
    value = value'

  fun compare(that: AlwaysComparesAs box): Compare =>
    value

class TestUtilsComparableMixin is UnitTest
  fun name(): String =>
    "UtilsComparableMixin"

  fun apply(h: TestHelper) =>
    let e = AlwaysComparesAs(Equal)
    h.assert_false(e.lt(e))
    h.assert_true(e.le(e))
    h.assert_false(e.gt(e))
    h.assert_true(e.ge(e))
    h.assert_true(e.eq(e))
    h.assert_false(e.ne(e))

    let g = AlwaysComparesAs(Greater)
    h.assert_false(g.lt(g))
    h.assert_false(g.le(g))
    h.assert_true(g.gt(g))
    h.assert_true(g.ge(g))
    h.assert_false(g.eq(g))
    h.assert_true(g.ne(g))

    let l = AlwaysComparesAs(Less)
    h.assert_true(l.lt(l))
    h.assert_true(l.le(l))
    h.assert_false(l.gt(l))
    h.assert_false(l.ge(l))
    h.assert_false(l.eq(l))
    h.assert_true(l.ne(l))
