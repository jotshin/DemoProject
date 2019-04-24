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
}
