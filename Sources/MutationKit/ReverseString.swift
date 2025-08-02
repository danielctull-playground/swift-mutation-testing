import CoreMutation
import SwiftSyntax
import SyntaxMutation

extension Mutation {

  public static let reverseString = Mutation(
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
