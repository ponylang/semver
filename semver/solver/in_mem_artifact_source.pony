use "collections"

class InMemArtifactSource is ArtifactSource
  let artifactSetsByName: Map[String, Set[Artifact]]// = Map[String, Set[Artifact]]

  // this is needed as, for some reason, the default constructor returns an iso
  // so we can't just use the let-with-default above
  // the default refcap for explicit constructors is 'ref' - which is what we want
  // see: https://irclog.whitequark.org/ponylang/2016-12-11#18388988;
  new create() =>
    artifactSetsByName = Map[String, Set[Artifact]]

  fun ref add(a: Artifact) =>
    try
      artifactSetsByName(a.name).set(a).size()
    else
      artifactSetsByName(a.name) = Set[Artifact].add(a)
    end

  fun allVersionsOf(name: String): Set[Artifact] box =>
    // the one-liner makes the compiler complain that ref is not a subtype of #read
    // see: https://irclog.whitequark.org/ponylang/2016-12-11#18388387;
    // artifactSetsByName.get_or_else(name, Set[Artifact]) 
    try
      artifactSetsByName(name)
    else
      Set[Artifact]
    end
