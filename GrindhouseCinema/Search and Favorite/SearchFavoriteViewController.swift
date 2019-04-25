//
//  SearchFavoriteViewController.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/4/23.
//  Copyright © 2019 jotshin. All rights reserved.
//

import UIKit

class SearchFavoriteViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: SearchFavoriteViewModel?
    
    override func viewDidLoad() {
        title = "Your Favorite Movies"
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.placeholder = "Search for other movies"
        viewModel = SearchFavoriteViewModel(apiManager: APIManager(), dataManager: DataManager(modelName: "GrindhouseCinema"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.fetchFavoriteMovies {
            self.tableView.reloadData()
        }
    }
    
}

extension SearchFavoriteViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let viewModel = viewModel,
            let keyword = searchBar.text,
            !keyword.isEmpty else {
            return
        }
        viewModel.fetchMovies(keyword: keyword) { error in
            if let error = error {
                // show error
                print(error.localizedDescription)
                return
            }
            self.pushSearchResultViewController(viewModel: viewModel, keyword: keyword)
        }
    }
}

extension SearchFavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel,
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchFavoriteViewCell", for: indexPath) as? SearchFavoriteViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = viewModel.titleForCell(indexPath: indexPath)
        cell.posterImageView.image = viewModel.posterForCell(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.fetchMovieDetail(id: viewModel.getFavoriteMovies()[indexPath.row].id) { [weak self] movieDetail in
            guard let strongSelf = self,
                let movieDetail = movieDetail else {
                return
            }
            strongSelf.pushMovieDetailViewController(movieDetail: movieDetail)
        }
    }
}

// MARK: - Helpers
extension SearchFavoriteViewController {
    fileprivate func pushSearchResultViewController(viewModel: SearchFavoriteViewModel, keyword: String) {
        let searchResultViewModel = SearchResultViewModel(movies: viewModel.getMoviesForResult(), apiManager: viewModel.apiManager, title: keyword)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let searchResultViewController = storyboard.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController,
            let navigationController = navigationController else {
            return
        }
        searchResultViewController.viewModel = searchResultViewModel
        navigationController.pushViewController(searchResultViewController, animated: true)
    }
    
    fileprivate func pushMovieDetailViewController(movieDetail: MovieDetail) {
        let movieDetailViewModel = MovieDetailViewModel(movie: movieDetail)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController,
            let navigationController = navigationController else {
                return
        }
        movieDetailViewController.viewModel = movieDetailViewModel
        navigationController.pushViewController(movieDetailViewController, animated: true)
    }
}
