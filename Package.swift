// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "swift-mutation-testing",
  platforms: [
    .macOS(.v14),
  ],
  products: [
    .executable(name: "swift-mutation-testing", targets: ["MutationTesting"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.6.0"),
    .package(url: "https://github.com/swiftlang/swift-subprocess.git", branch: "main"),
    .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "601.0.0"),
  ],
  targets: [

    .executableTarget(
      name: "MutationTesting",
      dependencies: [
        "CoreMutation",
        "MutationKit",
        "PackageKit",
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ],
    ),

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
      name: "SyntaxMutation",
      dependencies: [
        "CoreMutation",
        "PackageKit",
        .product(name: "SwiftParser", package: "swift-syntax"),
        .product(name: "SwiftSyntax", package: "swift-syntax"),
      ],
    ),

    .target(
      name: "MutationKit",
      dependencies: [
        "CoreMutation",
        "PackageKit",
        "SyntaxMutation",
        .product(name: "SwiftSyntax", package: "swift-syntax"),
      ],
    ),

    .testTarget(
      name: "MutationKitTests",
      dependencies: [
        "MutationKit",
        
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
