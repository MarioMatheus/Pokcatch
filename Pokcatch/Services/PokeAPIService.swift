//
//  PokeAPIService.swift
//  Pokcatch
//
//  Created by Mario Matheus on 27/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import UIKit


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
    
    
    private init() {}
}
