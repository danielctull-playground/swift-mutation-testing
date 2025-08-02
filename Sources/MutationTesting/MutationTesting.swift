import ArgumentParser
import CoreMutation
import Foundation
import MutationKit
import PackageKit
import System

@main
struct MutationTesting: AsyncParsableCommand {

  func run() async throws {

    let path = FilePath(Process().currentDirectoryURL!.path())
    let package = try await Package(path: path)
    let fileManager = FileManager()
    let mutations = Mutation.all

    let targets = package.targets.filter { $0.kind != .test }
    let mutants = try targets.flatMap { target in
      try target.sources.flatMap { source in
        let code = try fileManager.code(for: source.path)
        return mutations.flatMap { mutation in
          mutation.mutants(for: code, in: source)
        }
      }
    }

    let mutationLength = (mutants.map(\.mutation.description.count) + ["Mutation".count]).max()!
    let nameLength = (mutants.map(\.location.name.description.count) + ["File Name".count]).max()!
    let lineLength = (mutants.map(\.location.start.line.description.count) + ["Line".count]).max()!
    let columnLength = (mutants.map(\.location.start.column.description.count) + ["Column".count]).max()!

    print("")

    print(
      "Mutation"
      + String(repeating: " ", count: mutationLength - "Mutation".count)
      + " | "
      + "File Name"
      + String(repeating: " ", count: nameLength - "File Name".count)
      + " | "
      + "Line"
      + String(repeating: " ", count: lineLength - "Line".count)
      + " | "
      + "Column"
    )

    print(
      String(repeating: "-", count: mutationLength)
      + "-+-"
      + String(repeating: "-", count: nameLength)
      + "-+-"
      + String(repeating: "-", count: lineLength)
      + "-+-"
      + String(repeating: "-", count: columnLength)
    )

    for mutant in mutants {

      let mutationSpace = String(repeating: " ", count: mutationLength - mutant.mutation.description.count)
      let nameSpace = String(repeating: " ", count: nameLength - mutant.location.name.description.count)
      let lineSpace = String(repeating: " ", count: lineLength - mutant.location.start.line.description.count)
      let columnSpace = String(repeating: " ", count: columnLength - mutant.location.start.column.description.count)

      print(
        mutant.mutation.description
        + mutationSpace
        + " | "
        + mutant.location.name.description
        + nameSpace
        + " | "
        + lineSpace
        + mutant.location.start.line.description
        + " | "
        + columnSpace
        + mutant.location.start.column.description
      )
    }
  }
}
