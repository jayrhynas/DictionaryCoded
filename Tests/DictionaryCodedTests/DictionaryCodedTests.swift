import XCTest
@testable import DictionaryCoded

final class DictionaryCodedTests: XCTestCase {
  let json = """
  {
    "things": {
      "thingA": {
        "name": "whatever",
        "color": "blue"
      }, 
      "thingB": {
        "name": "thing B name",
        "color": "red"
      },
      "thingC": {
        "name": "thing C name",
        "color": "green"
      }
    }
  }
  """.data(using: .utf8)!

  func testDecoding() throws {
    struct Thing: Codable, Equatable, DictionaryKeyProvider {
      static let dictionaryKey = "id"

      let id: String 
      let name: String
      let color: String
    }

    struct ThingsResponse: Decodable, Equatable {
      @DictionaryCoded
      var things: [Thing]
    }

    var res = try JSONDecoder().decode(ThingsResponse.self, from: json)
    res.things.sort { $0.id < $1.id }

    XCTAssertEqual(res, ThingsResponse(things: [
      Thing(id: "thingA", name: "whatever", color: "blue"),
      Thing(id: "thingB", name: "thing B name", color: "red"),
      Thing(id: "thingC", name: "thing C name", color: "green"),
    ]))
  }

  func testDefaultKey() throws {
    struct Thing: Codable, Equatable {
      let id: String 
      let name: String
      let color: String
    }

    struct ThingsResponse: Decodable, Equatable {
      @DictionaryCoded
      var things: [Thing]
    }

    var res = try JSONDecoder().decode(ThingsResponse.self, from: json)
    res.things.sort { $0.id < $1.id }

    XCTAssertEqual(res, ThingsResponse(things: [
      Thing(id: "thingA", name: "whatever", color: "blue"),
      Thing(id: "thingB", name: "thing B name", color: "red"),
      Thing(id: "thingC", name: "thing C name", color: "green"),
    ]))
  }
}
