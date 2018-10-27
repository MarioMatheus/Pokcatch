//
//  PokeAPIService.swift
//  Pokcatch
//
//  Created by Mario Matheus on 27/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import UIKit


protocol PokeAPIMovesDelegate {
    func movesSelected(_ moves: [MoveStatsJSON])
}


class PokeAPIService {
    
    static let shared = PokeAPIService()
    
    let urlApi = "https://pokeapi.co/api/v2"
//    let kantoPokemonsCount = 151
    
    
    
    /// Request a pokemon from pokeapi
    ///
    /// - Parameters:
    ///   - id: Pokemon ID at API
    ///   - completion: Callback with PokemonJson struct or nil if an error occurred
    func requestPokemonWith(id: Int, completion: @escaping (PokemonJSON?)->Void) {
        let url = URL(string: "\(urlApi)/pokemon/\(id)/")
        var getRequest = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        getRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: getRequest) { (data, res, error) in
            if error != nil || data == nil {
                completion(nil)
                return
            }
            
            do {
                let pokemonJSON = try JSONDecoder().decode(PokemonJSON.self, from: data!)
                completion(pokemonJSON)
            } catch {
                completion(nil)
            }
        }
        
        DispatchQueue.main.async { task.resume() }
    }
    
    
    
    /// Request a sprite from PokeAPI
    ///
    /// - Parameters:
    ///   - link: Link where the image are hosted
    ///   - completion: Completion with sprite as UIImage or nil if an error occurred
    func requestSpriteFrom(link: String, completion: @escaping (UIImage?)->Void) {
        let url = URL(string: "\(link)")
        var getRequest = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        getRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: getRequest) { (data, res, error) in
            if error != nil || data == nil {
                completion(nil)
                return
            }
            
            completion(UIImage(data: data!))
        }
        
        DispatchQueue.main.async { task.resume() }
    }
    
    
    func requestMoveFrom(link: String, completion: @escaping (MoveStatsJSON?)->Void) {
        let url = URL(string: "\(link)")
        var getRequest = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        getRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: getRequest) { (data, res, error) in
            if error != nil || data == nil {
                completion(nil)
                return
            }
            
            do {
                let moveStats = try JSONDecoder().decode(MoveStatsJSON.self, from: data!)
                completion(moveStats)
            } catch {
                completion(nil)
            }
        }
        
        DispatchQueue.main.async { task.resume() }
    }
    
    
    
    var delegate: PokeAPIMovesDelegate?
    var validMoves = [MoveStatsJSON]()
    var validMovesCount = 0 {
        didSet {
            if validMovesCount == 3 {
                delegate?.movesSelected(validMoves)
            }
        }
    }
    var movesRemaining = 1 {
        didSet {
            if movesRemaining == 0 && validMovesCount < 3 {
                delegate?.movesSelected(validMoves)
            }
        }
    }
    
    func choiceMovesOf(moves: [MovesJSON]) {
        var movesFiltered = [MovesJSON]()
        
        movesFiltered = moves.filter { movesJSON -> Bool in
            return movesJSON.version_group_details
                .contains(where: { $0.version_group.name == "yellow"})
        }
        
        movesRemaining = movesFiltered.count
        movesFiltered.forEach { movesJSON in
            requestMoveFrom(link: movesJSON.move.url, completion: { moveStatsJSON in
                if moveStatsJSON != nil && moveStatsJSON!.power > 10 {
                    self.validMoves.append(moveStatsJSON!)
                    self.validMovesCount += 1
                }
                self.movesRemaining -= 1
            })
        }
    }
    
    
    private init() {}
}
