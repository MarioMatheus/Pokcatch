//
//  PokeBattle.swift
//  Pokcatch
//
//  Created by Mario Matheus on 28/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import Foundation

protocol PokeBattleDelegate {
    func mainPokemonLifeReduced(currentLife: Int)
    func opponentPokemonLifeReduced(currentLife: Int)
}

class PokeBattle {
 
    var mainPokemon: Pokemon
    var opponentPokemon: Pokemon
    
    var currentMainPokemonHP: Int
    var currentWildPokemonHP: Int
    
    var delegate: PokeBattleDelegate?
    
    init(_ mainPokemon: Pokemon, versus opponentPokemon: Pokemon) {
        self.mainPokemon = mainPokemon
        self.opponentPokemon = opponentPokemon
        self.currentMainPokemonHP = Int(mainPokemon.hp)
        self.currentWildPokemonHP = Int(opponentPokemon.hp)
    }
    
    
    func opponentAttackWith(move: Move) -> Bool {
        let precision = Int.random(in: 0...100)
        if precision <= move.accuracy {
            currentMainPokemonHP -= (Int(move.power * opponentPokemon.attack / mainPokemon.defense))/4
            delegate?.mainPokemonLifeReduced(currentLife: currentMainPokemonHP)
            return true
        }
        
        return false
    }
    
    
    func mainPokemonAttackWith(move: Move) -> Bool {
        let precision = Int.random(in: 0...100)
        if precision <= move.accuracy {
            currentWildPokemonHP -= (Int(move.power * mainPokemon.attack / opponentPokemon.defense))/4
            delegate?.opponentPokemonLifeReduced(currentLife: currentWildPokemonHP)
            return true
        }
        
        return false
    }
    
}
