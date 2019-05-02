//
//  SearchResultViewController.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/4/24.
//  Copyright © 2019 jotshin. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchResultViewController: UICollectionViewController {
    
    var viewModel: SearchResultViewModel?
    var didSelect: ((MovieDetail) -> ())?
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else {
            return
        }
        title = viewModel.getTitle()
    }
    
    func updateUI() {
        
    }
}

// MARK: - UICollectionViewDataSource
extension SearchResultViewController {
    
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
        viewModel.posterForDisplay(indexPath: indexPath) { image in
            cell.imageView.image = image
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SearchResultViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        SVProgressHUD.show(withStatus: "Loading...")
        viewModel.fetchMovieDetail(id: viewModel.getMovies()[indexPath.row].id) { [weak self] movieDetail in
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
