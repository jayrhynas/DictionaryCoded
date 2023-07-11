protocol DictionaryKeyProvider {
  static var dictionaryKey: String { get }
}

struct DefaultDictionaryKeyProvider<Element>: DictionaryKeyProvider {
    static var dictionaryKey: String {
        (Element.self as? DictionaryKeyProvider.Type)?.dictionaryKey ?? "id"
    }
}

typealias DictionaryCoded<Element> = DictionaryCustomCoded<Element, DefaultDictionaryKeyProvider<Element>>

@propertyWrapper
struct DictionaryCustomCoded<Element, Provider: DictionaryKeyProvider> {
  let wrappedValue: [Element]

  init(wrappedValue: [Element]) {
    self.wrappedValue = wrappedValue
  }
}

extension DictionaryCustomCoded: Equatable where Element: Equatable {}