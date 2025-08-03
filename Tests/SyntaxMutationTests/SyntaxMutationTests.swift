import CoreMutation
@testable import PackageKit
import SwiftSyntax
import SwiftSyntaxBuilder
import SyntaxMutation
import Testing

@Suite("SwiftSyntax Mutation")
struct SyntaxMutationTests {

  @Test("single")
  func single() throws {

    final class Visitor: MutationVisitor {

      override func visit(_ node: CodeBlockItemListSyntax) -> SyntaxVisitorContinueKind {
        record(before: node, after: ExprSyntax("""
          let name = "Daniel"
          """))
        return super.visit(node)
      }
    }

    let mutation = Mutation(name: "Replace File", visitor: Visitor.self)
    let file = Source.File(name: "name", path: "path", code: "")

    let mutants = mutation.mutants(for: file)

    try #require(mutants.count == 1)
    #expect(mutants[0].original == file.code)
    #expect(mutants[0].mutation == mutation.name)
    #expect(mutants[0].location.name == file.name)
    #expect(mutants[0].location.path == file.path)
    #expect(mutants[0].location.start == Source.Position(line: 1, column: 1, offset: 0))
    #expect(mutants[0].location.end == Source.Position(line: 1, column: 1, offset: 0))
    #expect(mutants[0].replacement == """
      let name = "Daniel"
      """)
  }
}
