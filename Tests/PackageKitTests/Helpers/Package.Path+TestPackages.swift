import Foundation
@testable import PackageKit
import System
import Testing

extension Package.Path {

  init(test: Package.Name) throws {
    let path = try #require(Bundle.module.path(forResource: "TestPackages", ofType: nil))
    self.init(FilePath(path).appending(test.value))
  }
}
