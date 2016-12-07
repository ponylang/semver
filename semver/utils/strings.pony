use "collections"

primitive Strings
  fun containsOnly(s: String, bytes: Set[U8]): Bool =>
    for byte in s.values() do
      if (bytes.contains(byte) == false) then
        return false
      end
    end
    true