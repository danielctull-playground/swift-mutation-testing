import CoreMutation
import PackageKit
import Foundation
import SwiftSyntax
import SwiftParser

open class MutationVisitor: SyntaxVisitor {

  public let mutate: Mutate

  required public init(mutate: Mutate) {
    self.mutate = mutate
    super.init(viewMode: .sourceAccurate)
  }
}

extension Mutator {

  public init<Visitor: MutationVisitor>(name: Name, visitor: Visitor.Type) {
    self.init(name: name) { file in
      let syntax = Parser.parse(source: file.code.description)
      var mutations: [Mutation] = []
      let mutate = Mutate(path: file.path, syntax: syntax) { mutations.append($0) }
      let visitor = Visitor(mutate: mutate)
      visitor.walk(syntax)
      return mutations
    }
  }
}

public struct Mutate {

  fileprivate let path: Source.Path
  fileprivate let syntax: SourceFileSyntax
  fileprivate let apply: (Mutation) -> Void

  public func callAsFunction<Original: SyntaxProtocol, Replacement: SyntaxProtocol>(
    from original: Original,
    to replacement: Replacement
  ) {

    let converter = SourceLocationConverter(fileName: path.description, tree: syntax)
    let start = Source.Position(original.startLocation(converter: converter))
    let end = Source.Position(original.endLocation(converter: converter))
    let mutation = Mutation(start: start, end: end) {
      let rewriter = Rewriter(original: original, replacement: replacement)
      return Source.Code(rewriter.visit(syntax))
    }
    apply(mutation)
  }
}

private final class Rewriter<
  Original: SyntaxProtocol,
  Replacement: SyntaxProtocol
>: SyntaxRewriter {

  let original: Original
  let replacement: Replacement

  init(original: Original, replacement: Replacement) {
    self.original = original
    self.replacement = replacement
  }

  override func visitAny(_ node: Syntax) -> Syntax? {
    guard node == Syntax(original) else {
      return super.visitAny(node)
    }
    return Syntax(replacement)
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
