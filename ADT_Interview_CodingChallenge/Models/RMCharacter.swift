//
//  RMCharacter.swift
//  ADT_Interview_CodingChallenge
//
//  Created by Jeremy Fleshman on 9/22/20.
//

import Foundation

struct RMCharacter: Decodable {
    struct Location: Decodable {
        var name: String
    }

    var id: Int
    var name: String
    var location: Location
    var status: String
    var species: String
    var image: String
}

enum RMCharacterDetails: String, CaseIterable {
    case name
    case status
    case species
    case location
}
