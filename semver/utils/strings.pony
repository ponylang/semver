use "collections"

primitive Strings
  """
  String predicates used during version parsing and validation.
  """
  fun contains_only(s: String, bytes: Set[U8]): Bool =>
    for byte in s.values() do
      if (not bytes.contains(byte)) then return false end
    end
    true