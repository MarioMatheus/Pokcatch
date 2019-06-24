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
    
    @IBOutlet weak var consoleTextView: UITextView!
    
    @IBOutlet weak var firstMoveButton: UIButton!
    @IBOutlet weak var secondMoveButton: UIButton!
    @IBOutlet weak var thirdMoveButton: UIButton!
    @IBOutlet weak var runButton: UIButton!
    
    var hasPokemonFainted = false
    var pokeBattle: PokeBattle!
    
    var mainPokemonMoves: [Move]!
    var wildPokemonMoves: [Move]!
    var canPressMoveButtons = false {
        didSet {
            enableAndDisableButtons()
            
            let alpha: CGFloat = canPressMoveButtons ? 1 : 0.5
            changeButtonsViewToAlpha(alpha)
        }
    }
    
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
        
        firstMoveButton.isHidden = true
        secondMoveButton.isHidden = true
        thirdMoveButton.isHidden = true
        
        wildPokemonHPProgressView.transform = wildPokemonHPProgressView.transform.scaledBy(x: 1, y: 8)
        mainPokemonHPProgressView.transform = mainPokemonHPProgressView.transform.scaledBy(x: 1, y: 8)
        
        setupWildPokemonHUB()
        preparePokeballInteractions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let pokemons = PokemonDatabase.shared.getMyPokemons()
        
        if pokemons != nil && !(pokemons!.isEmpty) {
            performSegue(withIdentifier: "ChoicePokemonSegue", sender: pokemons)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PokemonChoiceViewController
        destination.pokemons = sender as? [Pokemon]
        destination.delegate = self
    }
    
    
    func enableAndDisableButtons() {
        firstMoveButton.isEnabled = canPressMoveButtons
        secondMoveButton.isEnabled = canPressMoveButtons
        thirdMoveButton.isEnabled = canPressMoveButtons
        runButton.isEnabled = canPressMoveButtons
        pokeballImageView.isUserInteractionEnabled = canPressMoveButtons
    }
    
    
    func changeButtonsViewToAlpha(_ alpha: CGFloat) {
        firstMoveButton.backgroundColor = firstMoveButton.backgroundColor?.withAlphaComponent(alpha)
        secondMoveButton.backgroundColor = secondMoveButton.backgroundColor?.withAlphaComponent(alpha)
        thirdMoveButton.backgroundColor = thirdMoveButton.backgroundColor?.withAlphaComponent(alpha)
        runButton.backgroundColor = runButton.backgroundColor?.withAlphaComponent(alpha)
        pokeballImageView.image = alpha == 1 ? UIImage(named: "Pokeball") : UIImage(named: "PokebalDisabled")
    }
    
    
    func setupMainPokemonHUB() {
        mainPokemonHPLabel.text = "\(mainPokemon.name!) HP"
        mainPokemonHPProgressView.progress = 1
        mainPokemonMoves = []
        mainPokemon.moves?.forEach({ move in
            let mov = move as! Move
            mainPokemonMoves.append(mov)
        })
        
        for i in 0..<mainPokemonMoves.count {
            if i == 0 {
                let type = PokemonType(rawValue: Int(mainPokemonMoves[0].type!.id))
                firstMoveButton.backgroundColor = UIColor.colorForPokemonType((type?.stringValue)!)
                firstMoveButton.setTitle(mainPokemonMoves[0].name?.capitalizingFirstLetter(), for: .normal)
                firstMoveButton.isHidden = false
            } else if i == 1 {
                let type = PokemonType(rawValue: Int(mainPokemonMoves[1].type!.id))
                secondMoveButton.backgroundColor = UIColor.colorForPokemonType((type?.stringValue)!)
                secondMoveButton.setTitle(mainPokemonMoves[1].name?.capitalizingFirstLetter(), for: .normal)
                secondMoveButton.isHidden = false
            } else if i == 2 {
                let type = PokemonType(rawValue: Int(mainPokemonMoves[2].type!.id))
                thirdMoveButton.backgroundColor = UIColor.colorForPokemonType((type?.stringValue)!)
                thirdMoveButton.setTitle(mainPokemonMoves[2].name?.capitalizingFirstLetter(), for: .normal)
                thirdMoveButton.isHidden = false
            }
        }
    }
    
    
    func setupWildPokemonHUB() {
        wildPokemonHPLabel.text = "\(wildPokemon.name!) HP"
        wildPokemonHPProgressView.progress = 1
        
        wildPokemonMoves = []
        wildPokemon.moves?.forEach({ move in
            let mov = move as! Move
            wildPokemonMoves.append(mov)
        })
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
            point.x += self.wildPokemonImageView.frame.width/2 - 70
            point.y += self.wildPokemonImageView.frame.height/2 - 70
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
        if SummonsHelper.pokemonWillBeCatched(pokemon: self.wildPokemon, withHP: pokeBattle.currentWildPokemonHP) {
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
                UIView.animate(withDuration: 1, animations: {
                    self.wildPokemonImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: { _ in if self.pokeBattle != nil { self.wildPokemonAttack(completion: {}) } })
            })
        }
    }
    
    
    func wildPokemonAttack(completion: @escaping ()->Void) {
        let move = wildPokemonMoves.randomElement()
        if move != nil && !hasPokemonFainted {
            consoleTextView.text = "\(wildPokemon.name!) attack with \(move!.name!)"
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                if self.pokeBattle.opponentAttackWith(move: move!) {
                    self.consoleTextView.text = "\(self.wildPokemon.name!) attack with \(move!.name!)"
                } else {
                    self.consoleTextView.text = "\(self.wildPokemon.name!) miss attack"
                }
                completion()
            }
        } else {
            completion()
        }
    }
    
    
    func mainPokemonAttackWith(move: Move, completion: @escaping ()->Void) {
        if !hasPokemonFainted {
            consoleTextView.text = "\(mainPokemon.name!) attack with \(move.name!)"
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                if self.pokeBattle.mainPokemonAttackWith(move: move) {
                    self.consoleTextView.text = "\(self.wildPokemon.name!) attack with \(move.name!)"
                } else {
                    self.consoleTextView.text = "\(self.wildPokemon.name!) miss attack"
                }
                completion()
            }
        }
    }
    
    
    func faintPokemon() {
        consoleTextView.text = "Pokemon Fainted"
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            self.delegate?.pokemonCatched(self.wildPokemon)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func runButtonDidPressed(_ sender: Any) {
        let ranAway = SummonsHelper.verifyIfCanRunOf(pokemon: wildPokemon)
        if ranAway {
            consoleTextView.text = "You escaped"
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in self.dismiss(animated: true, completion: nil) })
        } else {
            consoleTextView.text = "You could not escape."
            canPressMoveButtons = false
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
                if self.pokeBattle != nil { self.wildPokemonAttack(completion: {}) }
                self.canPressMoveButtons = true
            })
        }
    }
    
    @IBAction func firstMoveButtonDidPressed(_ sender: Any) {
        canPressMoveButtons = false
        if !hasPokemonFainted {
            if mainPokemon.speed > wildPokemon.speed {
                mainPokemonAttackWith(move: mainPokemonMoves[0], completion: {
                    self.wildPokemonAttack {
                        self.canPressMoveButtons = true
                        if !self.hasPokemonFainted { self.consoleTextView.text = "Waiting a movement" }
                    }
                })
            } else {
                wildPokemonAttack {
                    self.mainPokemonAttackWith(move: self.mainPokemonMoves[0], completion: {
                        self.canPressMoveButtons = true
                        if !self.hasPokemonFainted { self.consoleTextView.text = "Waiting a movement" }
                    })
                }
            }
        }
    }
    
    @IBAction func secondMoveButtonDidPressed(_ sender: Any) {
        canPressMoveButtons = false
        if !hasPokemonFainted {
            if mainPokemon.speed > wildPokemon.speed {
                mainPokemonAttackWith(move: mainPokemonMoves[1], completion: {
                    self.wildPokemonAttack {
                        self.canPressMoveButtons = true
                        if !self.hasPokemonFainted { self.consoleTextView.text = "Waiting a movement" }
                    }
                })
            } else {
                wildPokemonAttack {
                    self.mainPokemonAttackWith(move: self.mainPokemonMoves[1], completion: {
                        self.canPressMoveButtons = true
                        if !self.hasPokemonFainted { self.consoleTextView.text = "Waiting a movement" }
                    })
                }
            }
        }
    }
    
    @IBAction func thirdButtonDidPressed(_ sender: Any) {
        self.canPressMoveButtons = false
        if !hasPokemonFainted {
            if mainPokemon.speed > wildPokemon.speed {
                mainPokemonAttackWith(move: mainPokemonMoves[2], completion: {
                    self.wildPokemonAttack {
                        self.canPressMoveButtons = true
                        if !self.hasPokemonFainted { self.consoleTextView.text = "Waiting a movement" }
                    }
                })
            } else {
                wildPokemonAttack {
                    self.mainPokemonAttackWith(move: self.mainPokemonMoves[2], completion: {
                        self.canPressMoveButtons = true
                        if !self.hasPokemonFainted { self.consoleTextView.text = "Waiting a movement" }
                    })
                }
            }
        }
    }
    
}


extension PokemonBattleViewController: PokemonChoiceDelegate {
    
    func pokemonSelected(_ pokemon: Pokemon) {
        mainPokemon = pokemon
        mainPokemonImage = FileManagerHelper.getImageFrom(path: pokemon.backSprite!)
        mainPokemonImageView.image = mainPokemonImage
        
        setupMainPokemonHUB()
        pokeBattle = PokeBattle(pokemon, versus: wildPokemon)
        pokeBattle.delegate = self
    }
    
}


extension PokemonBattleViewController: PokeBattleDelegate {
    
    func mainPokemonLifeReduced(currentLife: Int) {
        mainPokemonHPProgressView.setProgress(Float(currentLife) / Float(mainPokemon.hp), animated: true)
        if currentLife <= 0 {
            hasPokemonFainted = true
            faintPokemon()
        }
    }
    
    func opponentPokemonLifeReduced(currentLife: Int) {
        wildPokemonHPProgressView.setProgress(Float(currentLife) / Float(wildPokemon.hp), animated: true)
        if currentLife <= 0 {
            hasPokemonFainted = true
            faintPokemon()
        }
    }
    
}
