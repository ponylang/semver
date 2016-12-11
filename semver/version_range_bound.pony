type VersionRangeBound is (Version | None)

primitive VersionRangeBoundsAreEqual
  fun apply(vrb1: VersionRangeBound box, vrb2: VersionRangeBound box): Bool =>
    if (vrb1 is None) then return (vrb2 is None) end
    if (vrb2 is None) then return false end

    match (vrb1, vrb2)
    | (let v1: Version box, let v2: Version box) => return v1 == v2
    end

    false // should never get here