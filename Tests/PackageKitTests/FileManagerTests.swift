import Foundation
import PackageKit
import System
import Testing

@Suite("FileManager")
struct FileManagerTests {

  @Test("file(for:)")
  func file() async throws {
    let path = try FilePath.testPackages.appending("DefaultPaths")
    let package = try await Package(path: path)

    let source = try #require(package.targets.first?.sources.first)
    #expect(source.name.description == "Test 1.swift")

    let file = try FileManager.default.file(for: source)
    #expect(file.name == source.name)
    #expect(file.path == source.path)
    #expect(file.code.description == """
    func foo() {
      print("hello, world")
    }
    
    """)
  }

  @Test("file(for:) [not found]")
  func file_notFound() async throws {
    let path = try FilePath.testPackages.appending("NotFound")
    let source = Source(name: "Name", path: path)

    #expect(throws: Source.File.NotFound(path: path)) {
      try FileManager.default.file(for: source)
    }
  }
}
