//
//  PokemonChoiceViewController.swift
//  Pokcatch
//
//  Created by Mario Matheus on 28/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import UIKit

protocol PokemonChoiceDelegate {
    func pokemonSelected(_ pokemon: Pokemon)
}

class PokemonChoiceViewController: UIViewController {

    @IBOutlet weak var pokemonsCollectionView: UICollectionView!
    
    var delegate: PokemonChoiceDelegate?
    
    var pokemons: [Pokemon]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "PokemonCollectionViewCell", bundle: nil)
        pokemonsCollectionView.register(nib, forCellWithReuseIdentifier: "pokemonCell")
        
        pokemonsCollectionView.delegate = self
        pokemonsCollectionView.dataSource = self
    }

}


extension PokemonChoiceViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "pokemonCell",
            for: indexPath) as! PokemonCollectionViewCell
        let image = FileManagerHelper.getImageFrom(path: pokemons[indexPath.row].frontSprite!)
        
        cell.subtitleLabel.text = pokemons[indexPath.row].name
        cell.imageView.image = image
        cell.backgroundColor = cell.backgroundColor?.withAlphaComponent(0.75)
        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOpacity = 0.7
        cell.layer.shadowRadius = 2
        cell.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        return cell
    }
    
}



extension PokemonChoiceViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true) {
            self.delegate?.pokemonSelected(self.pokemons[indexPath.row])
        }
    }
}


extension PokemonChoiceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
}
