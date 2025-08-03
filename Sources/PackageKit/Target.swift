#if canImport(System)
@preconcurrency import System
#else
@preconcurrency import SystemPackage
#endif

public struct Target: Equatable, Hashable {
  public let name: Name
  public let kind: Kind
  public let path: Path
  public let sources: [Source]
}

// MARK: - Target.Name

extension Target {
  public struct Name: Equatable, Hashable {
    let value: String
    init(_ value: String) {
      self.value = value
    }
  }
}

extension Target.Name: CustomStringConvertible {
  public var description: String { value }
}

extension Target.Name: ExpressibleByStringLiteral {
  public init(stringLiteral value: StaticString) {
    self.init(value.withUTF8Buffer { String(decoding: $0, as: UTF8.self) })
  }
}

// MARK: - Target.Kind

extension Target {
  public struct Kind: Equatable, Hashable, Sendable {
    private let value: String
    init(_ value: String) {
      self.value = value
    }
  }
}

extension Target.Kind: CustomStringConvertible {
  public var description: String { value }
}

extension Target.Kind {
  public static let executable = Self("executable")
  public static let library = Self("library")
  public static let test = Self("test")
}

// MARK: - Target.Path

extension Target {
  public struct Path: Equatable, Hashable, Sendable {
    let value: FilePath
    init(_ value: FilePath) {
      self.value = value
    }
  }
}

extension Target.Path: CustomStringConvertible {
  public var description: String { value.description }
}

extension Target.Path {
  public static func +(target: Target.Path, source: String) -> Source.Path {
    Source.Path(target.value.appending(source))
  }
}
