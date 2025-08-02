@testable import PackageKit
import System

extension Package {
  init(name: String, path: FilePath, targets: [Target]) {
    self.init(name: Name(name), path: Path(path), targets: targets)
  }
}

extension Target {
  init(name: String, kind: Kind, path: FilePath, sources: [Source]) {
    self.init(name: Name(name), kind: kind, path: Path(path), sources: sources)
  }
}

extension Source {
  init(name: String, path: FilePath) {
    self.init(name: Name(name), path: Path(path))
  }
}

extension Source.Code.NotFound {
  init(path: FilePath) {
    self.init(path: Source.Path(path))
  }
}
