import Foundation
import PackageKit

public struct Mutant {
  public let mutation: Mutation.Name
  public let location: Source.Location
  public let original: Source.Code
  public let replacement: Source.Code
}
