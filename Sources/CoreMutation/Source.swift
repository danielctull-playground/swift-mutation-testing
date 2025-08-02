import PackageKit

extension Source {

  /// The place in the code where the mutation takes place.
  public struct Location: Equatable, Sendable {
    public let name: Name
    public let path: Path
    public let start: Position
    public let end: Position

    public init(name: Name, path: Path, start: Position, end: Position) {
      self.name = name
      self.path = path
      self.start = start
      self.end = end
    }
  }
}

// MARK: - Source.Position

extension Source {
  public struct Position: Equatable, Sendable {
    public let line: Line
    public let column: Column
    public let offset: Offset
    public init(line: Line, column: Column, offset: Offset) {
      self.line = line
      self.column = column
      self.offset = offset
    }
  }
}

// MARK: - Source.Line

extension Source {
  public struct Line: Equatable, Sendable {
    private let value: Int
    init(_ value: Int) {
      self.value = value
    }
  }
}

extension Source.Line: CustomStringConvertible {
  public var description: String { value.description }
}

extension Source.Line: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.init(value)
  }
}

// MARK: - Source.Column

extension Source {
  public struct Column: Equatable, Sendable {
    private let value: Int
    init(_ value: Int) {
      self.value = value
    }
  }
}

extension Source.Column: CustomStringConvertible {
  public var description: String { value.description }
}

extension Source.Column: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.init(value)
  }
}

// MARK: - Source.Offset

extension Source {
  public struct Offset: Equatable, Sendable {
    private let value: Int
    init(_ value: Int) {
      self.value = value
    }
  }
}

extension Source.Offset: CustomStringConvertible {
  public var description: String { value.description }
}

extension Source.Offset: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.init(value)
  }
}
