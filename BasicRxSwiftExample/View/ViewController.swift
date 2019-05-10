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
    
    var homeViewModel = HomeViewModel()
    
    let disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBindings()
        
        homeViewModel.fetchData(url: "https://api.myjson.com/bins/16w6h0")
        
        //Retrieve new data after 4 seconds
        DispatchQueue.main.asyncAfter(deadline: .now()+4) {
            self.homeViewModel.fetchData(url: "https://api.myjson.com/bins/vxiuu")
        }
        
    }


}

extension ViewController{ // Bindings
    
    private func setupBindings(){
        
        //Bind viewModel to tableView
        homeViewModel.places.bind(to: placesTableView.rx.items(cellIdentifier: "cell")) { row, model, cell in
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
    }
    
}

