use "collections"

interface ArtifactSource
  fun allVersionsOf(name: String): Set[Artifact] box