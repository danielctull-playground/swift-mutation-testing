import Foundation
@testable import PackageKit
import Testing

#if canImport(System)
@preconcurrency import System
#else
@preconcurrency import SystemPackage
#endif

@Suite("Package")
struct PackageTests {

  @Suite("Name")
  struct Name {

    @Test("CustomStringConvertible")
    func customStringConvertible() {
      let name: Package.Name = "Some name"
      #expect(name.description == "Some name")
    }

    @Test("Equatable")
    func equatable() {
      let name1: Package.Name = "Some name"
      let name2: Package.Name = "Some name"
      let name3: Package.Name = "Another"
      #expect(name1 == name2)
      #expect(name1 != name3)
    }

    @Test("ExpressibleByStringLiteral")
    func expressibleByStringLiteral() {
      let name: Package.Name = "Some name"
      #expect(name == "Some name")
    }
  }

  @Suite("Path")
  struct Path {

    @Test("CustomStringConvertible")
    func customStringConvertible() {
      let path: Package.Path = "The/Path"
      #expect(path.description == "The/Path")
    }

    @Test("Equatable")
    func equatable() {
      let path1: Package.Path = "Some/Path"
      let path2: Package.Path = "Some/Path"
      let path3: Package.Path = "Another/Path"
      #expect(path1 == path2)
      #expect(path1 != path3)
    }

    @Test("ExpressibleByStringLiteral")
    func expressibleByStringLiteral() {
      let path: Package.Path = "Some/Path"
      #expect(path == "Some/Path")
    }
  }

  @Suite("init")
  struct InitTests {

    @Test("default paths")
    func defaultPaths() async throws {

      let path = try Package.Path(test: "DefaultPaths")
      let package = try await Package(path: path)

      #expect(package == Package(name: "default-paths", path: path, targets: [

        Target(name: "Test", kind: .test, path: path + "Tests/Test", sources: [
          Source(
            name: "Test 1.swift",
            path: path + "Tests/Test" + "Test 1.swift"
          ),
          Source(
            name: "Test 2.swift",
            path: path + "Tests/Test" + "Test 2.swift"
          ),
          Source(
            name: "Test Group/Test Group 1.swift",
            path: path + "Tests/Test" + "Test Group/Test Group 1.swift"
          ),
          Source(
            name: "Test Group/Test Group 2.swift",
            path: path + "Tests/Test" + "Test Group/Test Group 2.swift"
          ),
        ]),

        Target(name: "Library", kind: .library, path: path + "Sources/Library", sources: [
          Source(
            name: "Library 1.swift",
            path: path + "Sources/Library" + "Library 1.swift"
          ),
          Source(
            name: "Library 2.swift",
            path: path + "Sources/Library" + "Library 2.swift"
          ),
          Source(
            name: "Library Group/Library Group 1.swift",
            path: path + "Sources/Library" + "Library Group/Library Group 1.swift"
          ),
          Source(
            name: "Library Group/Library Group 2.swift",
            path: path + "Sources/Library" + "Library Group/Library Group 2.swift"
          ),
        ]),

        Target(name: "Executable", kind: .executable, path: path + "Sources/Executable", sources: [
          Source(
            name: "Executable 1.swift",
            path: path + "Sources/Executable" + "Executable 1.swift"
          ),
          Source(
            name: "Executable 2.swift",
            path: path + "Sources/Executable" + "Executable 2.swift"
          ),
          Source(
            name: "Executable Group/Executable Group 1.swift",
            path: path + "Sources/Executable" + "Executable Group/Executable Group 1.swift"
          ),
          Source(
            name: "Executable Group/Executable Group 2.swift",
            path: path + "Sources/Executable" + "Executable Group/Executable Group 2.swift"
          ),
        ]),
      ]))
    }

    @Test("custom paths")
    func customPaths() async throws {

      let path = try Package.Path(test: "CustomPaths")
      let package = try await Package(path: path)

      #expect(package == Package(name: "custom-paths", path: path, targets: [

        Target(name: "Test", kind: .test, path: path + "Test", sources: [
          Source(
            name: "Test 1.swift",
            path: path + "Test" + "Test 1.swift"
          ),
          Source(
            name: "Test 2.swift",
            path: path + "Test" + "Test 2.swift"
          ),
          Source(
            name: "Test Group/Test Group 1.swift",
            path: path + "Test" + "Test Group/Test Group 1.swift"
          ),
          Source(
            name: "Test Group/Test Group 2.swift",
            path: path + "Test" + "Test Group/Test Group 2.swift"
          ),
        ]),

        Target(name: "Library", kind: .library, path: path + "Library", sources: [
          Source(
            name: "Library 1.swift",
            path: path + "Library" + "Library 1.swift"
          ),
          Source(
            name: "Library 2.swift",
            path: path + "Library" + "Library 2.swift"
          ),
          Source(
            name: "Library Group/Library Group 1.swift",
            path: path + "Library" + "Library Group/Library Group 1.swift"
          ),
          Source(
            name: "Library Group/Library Group 2.swift",
            path: path + "Library" + "Library Group/Library Group 2.swift"
          ),
        ]),

        Target(name: "Executable", kind: .executable, path: path + "Executable", sources: [
          Source(
            name: "Executable 1.swift",
            path: path + "Executable" + "Executable 1.swift"
          ),
          Source(
            name: "Executable 2.swift",
            path: path + "Executable" + "Executable 2.swift"
          ),
          Source(
            name: "Executable Group/Executable Group 1.swift",
            path: path + "Executable" + "Executable Group/Executable Group 1.swift"
          ),
          Source(
            name: "Executable Group/Executable Group 2.swift",
            path: path + "Executable" + "Executable Group/Executable Group 2.swift"
          ),
        ]),
      ]))
    }

    @Test("no package")
    func noPackage() async throws {
      let path = try Package.Path(test: "Non-Existent")
      await #expect(throws: Error.self) {
        try await Package(path: path)
      }
    }
  }
}
