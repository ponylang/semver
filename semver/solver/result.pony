class Result
  """
  The outcome of a solve: either a list of resolved artifacts or an
  error message.
  """
  let solution: Array[Artifact]
  let err: String

  new create(solution': Array[Artifact] = Array[Artifact], err': String = "") =>
    solution = solution'
    err = err'

  fun is_err(): Bool =>
    err.size() != 0
