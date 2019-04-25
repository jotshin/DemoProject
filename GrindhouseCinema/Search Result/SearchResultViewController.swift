//
//  SearchResultViewController.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/4/24.
//  Copyright © 2019 jotshin. All rights reserved.
//

import UIKit

class SearchResultViewController: UICollectionViewController {
    
    var viewModel: SearchResultViewModel?
    
    override func viewDidLoad() {
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.numberOfItemsInSection()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultViewCell", for: indexPath) as? SearchResultViewCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = viewModel.titleForDisplay(indexPath: indexPath)
        cell.imageView.image = viewModel.posterForDisplay(indexPath: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.fetchMovieDetail(id: viewModel.getMovies()[indexPath.row].id) { [weak self] movieDetail in
            guard let strongSelf = self,
                let movieDetail = movieDetail else {
                    return
            }
            strongSelf.pushMovieDetailViewController(movieDetail: movieDetail)
        }
    }
}

// MARK: - Helpers
extension SearchResultViewController {
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
