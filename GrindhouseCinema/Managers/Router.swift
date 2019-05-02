//
//  Router.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/4/30.
//  Copyright © 2019 jotshin. All rights reserved.
//

import UIKit

struct Router {
    func configure(_ window: UIWindow?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let searchFavoriteVC = storyboard.instantiateViewController(withIdentifier: "SearchFavoriteViewController") as? SearchFavoriteViewController else { return }
        let navigationController = UINavigationController(rootViewController: searchFavoriteVC)
        configure(searchFavoriteVC, in: navigationController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func configure(_ searchFavoriteViewController: SearchFavoriteViewController, in navigationController: UINavigationController) {
        let apiManager = APIManager()
        let viewModel = SearchFavoriteViewModel(apiManager: apiManager, dataManager: DataManager(modelName: "GrindhouseCinema")) { [weak viewController = searchFavoriteViewController] in
            guard let searchFavoriteVC = viewController else { return }
            
            searchFavoriteVC.updateUI()
        }
        searchFavoriteViewController.viewModel = viewModel
        searchFavoriteViewController.didSelect = { (movieDetail) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return }
            self.configure(movieDetailViewController, in: navigationController, with: movieDetail)
        }
        searchFavoriteViewController.didFound = { (keyword) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let searchResultViewController = storyboard.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController else { return }
            self.configure(searchResultViewController, in: navigationController, with: viewModel.getMoviesForResult(), keyword: keyword, apiManager: apiManager)
        }
    }
    
    func configure(_ searchResultViewController: SearchResultViewController, in navigationController: UINavigationController, with movies: [Movie], keyword: String, apiManager: APIManagerProtocol) {
        
        let searchResultViewModel = SearchResultViewModel(movies: movies, apiManager: apiManager, title: keyword) { [weak viewController = searchResultViewController] in
            guard let searchResultVC = viewController else { return }
            
            searchResultVC.updateUI()
        }
        
        searchResultViewController.viewModel = searchResultViewModel
        searchResultViewController.didSelect = { (movieDetail) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return }
            self.configure(movieDetailViewController, in: navigationController, with: movieDetail)
        }
        navigationController.pushViewController(searchResultViewController, animated: true)
    }
    
    func configure(_ movieDetailViewController: MovieDetailViewController, in navigationController: UINavigationController, with movieDetail: MovieDetail) {

        let movieDetailViewModel = MovieDetailViewModel(movie: movieDetail, userDefaults: UserDefaults.standard) { [weak viewController = movieDetailViewController] in
            guard let movieDetailVC = viewController else { return }
            movieDetailVC.updateUI()
        }
        movieDetailViewController.viewModel = movieDetailViewModel
        navigationController.pushViewController(movieDetailViewController, animated: true)
    }
}
