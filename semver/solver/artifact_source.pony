interface ArtifactSource
  fun ref allVersionsOf(name: String): Iterator[Artifact]
