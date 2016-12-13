use col = "collections"
use "../range"

class _Cell
  let constraint: Constraint
  var parent: (_Cell | None) = None
  var picks: Array[Artifact] = Array[Artifact]
  let children: Array[_Cell] = Array[_Cell]
  var activated: Bool = false
  var garbage: Bool = false

  new create(constraint': Constraint) =>
    constraint = constraint'

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

class Solution
  let artifacts: Seq[Artifact] = Array[Artifact]
  var err: String = ""

  new create() => None // needed because implicit ctors are currently returning weird rcaps

class Solver
  let source: ArtifactSource

  new create(source': ArtifactSource) =>
    source = source'

  fun ref solve(constraints: Iterator[Constraint]): Solution =>
    let solution = Solution

    let pendingCells = Array[_Cell]
    for c in constraints do
      pendingCells.push(_Cell(c))
    end

    let activatedCellsByName = col.Map[String, _Cell]
    var firstConflict: (_ConflictSnapshot | None) = None

    while pendingCells.size() > 0 do
      let newPendingCells = Array[_Cell]

      for pCell in pendingCells.values() do
        if pCell.garbage then continue end

        let constraint = pCell.constraint
        let name = constraint.artifactName

        // Artifact never seen before, activate its cell
        //  - record its activation with the global list
        //  - add its dependencies to the tail of the pending cells

        let existingCell = try
          activatedCellsByName(name)
        else
          activatedCellsByName(name) = pCell
          pCell.activated = true

          pCell.picks = _allVersionsOf(name)
          (let matchIndex, let ok) = _indexOfFirstMatch(pCell.picks, [constraint.range])
          if (not ok) then
            solution.err = "no artifacts match " + constraint.string()
            return solution
          end

          _pick(pCell, matchIndex, newPendingCells)
          pCell
        end

        // New constraint is compatible with existing pick

        try
          if (constraint.range.contains(existingCell.picks(0).version)) then continue end
        end

        // New constraint is incompatible with existing pick
        //  - log if this is the first such conflict (in case we can't find a solution)
        //  - backtrack up the tree, until an alternative path is found

        if (firstConflict is None) then
          firstConflict = _ConflictSnapshot(
            Array[_Cell].concat(activatedCellsByName.values()),
            pCell.constraint,
            pCell.parent
          )
        end

        var cell: (_Cell | None) = existingCell
        let conflictingConstraint = constraint

        while true do
          match cell
          | let c: _Cell =>
            let ranges = Array[Range].push(c.constraint.range)

            // Blend in the constraint that kicked this backtracking off
            if (conflictingConstraint.artifactName == c.constraint.artifactName) then
              ranges.push(conflictingConstraint.range)
            end

            (let matchIndex, let ok) = _indexOfFirstMatch(c.picks.slice(1), ranges)
            if (ok) then
              _pruneChildren(c, activatedCellsByName)
              _pick(c, matchIndex + 1, newPendingCells)
              break
            end

            cell = c.parent
          else
            solution.err = "no solutions found: " + firstConflict.string()
            return solution
          end
        end
      end

      pendingCells.concat(newPendingCells.values())
    end

    for cell in activatedCellsByName.values() do
      try solution.artifacts.push(cell.picks(0)) end
    end
    solution
  
  fun ref _allVersionsOf(artifactName: String): Array[Artifact] =>
    // copy for isolation
    let versions = Array[Artifact].concat(source.allVersionsOf(artifactName))
    // reverse sort to make all the 'default to latest' optimizations work
    col.Sort[Array[Artifact], Artifact](versions).reverse()
  
  fun _indexOfFirstMatch(artifacts: Array[Artifact], ranges: Seq[Range]): (USize, Bool) =>
    for (i, a) in artifacts.pairs() do
      for r in ranges.values() do
        if r.contains(a.version) then return (i, true) end
      end
    end

    (0, false)
  
  fun _pick(cell: _Cell, index: USize, newCells: Array[_Cell]) =>
    cell.picks = cell.picks.slice(index)

    let cellsFromDeps = Array[_Cell]
    try
      for dep in cell.picks(0).dependsOn.values() do
        let c = _Cell(dep)
        c.parent = cell
        cellsFromDeps.push(c)
      end
    end

    cell.children.concat(cellsFromDeps.values())
    newCells.concat(cellsFromDeps.values())

  fun _pruneChildren(fromCell: _Cell, activatedCellsByName: col.Map[String, _Cell]) =>
    for cell in fromCell.children.values() do
      if cell.activated then
        try activatedCellsByName.remove(cell.constraint.artifactName) end
      end

      cell.garbage = true
      _pruneChildren(cell, activatedCellsByName)
    end

    fromCell.children.clear()
