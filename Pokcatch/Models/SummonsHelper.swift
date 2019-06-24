//
//  SummonsHelper.swift
//  Pokcatch
//
//  Created by Mario Matheus on 22/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import Foundation

class SummonsHelper {
    
    static let timesToSummon = [5, 10, 15, 30, 45, 60]
    static let timesToLeave = [30, 45, 60, 90, 120, 180]
//    static let kantoPokemonsCount = 151
    
    
    static func nextPokemonToAppear() -> (willAppear: TimeInterval, willLeave: TimeInterval) {
        let appearTime = timesToSummon.randomElement()!
        let leaveTime = appearTime + timesToLeave.randomElement()!
        
        return (TimeInterval(appearTime), TimeInterval(leaveTime))
    }
    
    
    static func randomizePokemonForMe(completion: @escaping (PokemonJSON?)->Void) {
        let willAppear = TimeInterval(timesToSummon.randomElement()!)
        let willLeave = TimeInterval(timesToSummon.randomElement()!)
        
        var now = Date()
        now.addTimeInterval(willAppear)
        
        var after = now
        after.addTimeInterval(willLeave)
        
        let idPokemon = Int.random(in: getPokemonRangeByRarity())
        PokeAPIService.shared.requestPokemonWith(id: idPokemon) { pokemonJSON in
            completion(pokemonJSON)
        }
    }
    
    
    private static func getPokemonRangeByRarity() -> ClosedRange<Int> {
        let rare = Int.random(in: 1...100)
        
        switch rare {
        case 1...50:
            return 1...75
        case 51...79:
            return 76...110
        case 80...98:
            return 111...140
        default:
            return 141...151
        }
    }
    
    
    static func pokemonWillBeCatched(pokemon: Pokemon, withHP hp: Int) -> Bool {
        let chance = Int.random(in: 0...300)
        return chance >= pokemon.experience + Int32(hp)
    }
    
    
    static func verifyIfCanRunOf(pokemon: Pokemon) -> Bool {
        let random = Int.random(in: 0...400)
        return random > pokemon.experience
    }
    
    
}
