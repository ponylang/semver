use "collections"

// TODO: review the ponylang discussion around constants;
// the runtime cost here is silly for fixed values.
primitive Consts
  """
  Character-class sets used during version parsing and validation.
  """
  fun alphas(): Set[U8] =>
    Set[U8]
      .> union(
        ("ABCDEFGHIJKLMNOPQRSTUVWXYZ"
          + "abcdefghijklmnopqrstuvwxyz-")
          .values())

  fun nums(): Set[U8] =>
    Set[U8]
      .> union("0123456789".values())

  fun alphanums(): Set[U8] =>
    Set[U8]
      .> union(alphas().values())
      .> union(nums().values())
