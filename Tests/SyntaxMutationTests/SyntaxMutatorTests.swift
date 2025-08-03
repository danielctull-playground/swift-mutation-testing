import CoreMutation
@testable import PackageKit
import SwiftSyntax
import SwiftSyntaxBuilder
import SyntaxMutation
import Testing

@Suite("SwiftSyntax Mutator")
struct SyntaxMutatorTests {

  @Test("single")
  func single() throws {

    final class Visitor: MutationVisitor {

      override func visit(_ node: CodeBlockItemListSyntax) -> SyntaxVisitorContinueKind {
        mutate(from: node, to: ExprSyntax("""
          let name = "Daniel"
          """))
        return super.visit(node)
      }
    }

    let mutator = Mutator(name: "Replace File", visitor: Visitor.self)
    let file = Source.File(name: "name", path: "path", code: "")

    let mutants = mutator.mutants(for: file)

    try #require(mutants.count == 1)
    #expect(mutants[0].original == file.code)
    #expect(mutants[0].mutator == mutator.name)
    #expect(mutants[0].location.name == file.name)
    #expect(mutants[0].location.path == file.path)
    #expect(mutants[0].location.start == Source.Position(line: 1, column: 1, offset: 0))
    #expect(mutants[0].location.end == Source.Position(line: 1, column: 1, offset: 0))
    #expect(mutants[0].replacement == """
      let name = "Daniel"
      """)
  }

  @Test("duplicate mutants are removed")
  func duplicates() throws {

    final class Visitor: MutationVisitor {

      override func visit(_ node: CodeBlockItemListSyntax) -> SyntaxVisitorContinueKind {
        mutate(from: node, to: ExprSyntax("""
          let name = "Daniel"
          """))
        mutate(from: node, to: ExprSyntax("""
          let name = "Daniel"
          """))
        return super.visit(node)
      }
    }

    let mutator = Mutator(name: "Replace File", visitor: Visitor.self)
    let file = Source.File(name: "name", path: "path", code: "")

    let mutants = mutator.mutants(for: file)

    try #require(mutants.count == 1)
    #expect(mutants[0].original == file.code)
    #expect(mutants[0].mutator == mutator.name)
    #expect(mutants[0].location.name == file.name)
    #expect(mutants[0].location.path == file.path)
    #expect(mutants[0].location.start == Source.Position(line: 1, column: 1, offset: 0))
    #expect(mutants[0].location.end == Source.Position(line: 1, column: 1, offset: 0))
    #expect(mutants[0].replacement == """
      let name = "Daniel"
      """)
  }

  @Test("non changes are not counted")
  func nonChanges() {

    final class Visitor: MutationVisitor {

      override func visit(_ node: CodeBlockItemListSyntax) -> SyntaxVisitorContinueKind {
        mutate(from: node, to: node)
        return super.visit(node)
      }
    }

    let mutator = Mutator(name: "Replace File", visitor: Visitor.self)
    let file = Source.File(name: "name", path: "path", code: """
      let name = "Daniel"
      """)

    let mutants = mutator.mutants(for: file)
    #expect(mutants.isEmpty)
  }
}
