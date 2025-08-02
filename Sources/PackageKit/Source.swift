import Foundation
import System

public struct Source: Equatable, Hashable {
  public let name: Name
  public let path: Path
}

// MARK: - Source.Name

extension Source {
  public struct Name: Equatable, Hashable {
    let value: String
    init(_ value: String) {
      self.value = value
    }
  }
}

extension Source.Name: CustomStringConvertible {
  public var description: String { value }
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

// MARK: - Source.Code

extension Source {
  public struct Code: Equatable, Sendable {
    fileprivate let data: Data
  }
}

extension Source.Code: CustomStringConvertible {
  public var description: String { String(decoding: data, as: UTF8.self) }
}

extension Source.Code {
  public struct NotFound: Error, Equatable {
    public let path: Source.Path
  }
}

extension FileManager {

  public func code(for path: Source.Path) throws -> Source.Code {

    guard let data = contents(atPath: path.value.string) else {
      throw Source.Code.NotFound(path: path)
    }

    return Source.Code(data: data)
  }
}
