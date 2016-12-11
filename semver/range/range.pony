use "../version"

class Range is (Equatable[Range] & Stringable)
  let from: RangeBound box
  let to: RangeBound box
  let fromInc: Bool
  let toInc: Bool

  // note: from > to will result in undefined behavior
  //       decided not to raise an error for this situation
  new create(from': RangeBound box, to': RangeBound box, fromInc': Bool = true, toInc': Bool = true) =>
    var fromEqualsTo = false

    match (from', to')
    | (let f: Version box, let t: Version box) =>
      fromEqualsTo = (f == t)
    end
    
    from = from'
    to = to'
    fromInc = ((from' is None) or fromEqualsTo or fromInc')
    toInc = ((to' is None) or fromEqualsTo or toInc')
  
  fun contains(v: Version): Bool =>
    match from
    | let f: Version box =>
      match v.compare(f)
      | Less => return false
      | Equal if (not fromInc) => return false
      end
    end

    match to
    | let t: Version box =>
      match v.compare(t)
      | Equal if (not toInc) => return false
      | Greater => return false
      end
    end

    true
  
  fun eq(that: Range box): Bool =>
    RangeBoundsAreEqual(from, that.from) and
    RangeBoundsAreEqual(to, that.to) and
    (fromInc == that.fromInc) and
    (toInc == that.toInc)

  // note: ranges do not have to overlap to be merged
  fun merge(that: Range): Range =>
    (let mFrom, let mFromInc) = _mergeVersionBounds(from, that.from, fromInc, that.fromInc, Less)
    (let mTo, let mToInc) = _mergeVersionBounds(to, that.to, toInc, that.toInc, Greater)
    Range(mFrom, mTo, mFromInc, mToInc)
  
  fun _mergeVersionBounds(
    vb1: RangeBound box,
    vb2: RangeBound box,
    inc1: Bool,
    inc2: Bool,
    v1WinsIf: Compare
  ): (RangeBound box, Bool) =>
    if ((vb1 is None) or (vb2 is None)) then return (None, true) end

    match (vb1, vb2)
    | (let v1: Version box, let v2: Version box) =>
      let c = v1.compare(v2)
      if (c is Equal) then return (v1, inc1 or inc2)
      elseif (c is v1WinsIf) then return (v1, inc1)
      else return (v2, inc2)
      end
    end

    (None, true) // should never get here but compiler complains without it

  fun overlaps(that: Range): Bool =>
    _fromLessThanTo(this, that) and _fromLessThanTo(that, this)

  fun _fromLessThanTo(vr1: Range box, vr2: Range box): Bool =>
    match (vr1.from, vr2.to)
    | (let f: Version box, let t: Version box) =>
      match f.compare(t)
      | Equal if ((not vr1.fromInc) or (not vr2.toInc)) => return false
      | Greater => return false
      end
    end

    true
  
  fun string(): String iso^ =>
    let result = recover String() end
    result.append(from.string() + " ")
    result.append(if (fromInc) then "(incl)" else "(excl)" end + " to ")
    result.append(to.string() + " ")
    result.append(if (toInc) then "(incl)" else "(excl)" end)
    result
