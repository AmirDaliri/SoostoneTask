//
//  PokemonsViewController.swift
//  SoostoneTask
//
//  Created by Amir Daliri on 13.01.2024.
//

import UIKit
import Combine
import SwiftUI

class PokemonsViewController: UIViewController, Loading {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: PokemonsViewModel
    private var cancellables = Set<AnyCancellable>()
    private var pullToRefreshComponent: PullToRefreshComponent?
    var spinner: UIView?
    
    init(viewModel: PokemonsViewModel = PokemonsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pokemons"
        setupTableView()
        bindViewModel()
        viewModel.loadPokemons()
        
        pullToRefreshComponent = PullToRefreshComponent()
        pullToRefreshComponent?.setup(with: tableView, target: self, action: #selector(refreshData))
    }
    
    private func bindViewModel() {
        showSpinner()
        viewModel.$pokemons
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.hideSpinner()
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$networkError
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.hideSpinner()
                self?.handleNetworkError(error)
            }
            .store(in: &cancellables)
    }
    
    private func setupTableView() {
        tableView.register(type: PokemonTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.accessibilityIdentifier = "PokemonsTableView"
        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc func refreshData() {
        pullToRefreshComponent?.endRefreshing()
    }

    private func handleNetworkError(_ error: NetworkError) {
        // Handle the error, e.g., show an alert
        let message = determineErrorMessage(for: error)
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func determineErrorMessage(for error: NetworkError) -> String {
        switch error {
        case .invalidURL, .invalidResponse, .noData:
            return "A network error occurred. Please try again."
        case .underlyingError(let underlyingError):
            return underlyingError.localizedDescription
        case .decodingError(let decodingError):
            return decodingError.localizedDescription
        case .notFound:
            return "not Found"
        case .otherError(let message):
            return message
        }
    }
    
    private func navigateToPokemonView(with pokemon: Pokemon, tableView: UITableView, indexPath: IndexPath) {
        // Get the selected cell
        if let cell = tableView.cellForRow(at: indexPath) as? PokemonTableViewCell {
            
            // Retrieve the UIImage from the UIImageView
            let selectedImage = cell.getPokemonImage()
            
            // Pass the selected UIImage to the detail view
            let selectedPokemon = pokemon.toPokemonUIModel(image: selectedImage)
            let detailView = PokemonView(viewModel: PokemonViewModel.init(pokemon: selectedPokemon))
            
            // Use SwiftUI NavigationLink to navigate to the detail view
            let detailHostingController = UIHostingController(rootView: detailView)
            navigationController?.pushViewController(detailHostingController, animated: true)
        }
    }
}

// MARK: - Table Delegate Datasource
extension PokemonsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.identifier, for: indexPath) as! PokemonTableViewCell
        cell.setup(pokemon: viewModel.pokemons[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPokemon = viewModel.pokemons[indexPath.row]
        DispatchQueue.main.async {
            self.navigateToPokemonView(with: selectedPokemon, tableView: tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
