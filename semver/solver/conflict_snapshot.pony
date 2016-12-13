class _ConflictSnapshot is Stringable
  let activatedCells: Array[_Cell]
  let constraint: Constraint
  let parent: (_Cell | None)

  new create(activatedCells': Array[_Cell], constraint': Constraint, parent': (_Cell | None)) =>
    activatedCells = activatedCells'
    constraint = constraint'
    parent = parent'
  
  fun string(): String iso^ =>
    let result = recover String end

    let activated = Array[String]
    for c in activatedCells.values() do
      try activated.push(c.picks(0).string()) end
    end

    result.append("constraint " + constraint.string())

    match parent
    | let p: _Cell box =>
      try result.append(" from " + p.picks(0).string()) end
    end

    result.append(" conflicted with picked artifacts [" + ",".join(activated) + "]")

    result
  