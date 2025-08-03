import PackageKit
import Testing

@Suite("Target")
struct TargetTests {

  @Suite("Kind")
  struct Kind {

    @Test("CustomStringConvertible")
    func customStringConvertible() {
      #expect(Target.Kind.executable.description == "executable")
      #expect(Target.Kind.library.description == "library")
      #expect(Target.Kind.test.description == "test")
    }

    @Test("Equatable")
    func equatable() {
      #expect(Target.Kind.executable == .executable)
      #expect(Target.Kind.executable != .library)
    }
  }

  @Suite("Target.Name")
  struct TargetNameTests {

    @Test("CustomStringConvertible")
    func customStringConvertible() {
      let name: Target.Name = "Some name"
      #expect(name.description == "Some name")
    }

    @Test("Equatable")
    func equatable() {
      let name1: Target.Name = "Some name"
      let name2: Target.Name = "Some name"
      let name3: Target.Name = "Another"
      #expect(name1 == name2)
      #expect(name1 != name3)
    }

    @Test("ExpressibleByStringLiteral")
    func expressibleByStringLiteral() {
      let name: Target.Name = "Some name"
      #expect(name == "Some name")
    }
  }

  @Suite("Path")
  struct Path {

    @Test("CustomStringConvertible")
    func customStringConvertible() async throws {
      let package = try Package.Path(test: "Package")
      let target = package + "Target"
      #expect(target.description == "\(package.description)/Target")
    }
  }
}
