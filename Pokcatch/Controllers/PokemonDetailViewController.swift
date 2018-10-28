//
//  PokemonDetailViewController.swift
//  Pokcatch
//
//  Created by Mario Matheus on 17/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import UIKit

protocol PokemonDetailViewControllerDelegate {
    func removePokemonFromMyPokemons()
}

class PokemonDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var backgroundGradientView: GradientView!
    
    var delegate: PokemonDetailViewControllerDelegate?
    
    override var previewActionItems: [UIPreviewActionItem] {
        let removeAction = UIPreviewAction(title: "Remove Pokemon", style: .destructive, handler: { [unowned self] (_, _) in
            if let poke = self.pokemon {
                PokemonDatabase.shared.removePokemonFromMyPokemonsWith(id: Int(poke.id))
            }
            
            self.delegate?.removePokemonFromMyPokemons()
        })
        
        return [ removeAction ]
    }
    
    var pokemon: Pokemon? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = pokemon!.name
//        weightLabel.text = "Weight: \(String(pokemon!.weight)) lbs"
//        imageView.image = pokemon?.sprite
//        experienceLabel.text = String(pokemon!.baseExperience) + " XP"
//
//        typesLabel.text = pokemon?.types.reduce("Type: ", { (result, string) -> String in
//            return "\(result.capitalizingFirstLetter()) \(string.capitalizingFirstLetter())"
//        })
//
//        if pokemon?.types.count == 1 {
//            imageView.backgroundColor = UIColor.colorForPokemonType((pokemon?.types.first?.capitalizingFirstLetter())!)
//        } else {
//            let typeOne = pokemon!.types[0].capitalizingFirstLetter()
//            let typeTwo = pokemon!.types[1].capitalizingFirstLetter()
//
//            backgroundGradientView.topColor = UIColor.colorForPokemonType(typeOne)
//            backgroundGradientView.bottomColor = UIColor.colorForPokemonType(typeTwo)
//        }
        
    }

    @IBAction func closeButtonDidPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
