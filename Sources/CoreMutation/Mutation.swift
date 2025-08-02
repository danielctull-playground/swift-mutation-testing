import PackageKit

public struct Mutation: Sendable {

  public let name: Name
  private let changes: @Sendable (Source, Source.Code) -> [Change]

  public init(
    name: Name,
    changes: @escaping @Sendable (Source, Source.Code) -> [Change]
  ) {
    self.name = name
    self.changes = changes
  }
}

extension Mutation {

  public func mutants(for code: Source.Code, in source: Source) -> [Mutant] {
    changes(source, code).map {
      Mutant(
        mutation: name,
        location: Source.Location(
          name: source.name,
          path: source.path,
          start: $0.start,
          end: $0.end,
        ),
        original: code,
        mutate: $0.mutate
      )
    }
  }
}

// MARK: - Mutation.Name

extension Mutation {
  public struct Name: Equatable, Sendable {
    fileprivate let value: String
  }
}

extension Mutation.Name: ExpressibleByStringLiteral {
  public init(stringLiteral value: StaticString) {
    self.init(value: value.withUTF8Buffer { String(decoding: $0, as: UTF8.self) })
  }
}

extension Mutation.Name: CustomStringConvertible {
  public var description: String { value }
}

// MARK: - Mutation.Change

extension Mutation {

  public struct Change {

    fileprivate let start: Source.Position
    fileprivate let end: Source.Position
    fileprivate let mutate: () -> Source.Code

    public init(
      start: Source.Position,
      end: Source.Position,
      mutate: @escaping () -> Source.Code,
    ) {
      self.start = start
      self.end = end
      self.mutate = mutate
    }
  }
}
