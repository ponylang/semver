interface ArtifactSource
  fun allVersionsOf(name: String): Iterator[Artifact]
