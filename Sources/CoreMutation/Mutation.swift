import PackageKit

public struct Mutation {

  let start: Source.Position
  let end: Source.Position
  let mutate: () -> Source.Code

  public init(
    start: Source.Position,
    end: Source.Position,
    mutate: @escaping () -> Source.Code,
  ) {
    self.start = start
    self.end = end
    self.mutate = mutate
  }
}
