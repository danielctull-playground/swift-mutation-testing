import Foundation
import PackageKit
import System
import Testing

@Suite("Package")
struct PackageTests {

  @Suite("Name")
  struct Name {

    @Test("CustomStringConvertible")
    func customStringConvertible() async throws {
      let path = try FilePath.testPackages.appending("DefaultPaths")
      let package = try await Package(path: path)
      #expect(package.name.description == "default-paths")
    }
  }

  @Suite("Path")
  struct Path {

    @Test("CustomStringConvertible")
    func customStringConvertible() async throws {
      let path = try FilePath.testPackages.appending("DefaultPaths")
      let package = try await Package(path: path)
      #expect(package.path.description == path.description)
    }
  }

  @Test("default paths")
  func defaultPaths() async throws {

    let path = try FilePath.testPackages.appending("DefaultPaths")
    let package = try await Package(path: path)

    #expect(package == Package(name: "default-paths", path: path, targets: [

      Target(name: "Test", kind: .test, path: path.appending("Tests").appending("Test"), sources: [
        Source(
          name: "Test 1.swift",
          path: path.appending("Tests").appending("Test").appending("Test 1.swift")
        ),
        Source(
          name: "Test 2.swift",
          path: path.appending("Tests").appending("Test").appending("Test 2.swift")
        ),
        Source(
          name: "Test Group/Test Group 1.swift",
          path: path.appending("Tests").appending("Test").appending("Test Group").appending("Test Group 1.swift")
        ),
        Source(
          name: "Test Group/Test Group 2.swift",
          path: path.appending("Tests").appending("Test").appending("Test Group").appending("Test Group 2.swift")
        ),
      ]),

      Target(name: "Library", kind: .library, path: path.appending("Sources").appending("Library"), sources: [
        Source(
          name: "Library 1.swift",
          path: path.appending("Sources").appending("Library").appending("Library 1.swift")
        ),
        Source(
          name: "Library 2.swift",
          path: path.appending("Sources").appending("Library").appending("Library 2.swift")
        ),
        Source(
          name: "Library Group/Library Group 1.swift",
          path: path.appending("Sources").appending("Library").appending("Library Group").appending("Library Group 1.swift")
        ),
        Source(
          name: "Library Group/Library Group 2.swift",
          path: path.appending("Sources").appending("Library").appending("Library Group").appending("Library Group 2.swift")
        ),
      ]),

      Target(name: "Executable", kind: .executable, path: path.appending("Sources").appending("Executable"), sources: [
        Source(
          name: "Executable 1.swift",
          path: path.appending("Sources").appending("Executable").appending("Executable 1.swift")
        ),
        Source(
          name: "Executable 2.swift",
          path: path.appending("Sources").appending("Executable").appending("Executable 2.swift")
        ),
        Source(
          name: "Executable Group/Executable Group 1.swift",
          path: path.appending("Sources").appending("Executable").appending("Executable Group").appending("Executable Group 1.swift")
        ),
        Source(
          name: "Executable Group/Executable Group 2.swift",
          path: path.appending("Sources").appending("Executable").appending("Executable Group").appending("Executable Group 2.swift")
        ),
      ]),
    ]))
  }

  @Test("custom paths")
  func customPaths() async throws {

    let path = try FilePath.testPackages.appending("CustomPaths")
    let package = try await Package(path: path)

    #expect(package == Package(name: "custom-paths", path: path, targets: [

      Target(name: "Test", kind: .test, path: path.appending("Test"), sources: [
        Source(
          name: "Test 1.swift",
          path: path.appending("Test").appending("Test 1.swift")
        ),
        Source(
          name: "Test 2.swift",
          path: path.appending("Test").appending("Test 2.swift")
        ),
        Source(
          name: "Test Group/Test Group 1.swift",
          path: path.appending("Test").appending("Test Group").appending("Test Group 1.swift")
        ),
        Source(
          name: "Test Group/Test Group 2.swift",
          path: path.appending("Test").appending("Test Group").appending("Test Group 2.swift")
        ),
      ]),

      Target(name: "Library", kind: .library, path: path.appending("Library"), sources: [
        Source(
          name: "Library 1.swift",
          path: path.appending("Library").appending("Library 1.swift")
        ),
        Source(
          name: "Library 2.swift",
          path: path.appending("Library").appending("Library 2.swift")
        ),
        Source(
          name: "Library Group/Library Group 1.swift",
          path: path.appending("Library").appending("Library Group").appending("Library Group 1.swift")
        ),
        Source(
          name: "Library Group/Library Group 2.swift",
          path: path.appending("Library").appending("Library Group").appending("Library Group 2.swift")
        ),
      ]),

      Target(name: "Executable", kind: .executable, path: path.appending("Executable"), sources: [
        Source(
          name: "Executable 1.swift",
          path: path.appending("Executable").appending("Executable 1.swift")
        ),
        Source(
          name: "Executable 2.swift",
          path: path.appending("Executable").appending("Executable 2.swift")
        ),
        Source(
          name: "Executable Group/Executable Group 1.swift",
          path: path.appending("Executable").appending("Executable Group").appending("Executable Group 1.swift")
        ),
        Source(
          name: "Executable Group/Executable Group 2.swift",
          path: path.appending("Executable").appending("Executable Group").appending("Executable Group 2.swift")
        ),
      ]),
    ]))
  }

  @Test("no package")
  func noPackage() async throws {
    let path = try FilePath.testPackages.appending("Non-Existent")
    await #expect(throws: Error.self) {
      try await Package(path: path)
    }
  }
}
