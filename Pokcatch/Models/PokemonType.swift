//
//  PokemonType.swift
//  Pokcatch
//
//  Created by Mario Matheus on 27/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import UIKit

enum PokemonType: Int {
    case normal = 1
    case fighting, flying, poison, ground, rock, bug
    case ghost, steel, fire, water, grass, electric
    case psychic, ice, dragon, dark, fairy
    
    var stringValue: String {
        switch self {
        case .normal:
            return "Normal"
        case .fighting:
            return "Fighting"
        case .flying:
            return "Flying"
        case .poison:
            return "Poison"
        case .ground:
            return "Ground"
        case .rock:
            return "Rock"
        case .bug:
            return "Bug"
        case .ghost:
            return "Ghost"
        case .steel:
            return "Steel"
        case .fire:
            return "Fire"
        case .water:
            return "Water"
        case .grass:
            return "Grass"
        case .electric:
            return "Electric"
        case .psychic:
            return "Psychic"
        case .ice:
            return "Ice"
        case .dragon:
            return "Dragon"
        case .dark:
            return "Dark"
        case .fairy:
            return "Fairy"
        }
    }
}
