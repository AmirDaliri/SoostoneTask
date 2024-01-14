//
//  PokemonTableViewCell.swift
//  SoostoneTask
//
//  Created by Amir Daliri on 13.01.2024.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {

    @IBOutlet private weak var pokemonImageView: UIImageView!
    @IBOutlet private weak var pokemonNameLabel: UILabel!
    @IBOutlet private weak var pokemonDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setup(pokemon: Pokemon) {
        pokemonImageView.loadImage(from: pokemon.imageURL)
        pokemonNameLabel.text = pokemon.name
        pokemonDescriptionLabel.text = pokemon.description
    }
    
    // Expose the image for external access
    func getPokemonImage() -> UIImage {
        return pokemonImageView.image ?? #imageLiteral(resourceName: "pokemon_placeholder")
    }
}
