import PackageKit
import Testing

@Suite("Source")
struct SourceTests {

  @Suite("Name")
  struct Name {

    @Test("CustomStringConvertible")
    func customStringConvertible() {
      let name: Source.Name = "Some name"
      #expect(name.description == "Some name")
    }

    @Test("Equatable")
    func equatable() {
      let name1: Source.Name = "Some name"
      let name2: Source.Name = "Some name"
      let name3: Source.Name = "Another"
      #expect(name1 == name2)
      #expect(name1 != name3)
    }

    @Test("ExpressibleByStringLiteral")
    func expressibleByStringLiteral() {
      let name: Source.Name = "Some name"
      #expect(name == "Some name")
    }
  }

  @Suite("Path")
  struct Path {

    @Test("CustomStringConvertible")
    func customStringConvertible() {
      let path: Source.Path = "The/Path"
      #expect(path.description == "The/Path")
    }

    @Test("Equatable")
    func equatable() {
      let path1: Source.Path = "Some/Path"
      let path2: Source.Path = "Some/Path"
      let path3: Source.Path = "Another/Path"
      #expect(path1 == path2)
      #expect(path1 != path3)
    }

    @Test("ExpressibleByStringLiteral")
    func expressibleByStringLiteral() {
      let path: Source.Path = "Some/Path"
      #expect(path == "Some/Path")
    }
  }
}
