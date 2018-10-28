//
//  MyPokemonsViewController.swift
//  Pokcatch
//
//  Created by Mario Matheus on 27/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import UIKit

class MyPokemonsViewController: UIViewController {

    @IBOutlet weak var pokemonsCollectionView: UICollectionView!
    
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "PokemonCollectionViewCell", bundle: nil)
        pokemonsCollectionView.register(nib, forCellWithReuseIdentifier: "pokemonCell")
        
        registerForPreviewing(with: self, sourceView: pokemonsCollectionView)
        
        pokemonsCollectionView.delegate = self
        pokemonsCollectionView.dataSource = self
        
        if let myPoks = PokemonDatabase.shared.getMyPokemons() {
            pokemons = myPoks
        }
    }
    
    
    func createDetailViewControllerFor(indexPath: IndexPath) -> PokemonDetailViewController {
        
        let pokemonDetailViewCtrl = PokemonDetailViewController()
        let pokemon = pokemons[indexPath.row]
        pokemonDetailViewCtrl.pokemon = pokemon
        
        pokemonDetailViewCtrl.preferredContentSize = CGSize(width: 266, height: 345)
        pokemonDetailViewCtrl.delegate = self
        
        return pokemonDetailViewCtrl
    }
    
}


extension MyPokemonsViewController: UICollectionViewDataSource {
    
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
        
        return cell
    }
    
}



extension MyPokemonsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let detailViewCtrl = createDetailViewControllerFor(indexPath: indexPath)
        //        present(detailViewCtrl, animated: true, completion: nil)
    }
}


extension MyPokemonsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 160)
    }
}


extension MyPokemonsViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = pokemonsCollectionView.indexPathForItem(at: location) else {
            return nil
        }
        
        return createDetailViewControllerFor(indexPath: indexPath)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        // present(viewControllerToCommit, animated: true, completion: nil)
    }
    
}


extension MyPokemonsViewController: PokemonDetailViewControllerDelegate {
    
    func removePokemonFromMyPokemons() {
        if let myPoks = PokemonDatabase.shared.getMyPokemons() {
            pokemons = myPoks
            self.pokemonsCollectionView.reloadData()
        }
    }
    
}
