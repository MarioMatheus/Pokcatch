//
//  ServicesHelper.swift
//  Pokcatch
//
//  Created by Mario Matheus on 27/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import Foundation

class ServicesHelper {
    
    static func convertPokemonJSON(pokemonJSON: PokemonJSON) -> Pokemon {
        let pokemon = Pokemon(context: CoreDataManager.shared.context)
        pokemon.id = Int32(pokemonJSON.id)
        pokemon.name = pokemonJSON.name
        pokemon.experience = Int32(pokemonJSON.base_experience)
        setStats(pokemonJSON.stats, at: pokemon)
        setSprites(pokemonJSON.sprites, at: pokemon)
        setTypes(pokemonJSON.types, at: pokemon)
        
        return pokemon
    }
    
    
    private static func setStats(_ stats: [StatsJSON], at pokemon: Pokemon) {
        stats.forEach { statsJSON in
            switch statsJSON.stat.name {
            case "speed":
                pokemon.speed = Int32(statsJSON.base_stat)
            case "defense":
                pokemon.defense = Int32(statsJSON.base_stat)
            case "attack":
                pokemon.attack = Int32(statsJSON.base_stat)
            case "hp":
                pokemon.hp = Int32(statsJSON.base_stat)
            default:
                break
            }
        }
    }
    
    
    private static func setSprites(_ sprites: SpriteJSON, at pokemon: Pokemon) {
        pokemon.backSprite = sprites.back_default
        pokemon.frontSprite = sprites.front_default
    }
    
    
    private static func setTypes(_ types: [TypesJSON], at pokemon: Pokemon) {
        types
            .sorted(by: { $0.slot < $1.slot })
            .forEach { typesJSON in
                pokemon.addToTypes(setupTypeIDFrom(url: typesJSON.type.url))
        }
    }
    
    
    private static func setupTypeIDFrom(url: String) -> Type {
        let type = Type(context: CoreDataManager.shared.context)
        var url = url
        url.removeLast()
        var number = Int32(String(url.removeLast()))!
        let char = url.removeLast()
        if char != "/" {
            number += ( Int32(String(char))! * 10 )
        }
        type.id = number
        
        return type
    }
    
}

