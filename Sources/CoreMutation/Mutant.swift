import Foundation
import PackageKit

public struct Mutant {

  public let mutation: Mutation.Name
  public let location: Source.Location
  public let original: Source.Code
  private let mutate: () -> Source.Code

  public init(
    mutation: Mutation.Name,
    location: Source.Location,
    original: Source.Code,
    mutate: @escaping () -> Source.Code
  ) {
    self.mutation = mutation
    self.location = location
    self.original = original
    self.mutate = mutate
  }
}

extension Mutant {

  public var replacement: Source.Code {
    mutate()
  }
}
