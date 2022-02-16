//
//  FavoritesViewController.swift
//  CurrencyApp
//
//  Created by Zuka Papuashvili on 06.02.22.
//

import UIKit
import CardSlider

struct Item: CardSliderItem {
    var image: UIImage
    
    var rating: Int?
    
    var title: String
    
    var subtitle: String?
    
    var description: String?
    
    
}

class FavoritesViewController: UIViewController {
    
    @IBOutlet var myButton: UIButton!
    
    var data = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        data.append(Item(image: UIImage(named: "CreditCards")!, rating: nil, title: "Credit Cards", subtitle: "Payment Method", description: "Choose a Card for Payment"))
        
        data.append(Item(image: UIImage(named: "CreditCards2")!, rating: nil, title: "Credit Cards", subtitle: "Payment Method", description: "Choose a Card for Payment"))
        
        data.append(Item(image: UIImage(named: "CreditCards3")!, rating: nil, title: "Credit Cards", subtitle: "Payment Method", description: "Choose a Card for Payment"))

        myButton.backgroundColor = .orange
        myButton.setTitleColor(.white, for: .normal)
        
        
    }
    
    @IBAction func didTapButton() {
        
        let vc = CardSliderViewController.with(dataSource: self)
        
        vc.title = "Your Cards"
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
    }

    

}

extension FavoritesViewController: CardSliderDataSource {
    
    func item(for index: Int) -> CardSliderItem {
        return data[index]
    }
    
    func numberOfItems() -> Int {
        return data.count
    }
    
    
}
