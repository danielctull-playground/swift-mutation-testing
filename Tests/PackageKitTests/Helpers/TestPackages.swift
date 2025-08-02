import Foundation
import System
import Testing

extension FilePath {

  static var testPackages: FilePath {
    get throws {
      let path = try #require(Bundle.module.path(forResource: "TestPackages", ofType: nil))
      return FilePath(path)
    }
  }
}
