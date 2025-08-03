import CoreMutation
@testable import PackageKit
import SwiftSyntax
import SyntaxMutation
import Testing

@Suite("SwiftSyntax Mutation")
struct SyntaxMutationTests {

  @Test("empty")
  func empty() {
    let file = Source.File(name: "name", path: "path", code: "")
    let mutants = Mutation.reverseString.mutants(for: file)
    #expect(mutants.isEmpty)
  }

  @Test("single")
  func single() throws {

    let file = Source.File(name: "name", path: "path", code: """
      func foo() {
        print("hello!")
      }
      """)

    let mutants = Mutation.reverseString.mutants(for: file)

    try #require(mutants.count == 1)
    #expect(mutants[0].original == file.code)
    #expect(mutants[0].mutation == "Reverse String")
    #expect(mutants[0].location.name == file.name)
    #expect(mutants[0].location.path == file.path)
    #expect(mutants[0].location.start == Source.Position(line: 2, column: 10, offset: 22))
    #expect(mutants[0].location.end == Source.Position(line: 2, column: 16, offset: 28))
    #expect(mutants[0].replacement == """
      func foo() {
        print("!olleh")
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

    let mutants = Mutation.reverseString.mutants(for: file)

    try #require(mutants.count == 2)
    #expect(mutants[0].original == file.code)
    #expect(mutants[0].mutation == "Reverse String")
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
    #expect(mutants[1].mutation == "Reverse String")
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
}

extension Mutation {

  fileprivate static let reverseString = Mutation(
    name: "Reverse String",
    visitor: ReverseString.self,
  )
}

final private class ReverseString: MutationVisitor {

  override func visit(_ node: StringLiteralExprSyntax) -> SyntaxVisitorContinueKind {

    for segment in node.segments {
      switch segment {
      case .expressionSegment:
        continue

      case .stringSegment(let before):
        let new = String(before.content.text.reversed())
        let after = StringSegmentSyntax(content: .stringSegment(new))
        record(before: before, after: after)
      }
    }

    return super.visit(node)
  }
}
