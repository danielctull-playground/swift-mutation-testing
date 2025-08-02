import CoreMutation
import MutationKit
import PackageKit
import Testing

@Suite("ReverseString")
struct ReverseStringTests {

  @Test("none")
  func none() {

    let code: Source.Code = """
      func hello() {
      }
      """

    let mutants = Mutation.reverseString.mutants(for: code, in: Source(name: "name", path: "path"))

    #expect(mutants.isEmpty)
  }

  @Test("mutation")
  func mutation() throws {

    let code: Source.Code = """
      func hello() {
        print("hello, world")
      }
      """

    let mutants = Mutation.reverseString.mutants(for: code, in: Source(name: "name", path: "path"))

    try #require(mutants.count == 1)
    #expect(mutants[0].original == code)
    #expect(mutants[0].mutation == "Reverse String")
    #expect(mutants[0].location.name == "name")
    #expect(mutants[0].location.path == "path")
    #expect(mutants[0].location.start == Source.Position(line: 2, column: 10, offset: 24))
    #expect(mutants[0].location.end == Source.Position(line: 2, column: 22, offset: 36))
    #expect(mutants[0].replacement == """
      func hello() {
        print("dlrow ,olleh")
      }
      """)
  }
}

