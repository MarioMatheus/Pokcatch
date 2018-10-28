//
//  PokemonMapViewController.swift
//  Pokcatch
//
//  Created by Mario Matheus on 27/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import UIKit
import MapKit

class PokemonMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var firstOpen = true
    
    var pokemonGenerator: PokeGenerator!
    var pokemonAnnotationImages: [String : UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your Kanto"
        mapView.showsUserLocation = true
        locationManager.delegate = self
        mapView.delegate = self
        prepareLocationUpdating()
    }
    
    
    func prepareLocationUpdating() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func generateCoordinateNext(to coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let latitudeOffset = Double.random(in: -0.0003...0.0003)
        let longitudeOffset = Double.random(in: -0.0003...0.0003)
        var newCoordinate = coordinate
        
        newCoordinate.latitude += latitudeOffset
        newCoordinate.longitude += longitudeOffset
        
        return newCoordinate
    }

    
    func showIsometricVisionWith(centerCoordinate: CLLocationCoordinate2D) {
        DispatchQueue.main.async {
            self.mapView.setCamera(MKMapCamera(
                lookingAtCenter: centerCoordinate,
                fromDistance: 300,
                pitch: 60,
                heading: self.mapView.camera.heading), animated: true)
        }
        
        mapView.isPitchEnabled = false
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender != nil {
            let destination = segue.destination as! PokemonBattleViewController
            let name = (sender as! String)
            let pokemon = pokemonGenerator.wildNearPokemons.filter({ $0.name == name }).first!
            
            destination.delegate = self
            destination.wildPokemon = pokemon
            destination.wildPokemonImage = pokemonAnnotationImages[name]
        }
    }

    @IBAction func myPokesBarButtonDidPressed(_ sender: Any) {
        performSegue(withIdentifier: "MyPokesSegue", sender: nil)
    }
}


// MARK: - Pokemons at map
extension PokemonMapViewController {
    
    func createPokemonAtMap(_ pokemon: Pokemon) {
        let coordinate = generateCoordinateNext(to: mapView.userLocation.coordinate)
        PokeAPIService.shared.requestSpriteFrom(link: pokemon.frontSprite!) { image in
            if image == nil {
                self.pokemonGenerator.wildNearPokemons.removeAll(where: { $0.name == pokemon.name })
            } else {
                let scale = Int(pokemon.height) + 70
                let size = CGSize(width: scale, height: scale)
                self.pokemonAnnotationImages[pokemon.name!] = UIImage.imageWithImage(image: image!, scaledToSize: size)
                self.createPokemonAnnotationWith(name: pokemon.name!, at: coordinate)
                self.showIsometricVisionWith(centerCoordinate: coordinate)
            }
        }
    }
    
    func createPokemonAnnotationWith(name: String, at coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.title = name
        annotation.subtitle = "Wild Pokemon"
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
    }
    
    
    func removeAnnotationOf(_ pokemon: Pokemon) {
        mapView.annotations.forEach { annotation in
            if annotation.title == pokemon.name {
                DispatchQueue.main.async { self.mapView.removeAnnotation(annotation) }
                pokemonAnnotationImages.removeValue(forKey: pokemon.name!)
            }
        }
    }
    
}



// MARK: - PokeGeneratorDelegate
extension PokemonMapViewController: PokeGeneratorDelegate {
    
    func wildPokemonAppear(_ pokemon: Pokemon) {
        print("Pokemon Appear: ", pokemon.name!)
        createPokemonAtMap(pokemon)
    }
    
    
    func wildPokemonDidLeave(_ pokemon: Pokemon) {
        print("Pokemon Escape: ", pokemon.name!)
        removeAnnotationOf(pokemon)
    }
    
}



// MARK: - CLLocationManagerDelegate
extension PokemonMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if firstOpen {
            firstOpen = false
            let lastCoordinate = locations.last!.coordinate
            self.showIsometricVisionWith(centerCoordinate: lastCoordinate)
            pokemonGenerator = PokeGenerator(withSummonInterval: .high)
            pokemonGenerator.delegate = self
        }
    }
    
}



// MARK: - MKMapViewDelegate
extension PokemonMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pointName = annotation.title!!
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointName)
        
        if annotationView == nil && pointName != "My Location" {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: pointName)
            annotationView!.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if pointName != "My Location" {
            annotationView?.image = pokemonAnnotationImages[pointName]
        }
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let title = view.annotation?.title!
        if title != "My Location" {
            performSegue(withIdentifier: "BattleSegue", sender: title)
        }
    }
    
}


extension PokemonMapViewController: PokemonBattleDelegate {
    
    func pokemonCatched(_ pokemon: Pokemon) {
        removeAnnotationOf(pokemon)
        pokemonGenerator.wildNearPokemons.removeAll(where: { $0.id == pokemon.id })
    }
    
}
