//
//  SearchFavoriteViewModel.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/4/24.
//  Copyright © 2019 jotshin. All rights reserved.
//

import UIKit

class SearchFavoriteViewModel {
    let apiManager: APIManagerProtocol
    let dataManager: DataManagerProtocol
    var movies: [Movie]?
    var favoriteMovies: [Movie]?
    
    init(apiManager: APIManagerProtocol, dataManager: DataManagerProtocol) {
        self.apiManager = apiManager
        self.dataManager = dataManager
    }
    
    func fetchMovies(keyword: String, _ completion: @escaping (Error?) -> Void) {
        apiManager.fetchMovies(keyword: keyword) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(movies):
                    strongSelf.dataManager.saveFetchedMovies(movies)
                    strongSelf.movies = movies
                    completion(nil)
                case let .failure(error):
                    completion(error)
                }
            }
        }
    }
    
    func getMoviesForResult() -> [Movie] {
        guard let movies = movies else {
            return []
        }
        return movies
    }
    
    func getFavoriteMovies(_ completion: @escaping () -> Void) {
        dataManager.fetchSavedMovies { [weak self] movies in
            guard let strongSelf = self else { return }
            strongSelf.favoriteMovies = movies
        }
    }
    
    func numberOfRows() -> Int {
        guard let favoriteMovies = favoriteMovies else {
            return 0
        }
        return favoriteMovies.count
    }
    
    func titleForCell(indexPath: IndexPath) -> String {
        guard let favoriteMovies = favoriteMovies else {
            return ""
        }
        return favoriteMovies[indexPath.row].title
    }
    
    func posterForCell(indexPath: IndexPath) -> UIImage {
        guard let favoriteMovies = favoriteMovies,
            let posterURL = favoriteMovies[indexPath.row].posterURL,
            let url = URL(string: "https://image.tmdb.org/t/p/w200/" + posterURL),
            let image = try? UIImage(data: Data(contentsOf: url)) else {
                return UIImage()
        }
        return image
    }
}
