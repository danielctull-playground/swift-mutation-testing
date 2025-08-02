// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "swift-mutation-testing",
  platforms: [
    .macOS(.v14),
  ],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-subprocess.git", branch: "main"),
  ],
  targets: [

    .target(
      name: "CoreMutation",
      dependencies: [
        "PackageKit",
      ],
    ),

    .testTarget(
      name: "CoreMutationTests",
      dependencies: [
        "CoreMutation",
        "PackageKit",
      ],
    ),

    .target(
      name: "PackageKit",
      dependencies: [
        .product(name: "Subprocess", package: "swift-subprocess"),
      ],
    ),

    .testTarget(
      name: "PackageKitTests",
      dependencies: [
        "PackageKit"
      ],
      resources: [
        .copy("TestPackages"),
      ],
    ),
  ]
)
