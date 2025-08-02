import Foundation
import PackageKit
import System
import Testing

@Suite("FileManager")
struct FileManagerTests {

  @Test("code(for:)")
  func code() async throws {
    let path = try FilePath.testPackages.appending("DefaultPaths")
    let package = try await Package(path: path)

    let source = try #require(package.targets.first?.sources.first)
    #expect(source.name.description == "Test 1.swift")

    let code = try FileManager.default.code(for: source.path)
    #expect(code.description == """
    func foo() {
      print("hello, world")
    }
    
    """)
  }

  @Test("code(for:) [not found]")
  func code_notFound() async throws {
    let path = try FilePath.testPackages.appending("NotFound")
    let source = Source(name: "Name", path: path)

    #expect(throws: Source.Code.NotFound(path: path)) {
      try FileManager.default.code(for: source.path)
    }
  }
}
