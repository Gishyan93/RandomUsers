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
    

    init(gender: String, name: Name, location: UserLocation, login: Login, phone: String, picture: Picture) {
        self.gender = gender
        self.name = name
        self.location = location
        self.email = ""
        self.login = login
        self.dob = Dob()
        self.registered = Dob()
        self.phone = phone
        self.cell = ""
        self.id = ID()
        self.picture = picture
        self.nat = ""
    }
    
}

// MARK: - Dob
public struct Dob: Codable {
    let date: String
    let age: Int
    
    init() {
        self.date = ""
        self.age = 0
    }
}

// MARK: - ID
public struct ID: Codable {
    let name: String
    let value: String?
    
    init() {
        self.name = ""
        self.value = ""
    }
}

// MARK: - Location
public struct UserLocation: Codable {
    let street: Street
    let city, state, country: String
    let postcode: Postcode
    let coordinates: Coordinates
    let timezone: Timezone
    
    init(street: Street, city: String,
         country: String, coordinates: Coordinates) {
        self.street = street
        self.city = city
        self.state = ""
        self.country = country
        self.postcode = Postcode.integer(0)
        self.coordinates = coordinates
        self.timezone = Timezone()
    }
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
    
    init(number: Int, name: String) {
        self.number = number
        self.name = name
    }
}

// MARK: - Timezone
public struct Timezone: Codable {
    let offset, timezoneDescription: String

    enum CodingKeys: String, CodingKey {
        case offset
        case timezoneDescription = "description"
    }
    init() {
        self.offset = ""
        self.timezoneDescription = ""
    }
}

// MARK: - Login
public struct Login: Codable {
    let uuid, username, password, salt: String
    let md5, sha1, sha256: String
    init(uuid: String) {
        self.uuid = uuid
        self.username = ""
        self.password = ""
        self.salt = ""
        self.md5 = ""
        self.sha1 = ""
        self.sha256 = ""
    }
}

// MARK: - Name
public struct Name: Codable, Equatable {
    let title: String
    let first, last: String
    init(first: String, last: String) {
        self.first = first
        self.last = last
        self.title = ""
    }
}


// MARK: - Picture
public struct Picture: Codable {
    let large, medium, thumbnail: String
    init(large: String) {
        self.large = large
        self.medium = ""
        self.thumbnail = ""
    }
}

