use "collections"

class InMemArtifactSource is ArtifactSource
  let artifactSetsByName: Map[String, Set[Artifact]] = Map[String, Set[Artifact]]

  fun ref add(a: Artifact) =>
    let set = artifactSetsByName.get_or_else(a.name, Set[Artifact])
    set.add(a)
    artifactSetsByName(a.name) = set

  fun allVersionsOf(name: String): Set[Artifact] box =>
    // the one-liner makes the compiler complain that ref is not a subtype of #read
    // see: https://irclog.whitequark.org/ponylang/2016-12-11#18388387;
    // artifactSetsByName.get_or_else(name, Set[Artifact]) 
    try
      artifactSetsByName(name)
    else
      Set[Artifact]
    end
