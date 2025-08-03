import CoreMutation
import MutationKit
@testable import PackageKit
import Testing

@Suite("ReverseString")
struct ReverseStringTests {

  @Test("empty")
  func empty() {
    let file = Source.File(name: "name", path: "path", code: "")
    let mutants = Mutator.reverseString.mutants(for: file)
    #expect(mutants.isEmpty)
  }

  @Test("none")
  func none() {

    let file = Source.File(name: "name", path: "path", code: """
      func hello() {
      }
      """
    )

    let mutants = Mutator.reverseString.mutants(for: file)
    #expect(mutants.isEmpty)
  }

  @Test("single")
  func single() throws {

    let file = Source.File(name: "name", path: "path", code: """
      func hello() {
        print("hello, world")
      }
      """
    )

    let mutants = Mutator.reverseString.mutants(for: file)

    try #require(mutants.count == 1)
    #expect(mutants[0].original == file.code)
    #expect(mutants[0].mutator == "Reverse String")
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

  @Test("multiple")
  func multiple() throws {

    let file = Source.File(name: "name", path: "path", code: """
      func foo() {
        print("hello!")
      }
      
      var bar: String { "baz" }
      """)

    let mutants = Mutator.reverseString.mutants(for: file)

    try #require(mutants.count == 2)
    #expect(mutants[0].original == file.code)
    #expect(mutants[0].mutator == "Reverse String")
    #expect(mutants[0].location.name == file.name)
    #expect(mutants[0].location.path == file.path)
    #expect(mutants[0].location.start == Source.Position(line: 2, column: 10, offset: 22))
    #expect(mutants[0].location.end == Source.Position(line: 2, column: 16, offset: 28))
    #expect(mutants[0].replacement == """
      func foo() {
        print("!olleh")
      }
      
      var bar: String { "baz" }
      """)

    #expect(mutants[1].original == file.code)
    #expect(mutants[1].mutator == "Reverse String")
    #expect(mutants[1].location.name == file.name)
    #expect(mutants[1].location.path == file.path)
    #expect(mutants[1].location.start == Source.Position(line: 5, column: 20, offset: 53))
    #expect(mutants[1].location.end == Source.Position(line: 5, column: 23, offset: 56))
    #expect(mutants[1].replacement == """
      func foo() {
        print("hello!")
      }
      
      var bar: String { "zab" }
      """)
  }

  @Test("interpolated expressions")
  func interpolatedExpressions() throws {

    let file = Source.File(name: "name", path: "path", code: #"""
      func hello(name: String) {
        print("hello \(name) and welcome!")
      }
      """#)

    let mutants = Mutator.reverseString.mutants(for: file)

    try #require(mutants.count == 2)
    #expect(mutants[0].original == file.code)
    #expect(mutants[0].mutator == "Reverse String")
    #expect(mutants[0].location.name == file.name)
    #expect(mutants[0].location.path == file.path)
    #expect(mutants[0].location.start == Source.Position(line: 2, column: 10, offset: 36))
    #expect(mutants[0].location.end == Source.Position(line: 2, column: 16, offset: 42))
    #expect(mutants[0].replacement == #"""
      func hello(name: String) {
        print(" olleh\(name) and welcome!")
      }
      """#)

    #expect(mutants[1].original == file.code)
    #expect(mutants[1].mutator == "Reverse String")
    #expect(mutants[1].location.name == file.name)
    #expect(mutants[1].location.path == file.path)
    #expect(mutants[1].location.start == Source.Position(line: 2, column: 23, offset: 49))
    #expect(mutants[1].location.end == Source.Position(line: 2, column: 36, offset: 62))
    #expect(mutants[1].replacement == #"""
      func hello(name: String) {
        print("hello \(name)!emoclew dna ")
      }
      """#)
  }
}
