//
//  PokeGenerator.swift
//  Pokcatch
//
//  Created by Mario Matheus on 27/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import Foundation
import CoreData

enum SummonInterval: TimeInterval {
    case low = 120
    case medium = 60
    case high = 45
}

protocol PokeGeneratorDelegate {
    func wildPokemonAppear(_ pokemon: Pokemon)
    func wildPokemonDidLeave(_ pokemon: Pokemon)
}

class PokeGenerator {
    
    var delegate: PokeGeneratorDelegate?
    
    var wildNearPokemons = [Pokemon]()
//    var wildNearPokemonsMoves = [String: [Move]]()
    
    init(withSummonInterval interval: SummonInterval) {
        verifyPokemonsInCache()
        checkWildNearPokemonsToSummon()

        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: interval.rawValue, repeats: true, block: { _ in
                self.checkWildNearPokemonsToSummon()
            })
        }
        
        PokeAPIService.shared.delegate = self
    }
    
    
    func verifyPokemonsInCache() {
        let pokemons = CacheManager.shared.fetchPokemonFromSchedule()
        wildNearPokemons.append(contentsOf: pokemons)
    }
    
    
    func checkWildNearPokemonsToSummon() {
        if wildNearPokemons.count < 3 {
            let times = SummonsHelper.nextPokemonToAppear()
            scheduleWildPokemonWith(times: times)
        }
    }
    
    
    func scheduleWildPokemonWith(times: (willAppear: TimeInterval, willLeave: TimeInterval)) {
        print(times)
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: times.willAppear, repeats: false, block: { _ in
                self.summonerWildPokemon(completion: { pokemon in
                    if let pokemon = pokemon {
                        self.scheduleLeaveTime(times.willLeave, forPokemon: pokemon)
//                        CacheManager.shared.insertPokemonAtSchedule(pokemon: pokemon, afterTime: times.willLeave)
                    }
                })
            })
        }
    }
    
    
    func summonerWildPokemon(completion: @escaping (Pokemon?)->Void) {
        SummonsHelper.randomizePokemonForMe { (pokeJSON) in
            guard let pokemonJSON = pokeJSON else {
                completion(nil)
                return
            }
            
            let pokemon = ServicesHelper.convertPokemonJSON(pokemonJSON: pokemonJSON)
//            self.wildNearPokemonsMoves[pokemonJSON.name] =
            PokeAPIService.shared.choiceMovesFor(pokemonJSON: pokemonJSON)
            
            self.wildNearPokemons.append(pokemon)
            self.delegate?.wildPokemonAppear(pokemon)
            completion(pokemon)
        }
    }
    
    
    func scheduleLeaveTime(_ time: TimeInterval, forPokemon pokemon: Pokemon) {
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: { _ in
                self.wildNearPokemons.removeAll(where: { $0.name == pokemon.name })
//                if let inCache = pokemon.cache {
//                    CacheManager.shared.removeCacheScheduled(cacheItem: inCache)
//                }
                self.delegate?.wildPokemonDidLeave(pokemon)
            })
        }
    }
}


extension PokeGenerator: PokeAPIMovesDelegate {
    
    func movesSelected(_ moves: [MoveStatsJSON], forPokemonName name: String) {
        var movesFormatted = [Move]()
        
        moves.forEach { moveStatsJSON in
            let move = Move(context: CoreDataManager.shared.context)
            move.accuracy = Int32(moveStatsJSON.accuracy)
            move.name = moveStatsJSON.name
            move.power = Int32(moveStatsJSON.power)
            move.type = ServicesHelper.setupTypeIDFrom(url: moveStatsJSON.type.url)
            movesFormatted.append(move)
        }
        
//        wildNearPokemonsMoves[name.capitalizingFirstLetter()] = movesFormatted
        let poke = wildNearPokemons.filter({ $0.name == name.capitalizingFirstLetter() }).first!
        movesFormatted.forEach({ poke.addToMoves($0) })
    }
    
}
