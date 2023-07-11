extension DictionaryCustomCoded: Decodable where Element: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AnyCodingKey.self)

    self.wrappedValue = try container.allKeys.map { key in
      return try container.decode(Wrapper.self, forKey: key).value
    }
  }
}

fileprivate extension DictionaryCustomCoded {
  struct Wrapper<T: Decodable>: Decodable {
    let value: T

    init(from decoder: Decoder) throws {
      self.value = try T(from: DecoderInterceptor(base: decoder))
    }
  }

  struct DecoderInterceptor: Decoder {
    let base: Decoder
    
    func container<Key: CodingKey>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
      try KeyedDecodingContainer(KeyedContainerInterceptor(base: base.container(keyedBy: type)))
    }
  }

  struct KeyedContainerInterceptor<Base: KeyedDecodingContainerProtocol>: KeyedDecodingContainerProtocol {
    typealias Key = Base.Key

    let base: Base

    func decode(_ type: String.Type, forKey key: Key) throws -> String { 
      if key.stringValue == Provider.dictionaryKey {
        return codingPath.last!.stringValue
      }
      return try base.decode(type, forKey: key)
    }
  }
}

// MARK: - Passthrough Implementations

fileprivate extension DictionaryCustomCoded.DecoderInterceptor {
  var codingPath: [CodingKey] { base.codingPath }
  var userInfo: [CodingUserInfoKey : Any] { base.userInfo }
  func unkeyedContainer() throws -> UnkeyedDecodingContainer { try base.unkeyedContainer() }
  func singleValueContainer() throws -> SingleValueDecodingContainer { try base.singleValueContainer() }
}

fileprivate extension DictionaryCustomCoded.KeyedContainerInterceptor {
  var codingPath: [CodingKey] { base.codingPath }
  var allKeys: [Key] { base.allKeys }
  func contains(_ key: Key) -> Bool { base.contains(key) }
  func decodeNil(forKey key: Key) throws -> Bool { try base.decodeNil(forKey: key) }
  func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool { try base.decode(type, forKey: key) }
  func decode(_ type: Double.Type, forKey key: Key) throws -> Double { try base.decode(type, forKey: key) }
  func decode(_ type: Float.Type, forKey key: Key) throws -> Float { try base.decode(type, forKey: key) }
  func decode(_ type: Int.Type, forKey key: Key) throws -> Int { try base.decode(type, forKey: key) }
  func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 { try base.decode(type, forKey: key) }
  func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 { try base.decode(type, forKey: key) }
  func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 { try base.decode(type, forKey: key) }
  func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 { try base.decode(type, forKey: key) }
  func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt { try base.decode(type, forKey: key) }
  func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 { try base.decode(type, forKey: key) }
  func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 { try base.decode(type, forKey: key) }
  func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 { try base.decode(type, forKey: key) }
  func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 { try base.decode(type, forKey: key) }
  func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable { try base.decode(type, forKey: key) }
  func nestedContainer<NestedKey: CodingKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> { try base.nestedContainer(keyedBy: type, forKey: key) }
  func nestedUnkeyedContainer(forKey key: Self.Key) throws -> UnkeyedDecodingContainer { try base.nestedUnkeyedContainer(forKey: key) }
  func superDecoder() throws -> Decoder { try base.superDecoder() }
  func superDecoder(forKey key: Key) throws -> Decoder { try base.superDecoder(forKey: key) }
}
