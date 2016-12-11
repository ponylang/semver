use "../utils"

primitive ParseVersion
  fun apply(s: String): Version =>
    let v = Version(0)

    if (s == "") then
      v.errors.push("version string blank")
      return v
    end

    try
      let headAndBuild = s.split("+", 2)
      let headAndPreRel = headAndBuild(0).split("-", 2)

      let majMinPat = recover box headAndPreRel(0).split(".") end
      if (majMinPat.size() != 3) then
        v.errors.push("expected head of version string to be of the form 'major.minor.patch'")
        return v
      end

      for m in majMinPat.values() do
        if ((m == "") or (not Strings.containsOnly(m, Consts.nums()))) then
          v.errors.push("expected major, minor and patch to be numeric")
          return v 
        end
      end

      v.major = majMinPat(0).u64()
      v.minor = majMinPat(1).u64()
      v.patch = majMinPat(2).u64()

      if (headAndPreRel.size() == 2) then
        for p in headAndPreRel(1).split(".").values() do
          if ((p != "") and (Strings.containsOnly(p, Consts.nums()))) then
            if ((p.size() > 1) and (p.compare_sub("0", 1) is Equal)) then
              v.errors.push("numeric pre-release fields cannot have leading zeros")
            else
              v.prFields.push(p.u64())
            end
          else
            v.prFields.push(p)
          end
        end
      end

      if (headAndBuild.size() == 2) then
        v.buildFields.append(headAndBuild(1).split("."))
      end
    else
      v.errors.push("unexpected internal error")
    end

    v.errors.append(ValidateFields(v.prFields, v.buildFields))
    v
