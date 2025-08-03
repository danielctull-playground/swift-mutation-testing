import CoreMutation
@testable import PackageKit
import Testing

@Suite("Mutator")
struct MutatorTests {

  @Suite("mutants(for:)")
  struct MutantsFor {

    @Test("empty")
    func empty() {
      let mutator = Mutator(name: "test") { _ in [] }
      let file = Source.File(name: "name", path: "path", code: "original")
      let mutants = mutator.mutants(for: file)
      #expect(mutants.isEmpty)
    }

    @Test("change")
    func change() throws {

      let mutator = Mutator(name: "test") { file in
        [Mutator.Change(start: .start, end: .end) { "replacement" }]
      }

      let file = Source.File(name: "name", path: "path", code: "original")
      let mutants = mutator.mutants(for: file)
      try #require(mutants.count == 1)
      #expect(mutants[0].mutator == "test")
      #expect(mutants[0].location.name == "name")
      #expect(mutants[0].location.path == "path")
      #expect(mutants[0].location.start == .start)
      #expect(mutants[0].location.end == .end)
      #expect(mutants[0].original == "original")
      #expect(mutants[0].replacement == "replacement")
    }

    @Test("no changes")
    func noChanges() throws {

      let mutator = Mutator(name: "test") { file in
        [Mutator.Change(start: .start, end: .end) { file.code }]
      }

      let file = Source.File(name: "name", path: "path", code: "original")
      let mutants = mutator.mutants(for: file)
      #expect(mutants.isEmpty)
    }
  }

  @Suite("Name")
  struct Name {

    @Test("CustomStringConvertible")
    func customStringConvertible() {
      let name: Mutator.Name = "Some name"
      #expect(name.description == "Some name")
    }

    @Test("Equatable")
    func equatable() {
      let name1: Mutator.Name = "Some name"
      let name2: Mutator.Name = "Some name"
      let name3: Mutator.Name = "Another"
      #expect(name1 == name2)
      #expect(name1 != name3)
    }

    @Test("ExpressibleByStringLiteral")
    func expressibleByStringLiteral() {
      let name: Mutator.Name = "Some name"
      #expect(name == "Some name")
    }
  }
}

extension Source.Position {
  fileprivate static let start = Source.Position(line: 1, column: 2, offset: 3)
  fileprivate static let end = Source.Position(line: 4, column: 5, offset: 6)
}

extension Source.Location {

  fileprivate static let test = Source.Location(
    name: "File Name",
    path: "/File Name",
    start: Source.Position(line: 1, column: 2, offset: 3),
    end: Source.Position(line: 1, column: 2, offset: 3),
  )
}
