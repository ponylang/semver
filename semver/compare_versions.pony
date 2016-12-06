primitive CompareVersions
  fun apply(v1: Version box, v2: Version box): Compare =>
    if (v1.major != v2.major) then
      return v1.major.compare(v2.major)
    end

    if (v1.minor != v2.minor) then
      return v1.minor.compare(v2.minor)
    end

    if (v1.patch != v2.patch) then
      return v1.patch.compare(v2.patch)
    end

    let p1s = v1.prFields.size()
    let p2s = v2.prFields.size()

    if ((p1s == 0) and (p2s == 0)) then return Equal end
    if ((p1s == 0) and (p2s > 0)) then return Greater end
    if ((p1s > 0) and (p2s == 0)) then return Less end

    var i: USize = 0
    try // protection from the array dereference - but should never error
      while ((i < p1s) and (i < p2s)) do
        match _comparePRFields(v1.prFields(i), v2.prFields(i))
        | Less => return Less
        | Greater => return Greater
        end
      end
    end

    p1s.compare(p2s)

  fun _comparePRFields(p1: PreReleaseField, p2: PreReleaseField): Compare =>
    match (p1, p2)
    | (U64, String) => Less
    | (String, U64) => Greater
    | (let u1: U64, let u2: U64) => u1.compare(u2)
    | (let s1: String, let s2: String) => s1.compare(s2)
    else
      Equal // should never get here but compiler complains without it
    end
