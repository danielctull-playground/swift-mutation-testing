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
    init(_ value: FilePath) {
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

// MARK: - Decodable

extension Package {

  struct NotFound: Error {}

  public init(path: FilePath) async throws {

    let result = try await run(
      .name("swift"),
      arguments: ["package", "describe", "--type", "json"],
      workingDirectory: path,
      output: .string(limit: .max, encoding: UTF8.self)
    )

    let data = Data(result.standardOutput!.utf8)
    let package = try JSONDecoder().decode(DecodablePackage.self, from: data)

    self.init(
      name: Name(package.name),
      path: Path(path),
      targets: package.targets.map { target in
        let kind = Target.Kind(target.type)
        let targetPath = path.appending(target.path)
        return Target(
          name: Target.Name(target.name),
          kind: kind,
          path: Target.Path(targetPath),
          sources: target.sources.map { source in
            Source(
              name: Source.Name(source),
              path: Source.Path(targetPath.appending(source))
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
