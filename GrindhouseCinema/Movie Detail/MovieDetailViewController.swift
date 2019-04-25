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
    var viewModel: MovieDetailViewModel?
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else {
            return
        }
        title = viewModel.titleForMovie()
        posterImageView.image = viewModel.posterForMovie()
        ratingLabel.text = viewModel.ratingForMovie()
        overviewLabel.text = viewModel.overviewForMovie()
    }
}

