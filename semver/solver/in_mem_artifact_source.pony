use "collections"
use "../../utils"

class InMemArtifactSource is ArtifactSource
  let artifactSetsByName: Map[String, Set[Artifact]] // = Map[String, Set[Artifact]]

  // this is needed as, for some reason, the default constructor returns an iso
  // so we can't just use the let-with-default above
  // the default refcap for explicit constructors is 'ref' - which is what we want
  // see: https://irclog.whitequark.org/ponylang/2016-12-11#18388988;
  new create() =>
    artifactSetsByName = Map[String, Set[Artifact]] 

  fun ref add(a: Artifact) =>
    try
      artifactSetsByName(a.name).set(a)
    else
      artifactSetsByName(a.name) = Set[Artifact].set(a)
    end

  fun ref allVersionsOf(name: String): Iterator[Artifact] =>
    try
      artifactSetsByName(name).values()
    else
      EmptyIterator[Artifact]
    end
