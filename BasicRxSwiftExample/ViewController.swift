//
//  ViewController.swift
//  BasicRxSwiftExample
//
//  Created by Mohamed Ali BELHADJ on 10/05/2019.
//  Copyright © 2019 Hassine Faker. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class ViewController: UIViewController {
    
    @IBOutlet weak var placesTableView: UITableView!
    
    let disposeBag = DisposeBag()
    let places: PublishSubject<[Place]> = PublishSubject<[Place]>() //PublishSubject let us retrieve any kind of event
    
    var placesData: [Place] = [Place]() // Array to store data from json api

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchData(url: "https://api.myjson.com/bins/16w6h0")
        
        //Bind data to tableView
        places.bind(to: placesTableView.rx.items(cellIdentifier: "cell")) { row, model, cell in
            cell.textLabel?.text = "\(model.name), \(model.desc)"
            }.disposed(by: disposeBag)
        
        //create action on each tableView element
        placesTableView.rx.modelSelected(Place.self)
            .map{ URL(string: $0.url) }
            .subscribe(onNext: { [weak self] url in
                guard let url = url else {
                    return
                }
                self?.present(SFSafariViewController(url: url), animated: true)
            }).disposed(by: disposeBag)
        
        
        //Retrieve new data after 4 seconds
        DispatchQueue.main.asyncAfter(deadline: .now()+4) {
            self.fetchData(url: "https://api.myjson.com/bins/vxiuu")
        }
        
    }


}

extension ViewController{ // Api defintion
    func fetchData(url: String) {
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        var places = try JSONDecoder().decode([Place].self, from: data)
                        self.placesData = try JSONDecoder().decode([Place].self, from: data)
                        self.places.onNext(self.placesData)
                    } catch let error {
                        print(error)
                    }
                }
                }.resume()
        }
    }
}

