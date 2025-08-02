import Foundation
import PackageKit
import System
import Testing

@Suite("Source")
struct SourceTests {

  @Suite("Name")
  struct Name {

    @Test("CustomStringConvertible")
    func customStringConvertible() async throws {
      let path = try FilePath.testPackages.appending("DefaultPaths")
      let package = try await Package(path: path)

      #expect(package.targets.flatMap(\.sources).map(\.name.description) == [
        "Test 1.swift",
        "Test 2.swift",
        "Test Group/Test Group 1.swift",
        "Test Group/Test Group 2.swift",
        "Library 1.swift",
        "Library 2.swift",
        "Library Group/Library Group 1.swift",
        "Library Group/Library Group 2.swift",
        "Executable 1.swift",
        "Executable 2.swift",
        "Executable Group/Executable Group 1.swift",
        "Executable Group/Executable Group 2.swift",
      ])
    }
  }

  @Suite("Path")
  struct Path {

    @Test("CustomStringConvertible")
    func customStringConvertible() async throws {
      let path = try FilePath.testPackages.appending("DefaultPaths")
      let package = try await Package(path: path)

      #expect(package.targets.flatMap(\.sources).map(\.path.description) == [
        path.appending("Tests/Test/Test 1.swift").description,
        path.appending("Tests/Test/Test 2.swift").description,
        path.appending("Tests/Test/Test Group/Test Group 1.swift").description,
        path.appending("Tests/Test/Test Group/Test Group 2.swift").description,
        path.appending("Sources/Library/Library 1.swift").description,
        path.appending("Sources/Library/Library 2.swift").description,
        path.appending("Sources/Library/Library Group/Library Group 1.swift").description,
        path.appending("Sources/Library/Library Group/Library Group 2.swift").description,
        path.appending("Sources/Executable/Executable 1.swift").description,
        path.appending("Sources/Executable/Executable 2.swift").description,
        path.appending("Sources/Executable/Executable Group/Executable Group 1.swift").description,
        path.appending("Sources/Executable/Executable Group/Executable Group 2.swift").description,
      ])
    }
  }
}
