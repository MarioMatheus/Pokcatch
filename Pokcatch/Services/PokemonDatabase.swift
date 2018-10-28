//
//  PokemonDatabase.swift
//  Pokcatch
//
//  Created by Mario Matheus on 27/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import Foundation
import CoreData

class PokemonDatabase {
    
    static let shared = PokemonDatabase()
    
    let manager = CoreDataManager.shared
    
    
    func getMyPokemons() -> [Pokemon]? {
        var pokemons: [Pokemon] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
        do {
            pokemons = try manager.context.fetch(request) as! [Pokemon]
        } catch {
            return nil
        }
        
        return pokemons.filter({ $0.wasCaught })
    }
    
    
    func removePokemonsNotCaught() {
        var pokemons: [Pokemon] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
        do {
            pokemons = try manager.context.fetch(request) as! [Pokemon]
            pokemons.forEach({
                if !$0.wasCaught { removePokemonFromMyPokemonsWith(id: Int($0.id)) }
            })
        } catch {
            
        }
    }
    
    
    func removePokemonFromMyPokemonsWith(id: Int) {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
            let pokemons = try manager.context.fetch(request) as! [Pokemon]
            
            if let pokemon = pokemons.filter({ Int($0.id) == id }).first {
                manager.context.delete(pokemon)
                FileManagerHelper.removeFromFileManagerWith(path: pokemon.frontSprite!)
                FileManagerHelper.removeFromFileManagerWith(path: pokemon.backSprite!)
                manager.saveContext()
            }
        } catch {
            print("No pokemon to delete")
        }
    }
    
    
    private init() {}
    
}
