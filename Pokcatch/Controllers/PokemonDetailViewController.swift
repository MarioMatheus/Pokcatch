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
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
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
        heightLabel.text = "Height: \(String(pokemon!.height))"
        imageView.image = FileManagerHelper.getImageFrom(path: (pokemon?.frontSprite)!)
        
        let types = pokemon?.types?.map({ type -> PokemonType in
            let pokemonType = type as! Type
            return PokemonType(rawValue: Int(pokemonType.id))!
        })
            
        typesLabel.text = types!.reduce("Type: ", { (result, pokemonType) -> String in
            return "\(result) \(pokemonType.stringValue)"
        })
        
//        typesLabel.text = pokemon?.types.reduce("Type: ", { (result, string) -> String in
//            return "\(result.capitalizingFirstLetter()) \(string.capitalizingFirstLetter())"
//        })
//
        if types!.count == 1 {
            imageView.backgroundColor = UIColor.colorForPokemonType((types!.first?.stringValue)!)
        } else {
            let typeOne = types![0].stringValue.capitalizingFirstLetter()
            let typeTwo = types![1].stringValue.capitalizingFirstLetter()

            backgroundGradientView.topColor = UIColor.colorForPokemonType(typeOne)
            backgroundGradientView.bottomColor = UIColor.colorForPokemonType(typeTwo)
        }
        
    }

    @IBAction func closeButtonDidPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
