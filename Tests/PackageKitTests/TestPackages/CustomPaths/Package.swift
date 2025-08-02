// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "custom-paths",
  targets: [
    .target(name: "Library", path: "Library"),
    .testTarget(name: "Test", path: "Test"),
    .executableTarget(name: "Executable", path: "Executable"),
  ]
)
