//
//  ViewController.swift
//  CurrencyApp
//
//  Created by Zuka Papuashvili on 21.01.22.
//

import UIKit

class ViewController: UIViewController {
    
    private let tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        return tableView
    }()

    private var viewModels = [CryptoTableViewViewModel]()
    
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.allowsFloats = true
        formatter.numberStyle = .currency
        formatter.formatterBehavior = .default
        
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parent?.title = "Crypto Currency"
        self.view.backgroundColor = .systemOrange
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        APICrypto.shared.getAllCryptoData {[weak self] result in
            switch result {
            case .success(let models):
                self?.viewModels = models.compactMap({ model in
                    
                    let price = model.price_usd ?? 0
                    let formatter = ViewController.numberFormatter
                    let priceString = formatter.string(from: NSNumber(value: price))
                    
                    let iconUrl = URL(
                    string:
                        APICrypto.shared.icons.filter({
                            icon in icon.asset_id == model.asset_id
                        }).first?.url ?? "Error404"
                    )
                    
                   return CryptoTableViewViewModel(
                    name: model.name ?? "Nil",
                    symbol: model.asset_id,
                    price: priceString ?? "Nil",
                    iconUrl: iconUrl
                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {fatalError()}
        cell.config(viewModel: viewModels[indexPath.row])
        return cell
        
        
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

