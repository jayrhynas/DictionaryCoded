import XCTest
@testable import DictionaryCoded

final class DictionaryCodedTests: XCTestCase {
  func testExample() throws {
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

    let res = try JSONDecoder().decode(ThingsResponse.self, from: json)
    XCTAssertEqual(res, ThingsResponse(things: [
      Thing(id: "thingA", name: "whatever", color: "blue"),
      Thing(id: "thingB", name: "thing B name", color: "red"),
      Thing(id: "thingC", name: "thing C name", color: "green"),
    ]))
  }
}
