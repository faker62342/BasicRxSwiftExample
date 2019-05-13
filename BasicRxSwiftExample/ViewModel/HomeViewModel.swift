//
//  HomeViewModel.swift
//  BasicRxSwiftExample
//
//  Created by Mohamed Ali BELHADJ on 10/05/2019.
//  Copyright © 2019 Hassine Faker. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    
    let places: BehaviorRelay<[Place]> = BehaviorRelay<[Place]>(value: []) //PublishSubject let us retrieve any kind of event
    
    let shownPlaces: BehaviorRelay<[Place]> = BehaviorRelay<[Place]>(value: []) //retrieve only the searched places
    
    
    var placesData: [Place] = [Place]() // Array to store data from json api
    
    
    func fetchData(url: String) {
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        self.placesData = try JSONDecoder().decode([Place].self, from: data)
                        self.places.accept(self.placesData)
                    } catch let error {
                        print(error)
                    }
                }
                }.resume()
        }
    }
    
}
