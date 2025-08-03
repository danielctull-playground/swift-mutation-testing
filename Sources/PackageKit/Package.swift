import Foundation
import Subprocess
import System

public struct Package: Equatable, Hashable {
  public let name: Name
  public let path: Path
  public let targets: [Target]
}

// MARK: - Package.Name

extension Package {
  public struct Name: Equatable, Hashable {
    let value: String
    init(_ value: String) {
      self.value = value
    }
  }
}

extension Package.Name: CustomStringConvertible {
  public var description: String { value }
}

extension Package.Name: ExpressibleByStringLiteral {
  public init(stringLiteral value: StaticString) {
    self.init(value.withUTF8Buffer { String(decoding: $0, as: UTF8.self) })
  }
}

// MARK: - Package.Path

extension Package {
  public struct Path: Equatable, Hashable, Sendable {
    let value: FilePath
    public init(_ value: FilePath) {
      self.value = value
    }
  }
}

extension Package.Path: CustomStringConvertible {
  public var description: String { value.description }
}

extension Package.Path: ExpressibleByStringLiteral {
  public init(stringLiteral value: StaticString) {
    self.init(FilePath(value.withUTF8Buffer { String(decoding: $0, as: UTF8.self) }))
  }
}

extension Package.Path {
  public static func +(package: Package.Path, target: String) -> Target.Path {
    Target.Path(package.value.appending(target))
  }
}

// MARK: - Decodable

extension Package {

  struct NotFound: Error {}

  public init(path: Path) async throws {

    let result = try await run(
      .name("swift"),
      arguments: ["package", "describe", "--type", "json"],
      workingDirectory: path.value,
      output: .string(limit: .max, encoding: UTF8.self)
    )

    let data = Data(result.standardOutput!.utf8)
    let package = try JSONDecoder().decode(DecodablePackage.self, from: data)

    self.init(
      name: Name(package.name),
      path: path,
      targets: package.targets.map { target in
        let kind = Target.Kind(target.type)
        return Target(
          name: Target.Name(target.name),
          kind: kind,
          path: path + target.path,
          sources: target.sources.map { source in
            Source(
              name: Source.Name(source),
              path: path + target.path + source
            )
          }
        )
      }
    )
  }
}

private struct DecodablePackage: Decodable {
  let name: String
  let path: String
  let targets: [DecodableTarget]
}

private struct DecodableTarget: Decodable {
  let name: String
  let type: String
  let path: String
  let sources: [String]
}
