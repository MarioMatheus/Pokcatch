//
//  Cache.swift
//  Pokcatch
//
//  Created by Mario Matheus on 27/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class CacheManager {
    
    static let shared = CacheManager()
    
    let manager = CoreDataManager.shared
    
    func insertPokemonAtSchedule(pokemon: Pokemon,  afterTime time: TimeInterval) {
        let cacheItem = NSEntityDescription.insertNewObject(
            forEntityName: "Cache",
            into: manager.context
            ) as! Cache
        
        cacheItem.pokemon = pokemon
        cacheItem.dueDate = Date().addingTimeInterval(time)
        
        manager.saveContext()
    }
    
    
    func fetchPokemonFromSchedule() -> [Pokemon] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cache")
        
        do {
            let cache = try manager.context.fetch(request) as! [Cache]
            let poksValids = cache.filter { $0.dueDate! > Date() }
            cache.forEach {
                if $0.dueDate! < Date() {
                    removeCacheScheduled(cacheItem: $0)
                }
            }
            
            return poksValids.map({ $0.pokemon! })
        } catch {
            return []
        }
    }
    
    
    func removeCacheScheduled(cacheItem: Cache) {
        manager.context.delete(cacheItem)
        manager.saveContext()
    }
    
    
    private init() {}
    
}
