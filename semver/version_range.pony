class VersionRange
  let from: VersionRangeBound box
  let to: VersionRangeBound box
  let fromInc: Bool
  let toInc: Bool

  // note: from > to will result in undefined behavior
  //       decided not to raise an error for this situation
  new create(from': VersionRangeBound box, to': VersionRangeBound box, fromInc': Bool = true, toInc': Bool = true) =>
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

  // note: ranges do not have to overlap to be merged
  fun merge(that: VersionRange): VersionRange =>
    (let mFrom, let mFromInc) = _mergeVersionBounds(from, that.from, fromInc, that.fromInc)
    (let mTo, let mToInc) = _mergeVersionBounds(to, that.to, toInc, that.toInc)
    VersionRange(mFrom, mTo, mFromInc, mToInc)
  
  fun _mergeVersionBounds(vb1: VersionRangeBound box, vb2: VersionRangeBound box, inc1: Bool, inc2: Bool): (VersionRangeBound box, Bool) =>
    if ((vb1 is None) or (vb2 is None)) then return (None, true) end

    match (vb1, vb2)
    | (let f1: Version box, let f2: Version box) =>
      match f1.compare(f2)
      | Less => return (f1, inc1)
      | Equal => return (f1, inc1 or inc2)
      | Greater => return (f2, inc2)
      end
    end

    (None, true) // should never get here but compiler complains without it

  fun overlapsWith(that: VersionRange): Bool =>
    _fromLessThanTo(this, that) and _fromLessThanTo(that, this)

  fun _fromLessThanTo(vr1: VersionRange box, vr2: VersionRange box): Bool =>
    match (vr1.from, vr2.to)
    | (let f: Version box, let t: Version box) =>
      match f.compare(t)
      | Equal if ((not vr1.fromInc) or (not vr2.toInc)) => return false
      | Greater => return false
      end
    end

    true