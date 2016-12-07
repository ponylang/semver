use "utils"

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

    for (pr1, pr2) in ZipIterator[PreReleaseField, PreReleaseField](v1.prFields.values(), v2.prFields.values()) do
      match _comparePRFields(pr1, pr2)
      | Less => return Less
      | Greater => return Greater
      end
    end

    p1s.compare(p2s)

  fun _comparePRFields(p1: PreReleaseField, p2: PreReleaseField): Compare =>
    match (p1, p2)
    | (let u1: U64, let s2: String) => Less
    | (let s1: String, let u2: U64) => Greater
    | (let u1: U64, let u2: U64) => u1.compare(u2)
    | (let s1: String, let s2: String) => s1.compare(s2)
    else
      Equal // should never get here but compiler complains without it
    end
