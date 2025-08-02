import Foundation
import PackageKit
import System
import Testing

@Suite("Target")
struct TargetTests {

  @Suite("Name")
  struct Name {

    @Test("CustomStringConvertible")
    func customStringConvertible() async throws {

      let path = try FilePath.testPackages.appending("DefaultPaths")
      let package = try await Package(path: path)

      #expect(package.targets.map(\.name.description) == [
        "Test",
        "Library",
        "Executable",
      ])
    }
  }

  @Suite("Kind")
  struct Kind {

    @Test("CustomStringConvertible")
    func customStringConvertible() async throws {

      let path = try FilePath.testPackages.appending("DefaultPaths")
      let package = try await Package(path: path)

      #expect(package.targets.map(\.kind.description) == [
        "test",
        "library",
        "executable",
      ])
    }
  }

  @Suite("Path")
  struct Path {

    @Test("CustomStringConvertible")
    func customStringConvertible() async throws {

      let path = try FilePath.testPackages.appending("DefaultPaths")
      let package = try await Package(path: path)

      #expect(package.targets.map(\.path.description) == [
        path.appending("Tests").appending("Test").description,
        path.appending("Sources").appending("Library").description,
        path.appending("Sources").appending("Executable").description,
      ])
    }
  }
}
