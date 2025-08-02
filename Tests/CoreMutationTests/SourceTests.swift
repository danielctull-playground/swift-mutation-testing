import CoreMutation
import PackageKit
import Testing

@Suite("Source")
struct SourceTests {

  @Suite("Location")
  struct Location {

    @Test("init")
    func initialiser() {
      let location = Source.Location(
        name: "Name",
        path: "/path",
        start: Source.Position(line: 2, column: 22, offset: 30),
        end: Source.Position(line: 3, column: 16, offset: 51)
      )

      #expect(location.name == "Name")
      #expect(location.path == "/path")
      #expect(location.start.line == 2)
      #expect(location.start.column == 22)
      #expect(location.start.offset == 30)
      #expect(location.end.line == 3)
      #expect(location.end.column == 16)
      #expect(location.end.offset == 51)
    }

    @Test("Equatable")
    func equatable() {

      let p1 = Source.Position(line: 2, column: 22, offset: 30)
      let p2 = Source.Position(line: 3, column: 16, offset: 51)

      let l1 = Source.Location(name: "Name", path: "/path", start: p1, end: p2)
      let l2 = Source.Location(name: "Name", path: "/path", start: p1, end: p2)
      let l3 = Source.Location(name: "Nope", path: "/path", start: p1, end: p2)
      let l4 = Source.Location(name: "Name", path: "/nope", start: p1, end: p2)
      let l5 = Source.Location(name: "Name", path: "/path", start: p2, end: p2)
      let l6 = Source.Location(name: "Name", path: "/path", start: p1, end: p1)

      #expect(l1 == l2)
      #expect(l1 != l3)
      #expect(l1 != l4)
      #expect(l1 != l5)
      #expect(l1 != l6)
    }
  }

  @Suite("Position")
  struct Position {

    @Test("init")
    func initialiser() {
      let position = Source.Position(line: 2, column: 22, offset: 30)
      #expect(position.line == 2)
      #expect(position.column == 22)
      #expect(position.offset == 30)
    }

    @Test("Equatable")
    func equatable() {
      let position1 = Source.Position(line: 2, column: 22, offset: 30)
      let position2 = Source.Position(line: 2, column: 22, offset: 30)
      let position3 = Source.Position(line: 1, column: 22, offset: 30)
      let position4 = Source.Position(line: 2, column: 20, offset: 30)
      let position5 = Source.Position(line: 2, column: 22, offset: 31)
      #expect(position1 == position2)
      #expect(position1 != position3)
      #expect(position1 != position4)
      #expect(position1 != position5)
    }
  }

  @Suite("Line")
  struct Line {

    @Test("CustomStringConvertible")
    func customStringConvertible() {
      let line = Source.Line(1)
      #expect(line.description == "1")
    }

    @Test("Equatable")
    func equatable() {
      let line1 = Source.Line(1)
      let line2 = Source.Line(1)
      let line3 = Source.Line(3)
      #expect(line1 == line2)
      #expect(line1 != line3)
    }

    @Test("ExpressibleByIntegerLiteral")
    func expressibleByIntegerLiteral() {
      #expect(Source.Line(1) == 1)
    }
  }

  @Suite("Column")
  struct Column {

    @Test("CustomStringConvertible")
    func customStringConvertible() {
      let column = Source.Column(1)
      #expect(column.description == "1")
    }

    @Test("Equatable")
    func equatable() {
      let column1 = Source.Column(1)
      let column2 = Source.Column(1)
      let column3 = Source.Column(3)
      #expect(column1 == column2)
      #expect(column1 != column3)
    }

    @Test("ExpressibleByIntegerLiteral")
    func expressibleByIntegerLiteral() {
      #expect(Source.Column(1) == 1)
    }
  }

  @Suite("Offset")
  struct Offset {

    @Test("CustomStringConvertible")
    func customStringConvertible() {
      let offset = Source.Offset(1)
      #expect(offset.description == "1")
    }

    @Test("Equatable")
    func equatable() {
      let offset1 = Source.Offset(1)
      let offset2 = Source.Offset(1)
      let offset3 = Source.Offset(3)
      #expect(offset1 == offset2)
      #expect(offset1 != offset3)
    }

    @Test("ExpressibleByIntegerLiteral")
    func expressibleByIntegerLiteral() {
      #expect(Source.Offset(1) == 1)
    }
  }
}
