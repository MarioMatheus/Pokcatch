//
//  ModelsPokeAPI.swift
//  Pokcatch
//
//  Created by Mario Matheus on 27/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import Foundation


struct PokemonJSON: Codable {
    let id: Int
    let name: String
    let height: Int
    let base_experience: Int
    let sprites: SpriteJSON
    let stats: [StatsJSON]
    let types: [TypesJSON]
    let moves: [MovesJSON]
}

struct SpriteJSON: Codable {
    let front_default: String
    let back_default: String
}

struct StatsJSON: Codable {
    let base_stat: Int
    let stat: StatJson
}

struct StatJson: Codable {
    let name: String
}

struct TypesJSON: Codable {
    let slot: Int
    let type: TypeJSON
}

struct TypeJSON: Codable {
    let name: String
    let url: String
}

struct MovesJSON: Codable {
    let move: MoveJSON
    let version_group_details: [VersionGroupDetailsJSON]
}

struct MoveJSON: Codable {
    let name: String
    let url: String
}

struct VersionGroupDetailsJSON: Codable {
    let version_group: VersionGroupJSON
}

struct VersionGroupJSON: Codable {
    let name: String
}

struct MoveStatsJSON: Codable {
    let name: String
    let power: Int
    let accuracy: Int
    let type: TypeJSON
}
