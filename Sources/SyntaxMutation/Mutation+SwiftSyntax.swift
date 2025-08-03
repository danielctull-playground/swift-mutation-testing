import CoreMutation
import PackageKit
import Foundation
import SwiftSyntax
import SwiftParser

open class MutationVisitor: SyntaxVisitor {

  public let record: Record

  required public init(record: Record) {
    self.record = record
    super.init(viewMode: .sourceAccurate)
  }
}

extension Mutation {

  public init<Visitor: MutationVisitor>(name: Name, visitor: Visitor.Type) {
    self.init(name: name) { file in
      let syntax = Parser.parse(source: file.code.description)
      var changes: [Change] = []
      let record = Record(path: file.path, syntax: syntax) { changes.append($0) }
      let visitor = Visitor(record: record)
      visitor.walk(syntax)
      return changes
    }
  }
}

public struct Record {

  fileprivate let path: Source.Path
  fileprivate let syntax: SourceFileSyntax
  fileprivate let discover: (Mutation.Change) -> Void

  public func callAsFunction<Before: SyntaxProtocol, After: SyntaxProtocol>(
    before: Before,
    after: After
  ) {

    let converter = SourceLocationConverter(fileName: path.description, tree: syntax)
    let start = Source.Position(before.startLocation(converter: converter))
    let end = Source.Position(before.endLocation(converter: converter))
    let change = Mutation.Change(start: start, end: end) {
      let rewriter = Rewriter(before: before, after: after)
      return Source.Code(rewriter.visit(syntax))
    }
    discover(change)
  }
}

private final class Rewriter<
  Before: SyntaxProtocol,
  After: SyntaxProtocol
>: SyntaxRewriter {

  let before: Before
  let after: After

  init(before: Before, after: After) {
    self.before = before
    self.after = after
  }

  override func visitAny(_ node: Syntax) -> Syntax? {
    guard node == Syntax(before) else {
      return super.visitAny(node)
    }
    return Syntax(after)
  }
}

extension Source.Position {
  fileprivate init(_ location: SourceLocation) {
    self.init(
      line: Source.Line(location.line),
      column: Source.Column(location.column),
      offset: Source.Offset(location.offset),
    )
  }
}

extension Source.Code {
  fileprivate init(_ syntax: SourceFileSyntax) {
    self.init(data: Data(syntax.description.utf8))
  }
}
