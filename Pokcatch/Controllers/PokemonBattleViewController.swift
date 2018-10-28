//
//  PokemonBattleViewController.swift
//  Pokcatch
//
//  Created by Mario Matheus on 27/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import UIKit

protocol PokemonBattleDelegate {
    func pokemonCatched(_ pokemon: Pokemon)
}

class PokemonBattleViewController: UIViewController {
    
    @IBOutlet weak var mainPokemonImageView: UIImageView!
    @IBOutlet weak var wildPokemonImageView: UIImageView!
    @IBOutlet weak var pokeballImageView: UIImageView!
    
    @IBOutlet weak var mainPokemonHPLabel: UILabel!
    @IBOutlet weak var mainPokemonHPProgressView: UIProgressView!
    @IBOutlet weak var wildPokemonHPLabel: UILabel!
    @IBOutlet weak var wildPokemonHPProgressView: UIProgressView!
    
    var wildPokemon: Pokemon!
    var wildPokemonImage: UIImage!
    
    var mainPokemon: Pokemon!
    var mainPokemonImage: UIImage!
    
    var animator: UIDynamicAnimator!
    var snapBehavior: UISnapBehavior!
    var pokeballCenter: CGPoint!
    
    var delegate: PokemonBattleDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wildPokemonImageView.image = wildPokemonImage
        pokeballCenter = CGPoint(x: view.frame.width/2, y: view.frame.height - 40)
        
        setupWildPokemonHUB()
        preparePokeballInteractions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let pokemons = PokemonDatabase.shared.getMyPokemons() {
            performSegue(withIdentifier: "ChoicePokemonSegue", sender: pokemons)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PokemonChoiceViewController
        destination.pokemons = sender as? [Pokemon]
        destination.delegate = self
    }
    
    
    func setupMainPokemonHUB() {
        mainPokemonHPLabel.text = "\(mainPokemon.name!) HP"
        mainPokemonHPProgressView.progress = 1
    }
    
    
    func setupWildPokemonHUB() {
        wildPokemonHPLabel.text = "\(wildPokemon.name!) HP"
        wildPokemonHPProgressView.progress = 1
    }
    
    
    func preparePokeballInteractions() {
        animator = UIDynamicAnimator(referenceView: view)
        
//        let point = CGPoint(x: view.frame.width/2, y: view.frame.height - 40)
        snapBehavior = UISnapBehavior(item: pokeballImageView, snapTo: pokeballCenter)
        animator.addBehavior(snapBehavior)
        
        // Adiciona PanGesture na viewDidLoad() para movimentar a smileBox
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pannedView))
        pokeballImageView.addGestureRecognizer(panGesture)
        pokeballImageView.isUserInteractionEnabled = true
    }
    
    
    @objc func pannedView(recognizer: UIPanGestureRecognizer){
        
        switch recognizer.state {
        case .began:
            animator.removeBehavior(snapBehavior)
        case .changed:
            let translation = recognizer.translation(in: view)
            pokeballImageView.center = CGPoint(
                x: pokeballImageView.center.x + translation.x,
                y: pokeballImageView.center.y + translation.y)
            
            recognizer.setTranslation(.zero, in: view)
        case .ended, .cancelled, .failed:
            verifyIntersection()
            animator.addBehavior(snapBehavior)
        case .possible:
            break
        }
    }
    
    
    func verifyIntersection() {
        if pokeballImageView.frame.intersects(wildPokemonImageView.frame) {
            UIView.animate(withDuration: 1) { self.pokeballImageView.frame.size = CGSize(width: 50, height: 50) }
            var point = self.wildPokemonImageView.center
            point.x += self.wildPokemonImageView.frame.width/2 - 55
            point.y += self.wildPokemonImageView.frame.height/2 - 55
            snapBehavior.snapPoint = point
            tryCatchPokemon()
        }
    }
    
    
    func catchWildPokemon() {
//        let pokeScheduleds = CacheManager.shared.fetchPokemonFromSchedule()
//        let pokeCatched = pokeScheduleds.filter { Int($0.id) == wildPokemon.id }.first!
        
//        CacheManager.shared.removeCacheScheduled(cacheItem: pokeCatched)
        wildPokemon.wasCaught = true
        PokeAPIService.shared.requestSpriteFrom(link: wildPokemon.backSprite!) { image in
            guard let image = image else { return }
            
            let backPath = "\(String(describing: self.wildPokemon.name))_back_sprite"
            let frontPath = "\(String(describing: self.wildPokemon.name))_front_sprite"
            FileManagerHelper.saveImageInFileManager(image, at: backPath)
            FileManagerHelper.saveImageInFileManager(self.wildPokemonImage, at: frontPath)
            
            self.wildPokemon.frontSprite = frontPath
            self.wildPokemon.backSprite = backPath
            
            PokemonDatabase.shared.manager.saveContext()
            self.delegate?.pokemonCatched(self.wildPokemon)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func tryCatchPokemon() {
        let size = CGSize(width: 50, height: 50)
        let starsImageView = UIImageView(image: UIImage.imageWithImage(image: UIImage(named: "Stars")!, scaledToSize: size))
        
        starsImageView.center = snapBehavior.snapPoint
        starsImageView.center.y -= 5
        
        UIView.animate(withDuration: 1, animations: {
            self.wildPokemonImageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.75, animations: {
                self.pokeballImageView.transform = CGAffineTransform(rotationAngle: 25)
            }, completion: { _ in
                UIView.animate(withDuration: 0.75, animations: {
                    self.pokeballImageView.transform = CGAffineTransform(rotationAngle: -25)
                }, completion: { _ in
                    UIView.animate(withDuration: 1.4, animations: {
                        self.pokeballImageView.transform = CGAffineTransform(rotationAngle: 25)
                    }, completion: { _ in
                        UIView.animate(withDuration: 0.75, animations: {
                            self.pokeballImageView.transform = CGAffineTransform(rotationAngle: 0)
                        }, completion: { _ in
                            self.switchAnimationBasedAtCatch(self.pokeballImageView, starsImageView)
                        })
                    })
                })
            })
        })
    }
    
    
    func switchAnimationBasedAtCatch(_ pokeballImageView: UIImageView, _ starsImageView: UIImageView) {
        if SummonsHelper.pokemonWillBeCatched(pokemon: self.wildPokemon) {
            self.view.addSubview(starsImageView)
            var point = starsImageView.center
            point.y -= 20
            UIView.animate(withDuration: 0.5, animations: {
                starsImageView.center = point
            }, completion: { (_) in
//                starsImageView.removeFromSuperview()
//                pokeballImageView.removeFromSuperview()
                self.catchWildPokemon()
            })
        } else {
            snapBehavior.snapPoint = pokeballCenter
            UIView.animate(withDuration: 1, animations: {
                self.pokeballImageView.frame.size = CGSize(width: 60, height: 60)
            }, completion: { _ in
                UIView.animate(withDuration: 1, animations: { self.wildPokemonImageView.transform = CGAffineTransform(scaleX: 1, y: 1) })
            })
        }
    }

}


extension PokemonBattleViewController: PokemonChoiceDelegate {
    func pokemonSelected(_ pokemon: Pokemon) {
        mainPokemon = pokemon
        mainPokemonImage = FileManagerHelper.getImageFrom(path: pokemon.backSprite!)
        mainPokemonImageView.image = mainPokemonImage
        
        setupMainPokemonHUB()
    }
}
