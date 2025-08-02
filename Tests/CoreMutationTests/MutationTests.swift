import CoreMutation
import PackageKit
import Testing

@Suite("Mutation")
struct MutationTests {

  @Suite("mutants(for:)")
  struct MutantsFor {

    @Test("empty")
    func empty() {
      let mutation = Mutation(name: "test") { _, _ in [] }
      let mutants = mutation.mutants(for: "", in: Source(name: "name", path: "path"))
      #expect(mutants.isEmpty)
    }

    @Test("no change")
    func noChange() throws {
      let mutation = Mutation(name: "test") { source, code in
        [Mutation.Change(start: .start, end: .end) { "replacement" }]
      }
      let mutants = mutation.mutants(for: "original", in: Source(name: "name", path: "path"))
      try #require(mutants.count == 1)
      #expect(mutants[0].mutation == "test")
      #expect(mutants[0].location.name == "name")
      #expect(mutants[0].location.path == "path")
      #expect(mutants[0].location.start == .start)
      #expect(mutants[0].location.end == .end)
      #expect(mutants[0].original == "original")
      #expect(mutants[0].replacement == "replacement")
    }
  }

  @Suite("Name")
  struct Name {

    @Test("CustomStringConvertible")
    func customStringConvertible() {
      let name: Mutation.Name = "Some name"
      #expect(name.description == "Some name")
    }

    @Test("Equatable")
    func equatable() {
      let name1: Mutation.Name = "Some name"
      let name2: Mutation.Name = "Some name"
      let name3: Mutation.Name = "Another"
      #expect(name1 == name2)
      #expect(name1 != name3)
    }

    @Test("ExpressibleByStringLiteral")
    func expressibleByStringLiteral() {
      let name: Mutation.Name = "Some name"
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
