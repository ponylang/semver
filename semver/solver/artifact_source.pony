interface ArtifactSource
  """
  Provides all known versions of a named artifact to the solver.
  """

  fun ref all_versions_of(name: String): Iterator[Artifact]
    """
    Returns an iterator over every version of the named artifact.
    """
