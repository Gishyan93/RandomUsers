//
//  RandomUsers.swift
//  RandomUsers
//
//  Created by Tigran Gishyan on 1/15/21.
//

import Foundation

// MARK: - Welcome
public struct RandomUsers: Codable {
    let results: [RandomUserInfo]
    let info: Info
}

// MARK: - Info
public struct Info: Codable {
    let seed: String
    let results, page: Int
    let version: String
}

// MARK: - Result
public struct RandomUserInfo: Codable {
    let gender: String
    let name: Name
    let location: UserLocation
    let email: String
    let login: Login
    let dob, registered: Dob
    let phone, cell: String
    let id: ID
    let picture: Picture
    let nat: String
    
}

// MARK: - Dob
public struct Dob: Codable {
    let date: String
    let age: Int
}

// MARK: - ID
public struct ID: Codable {
    let name: String
    let value: String?
}

// MARK: - Location
public struct UserLocation: Codable {
    let street: Street
    let city, state, country: String
    let postcode: Postcode
    let coordinates: Coordinates
    let timezone: Timezone
}

// MARK: - Coordinates
public struct Coordinates: Codable {
    let latitude, longitude: String?
}

public enum Postcode: Codable {
    case integer(Int)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Postcode.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Postcode"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Street
public struct Street: Codable {
    let number: Int
    let name: String
}

// MARK: - Timezone
public struct Timezone: Codable {
    let offset, timezoneDescription: String

    enum CodingKeys: String, CodingKey {
        case offset
        case timezoneDescription = "description"
    }
}

// MARK: - Login
public struct Login: Codable {
    let uuid, username, password, salt: String
    let md5, sha1, sha256: String
}

// MARK: - Name
public struct Name: Codable, Equatable {
    let title: String
    let first, last: String
}


// MARK: - Picture
public struct Picture: Codable {
    let large, medium, thumbnail: String
}

