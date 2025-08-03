import Foundation
import System

public struct Source: Equatable, Hashable {
  public let name: Name
  public let path: Path
  public init(name: Name, path: Path) {
    self.name = name
    self.path = path
  }
}

// MARK: - Source.Name

extension Source {
  public struct Name: Equatable, Hashable, Sendable {
    let value: String
    init(_ value: String) {
      self.value = value
    }
  }
}

extension Source.Name: CustomStringConvertible {
  public var description: String { value }
}

extension Source.Name: ExpressibleByStringLiteral {
  public init(stringLiteral value: StaticString) {
    self.init(value.withUTF8Buffer { String(decoding: $0, as: UTF8.self) })
  }
}

// MARK: - Source.Path

extension Source {
  public struct Path: Equatable, Hashable, Sendable {
    fileprivate let value: FilePath
    init(_ value: FilePath) {
      self.value = value
    }
  }
}

extension Source.Path: CustomStringConvertible {
  public var description: String { value.description }
}

extension Source.Path: ExpressibleByStringLiteral {
  public init(stringLiteral value: StaticString) {
    self.init(FilePath(value.withUTF8Buffer { String(decoding: $0, as: UTF8.self) }))
  }
}

// MARK: - Source.Code

extension Source {
  public struct Code: Equatable, Sendable {
    fileprivate let data: Data
    public init(data: Data) {
      self.data = data
    }
  }
}

extension Source.Code: CustomStringConvertible {
  public var description: String { String(decoding: data, as: UTF8.self) }
}

extension Source.Code: ExpressibleByStringLiteral {
  public init(stringLiteral value: StaticString) {
    self.init(data: Data(value.withUTF8Buffer { String(decoding: $0, as: UTF8.self) }.utf8))
  }
}

// MARK: - Source.File

extension Source {
  public struct File {
    public let name: Name
    public let path: Path
    public let code: Code
  }
}

extension Source.File {
  public struct NotFound: Error, Equatable {
    public let path: Source.Path
  }
}

extension FileManager {

  public func file(for source: Source) throws -> Source.File {

    guard let data = contents(atPath: source.path.value.string) else {
      throw Source.File.NotFound(path: source.path)
    }

    return Source.File(
      name: source.name,
      path: source.path,
      code: Source.Code(data: data))
  }
}
