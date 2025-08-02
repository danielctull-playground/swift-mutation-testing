// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "default-paths",
  targets: [
    .target(name: "Library"),
    .testTarget(name: "Test"),
    .executableTarget(name: "Executable"),
  ]
)
