## Fix build failure with recent Pony compilers

Recent Pony compilers reject `else` branches on `match` expressions that are already exhaustive. The version comparison code had such an `else` as a legacy workaround, so semver wouldn't build. That's been cleaned up.

