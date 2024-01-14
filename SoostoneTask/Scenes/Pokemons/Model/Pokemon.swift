//
//  Pokemon.swift
//  SoostoneTask
//
//  Created by Amir Daliri on 13.01.2024.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pokemons = try Pokemons(json)

import UIKit

// MARK: - Pokemon
struct Pokemon: Codable, Equatable {
    let id: Int?
    let name, description: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case imageURL = "imageUrl"
    }
}

// MARK: Pokemon convenience initializers and mutators

extension Pokemon {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Pokemon.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: Int?? = nil,
        name: String?? = nil,
        description: String?? = nil,
        imageURL: String?? = nil
    ) -> Pokemon {
        return Pokemon(
            id: id ?? self.id,
            name: name ?? self.name,
            description: description ?? self.description,
            imageURL: imageURL ?? self.imageURL
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
    
    func toPokemonUIModel(image: UIImage) -> PokemonUIModel {
        PokemonUIModel.init(id: self.id ?? 01, name: self.name ?? "", description: self.description ?? "", image: image)
    }
}

typealias Pokemons = [Pokemon]

extension Array where Element == Pokemons.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Pokemons.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
