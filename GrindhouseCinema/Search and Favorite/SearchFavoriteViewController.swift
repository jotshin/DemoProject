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
        searchBar.delegate = self
        searchBar.placeholder = "Search for other movies"
        viewModel = SearchFavoriteViewModel(apiManager: APIManager())
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
            self.pushSearchResultViewController(viewModel: viewModel)
        }
    }
}

// helpers
extension SearchFavoriteViewController {
    fileprivate func pushSearchResultViewController(viewModel: SearchFavoriteViewModel) {
        let searchResultViewModel = SearchResultViewModel(movies: viewModel.getMoviesForResult(), apiManager: viewModel.apiManager)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let searchResultViewController = storyboard.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController,
            let navigationController = navigationController else {
            return
        }
        searchResultViewController.viewModel = searchResultViewModel
        navigationController.pushViewController(searchResultViewController, animated: true)
    }
}
