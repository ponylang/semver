class ZipIterator[A, B] is Iterator[(A, B)]
  let ia: Iterator[A] ref
  let ib: Iterator[B] ref

  new create(ia': Iterator[A] ref, ib': Iterator[B] ref) =>
    ia = ia'
    ib = ib'
  
  fun ref has_next(): Bool =>
    ia.has_next() and ib.has_next()
  
  fun ref next(): (A, B) ? =>
    (ia.next(), ib.next())
