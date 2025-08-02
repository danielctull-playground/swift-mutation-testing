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
