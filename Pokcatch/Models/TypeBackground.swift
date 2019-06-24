//
//  TypeBackground.swift
//  Pokcatch
//
//  Created by Mario Matheus on 24/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func colorForPokemonType(_ type: String) -> UIColor {
        switch type {
        case "Grass":
            return UIColor(red: 154/255, green: 211/255, blue: 117/255, alpha: 1)
        case "Fire":
            return UIColor(red: 184/255, green: 80/255, blue: 57/255, alpha: 1)
        case "Water":
            return UIColor(red: 105/255, green: 171/255, blue: 238/255, alpha: 1)
        case "Fighting":
            return UIColor(red: 127/255, green: 68/255, blue: 62/255, alpha: 1)
        case "Flying":
            return UIColor(red: 124/255, green: 159/255, blue: 234/255, alpha: 1)
        case "Poison":
            return UIColor(red: 152/255, green: 90/255, blue: 150/255, alpha: 1)
        case "Ground":
            return UIColor(red: 213/255, green: 193/255, blue: 118/255, alpha: 1)
        case "Rock":
            return UIColor(red: 189/255, green: 179/255, blue: 127/255, alpha: 1)
        case "Bug":
            return UIColor(red: 188/255, green: 205/255, blue: 100/255, alpha: 1)
        case "Ghost":
            return UIColor(red: 117/255, green: 115/255, blue: 186/255, alpha: 1)
        case "Electric":
            return UIColor(red: 242/255, green: 216/255, blue: 120/255, alpha: 1)
        case "Psychic":
            return UIColor(red: 213/255, green: 92/255, blue: 160/255, alpha: 1)
        case "Ice":
            return UIColor(red: 162/255, green: 228/255, blue: 246/255, alpha: 1)
        case "Dragon":
            return UIColor(red: 83/255, green: 71/255, blue: 167/255, alpha: 1)
        case "Dark":
            return UIColor(red: 143/255, green: 136/255, blue: 136/255, alpha: 1)
        case "Steel":
            return UIColor(red: 183/255, green: 182/255, blue: 196/255, alpha: 1)
        case "Fairy":
            return UIColor(red: 206/255, green: 158/255, blue: 216/255, alpha: 1)
        default:
            return UIColor(red: 182/255, green: 180/255, blue: 169/255, alpha: 1)
        }
    }
    
}
