import CoreMutation
import MutationKit
@testable import PackageKit
import Testing

@Suite("ReverseString")
struct ReverseStringTests {

  @Test("none")
  func none() {

    let file = Source.File(name: "name", path: "path", code: """
      func hello() {
      }
      """
    )

    let mutants = Mutation.reverseString.mutants(for: file)
    #expect(mutants.isEmpty)
  }

  @Test("mutation")
  func mutation() throws {

    let file = Source.File(name: "name", path: "path", code: """
      func hello() {
        print("hello, world")
      }
      """
    )

    let mutants = Mutation.reverseString.mutants(for: file)

    try #require(mutants.count == 1)
    #expect(mutants[0].original == file.code)
    #expect(mutants[0].mutation == "Reverse String")
    #expect(mutants[0].location.name == file.name)
    #expect(mutants[0].location.path == file.path)
    #expect(mutants[0].location.start == Source.Position(line: 2, column: 10, offset: 24))
    #expect(mutants[0].location.end == Source.Position(line: 2, column: 22, offset: 36))
    #expect(mutants[0].replacement == """
      func hello() {
        print("dlrow ,olleh")
      }
      """)
  }
}

