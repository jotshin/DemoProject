//
//  MovieDetailViewController.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/4/24.
//  Copyright © 2019 jotshin. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    var viewModel: MovieDetailViewModel?
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else {
            return
        }
        title = viewModel.titleForMovie()
        posterImageView.image = viewModel.posterForMovie()
        ratingLabel.text = viewModel.ratingForMovie()
        overviewLabel.text = viewModel.overviewForMovie()
        favoriteLabel.text = viewModel.getMovieFavoriteString()
        favoriteLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapFavoriteAction(sender:)))
        favoriteLabel.addGestureRecognizer(gesture)
    }
    
    @objc func tapFavoriteAction(sender:UITapGestureRecognizer) {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.movieFavoriteIsTapped()
        favoriteLabel.text = viewModel.getMovieFavoriteString()
    }
}

