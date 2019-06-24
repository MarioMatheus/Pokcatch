//
//  PokemonStatsViewController.swift
//  Pokcatch
//
//  Created by Mario Matheus on 28/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import UIKit

class PokemonStatsViewController: UIViewController {
    
    @IBOutlet weak var pokemonNavigationBar: UINavigationBar!
    @IBOutlet weak var pokemonSpriteImageView: UIImageView!
    @IBOutlet weak var pokedexIDLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var movesTableView: UITableView!
    
    var pokemon: Pokemon!
    var pokemonMoves: [Move] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonNavigationBar.topItem?.title = pokemon.name
        pokemonSpriteImageView.image = FileManagerHelper.getImageFrom(path: pokemon.frontSprite!)
        pokedexIDLabel.text = "Pokedex ID: \(String(pokemon.id))"
        experienceLabel.text = "XP: \(String(pokemon.experience))"
        heightLabel.text = "Height: \(String(pokemon.height))"
        hpLabel.text = "HP: \(String(pokemon.hp))"
        attackLabel.text = "Attack: \(String(pokemon.attack))"
        defenseLabel.text = "Defense: \(String(pokemon.defense))"
        speedLabel.text = "Speed: \(String(pokemon.speed))"
        
        setupTypeLabel()
        setupMoves()
    }
    
    func setupTypeLabel() {
        let types = pokemon?.types?.map({ type -> PokemonType in
            let pokemonType = type as! Type
            return PokemonType(rawValue: Int(pokemonType.id))!
        })
        
        typeLabel.text = types!.reduce("Type: ", { (result, pokemonType) -> String in
            return "\(result) \(pokemonType.stringValue)"
        })
    }
    
    func setupMoves() {
        pokemon.moves?.forEach({ move in
            let movement = move as! Move
            pokemonMoves.append(movement)
        })
        
        movesTableView.dataSource = self
    }

    @IBAction func closeButtonDidPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension PokemonStatsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonMoves.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "PokemonStatsCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "PokemonStatsCell")
        }
        
        cell?.textLabel?.text = pokemonMoves[indexPath.row].name?.capitalizingFirstLetter()
        cell?.detailTextLabel?.text = "Power: \(String(pokemonMoves[indexPath.row].power).capitalizingFirstLetter())"
        
        return cell!
    }
    
}


extension PokemonStatsViewController: UITableViewDelegate {
    
    
    
}
