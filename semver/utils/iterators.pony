class EmptyIterator[A] is Iterator[A]
  """
  An iterator that yields no elements.
  """

  fun ref has_next(): Bool =>
    false

  fun ref next(): A ? =>
    error

class ZipIterator[A, B] is Iterator[(A, B)]
  """
  Pairs elements from two iterators, stopping when either is exhausted.
  """

  let ia: Iterator[A]
  let ib: Iterator[B]

  new create(ia': Iterator[A], ib': Iterator[B]) =>
    ia = ia'
    ib = ib'

  fun ref has_next(): Bool =>
    ia.has_next() and ib.has_next()

  fun ref next(): (A, B) ? =>
    (ia.next()?, ib.next()?)
