//
//  SearchFavoriteViewController.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/4/23.
//  Copyright © 2019 jotshin. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchFavoriteViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: SearchFavoriteViewModel?
    var didSelect: ((MovieDetail) -> ())?
    var didFound: ((String) -> ())?
    var presentError: ((Error) -> ())?
    
    override func viewDidLoad() {
        title = "Your Favorite Movies"
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.placeholder = "Search for movies to add to favorite"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    func updateUI() {
        viewModel?.fetchFavoriteMovies {
            self.tableView.reloadData()
        }
    }
}

extension SearchFavoriteViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let viewModel = viewModel,
            let keyword = searchBar.text,
            !keyword.isEmpty else {
            return
        }
        SVProgressHUD.show(withStatus: "Loading...")
        viewModel.fetchMovies(keyword: keyword) {[weak self] error in
            SVProgressHUD.dismiss()
            if let error = error {
                // show error
                print(error.localizedDescription)
                return
            }
            guard let strongSelf = self,
                let didFound = strongSelf.didFound else {
                return
            }
            didFound(keyword)
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
        viewModel.posterForCell(indexPath: indexPath, completion: { image in
            cell.posterImageView.image = image
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        SVProgressHUD.show(withStatus: "Loading...")
        viewModel.fetchMovieDetail(id: viewModel.getFavoriteMovies()[indexPath.row].id) { [weak self] movieDetail in
            SVProgressHUD.dismiss()
            guard let strongSelf = self,
                let movieDetail = movieDetail,
                let didSelect = strongSelf.didSelect else {
                return
            }
            didSelect(movieDetail)
        }
    }
}
