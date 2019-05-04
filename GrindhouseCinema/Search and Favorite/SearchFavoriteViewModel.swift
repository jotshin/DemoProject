//
//  SearchFavoriteViewModel.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/4/24.
//  Copyright © 2019 jotshin. All rights reserved.
//

import UIKit

class SearchFavoriteViewModel {
    private let apiManager: APIManagerProtocol
    private let dataManager: DataManagerProtocol
    private let imageProvider: ImageProvider
    var movies: [Movie]?
    var favoriteMovies: [Movie]?
    
    private let callback: () -> ()
    
    init(apiManager: APIManagerProtocol, dataManager: DataManagerProtocol, imageProvider: ImageProvider = ImageProvider(), callback: @escaping () -> Void) {
        self.apiManager = apiManager
        self.dataManager = dataManager
        self.imageProvider = imageProvider
        self.callback = callback
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
    
    func fetchMovieDetail(id: Int, _ completion: @escaping (MovieDetail?) -> Void) {
        apiManager.fetchMovieDetail(id: id) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(movieDetail):
                    completion(movieDetail)
                case .failure(_):
                    completion(nil)
                }
            }
        }
    }
    
    func fetchFavoriteMovies(_ completion: @escaping () -> Void) {
        dataManager.fetchSavedMovies { [weak self] movies in
            guard let strongSelf = self else { return }
            strongSelf.favoriteMovies = movies
            completion()
        }
    }
    
    func getMoviesForResult() -> [Movie] {
        guard let movies = movies else {
            return []
        }
        return movies
    }
    
    func getFavoriteMovies() -> [Movie] {
        guard let favoriteMovies = favoriteMovies else {
            return []
        }
        return favoriteMovies
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
    
    func posterForCell(indexPath: IndexPath, completion: @escaping (UIImage) -> Void) {
        guard let favoriteMovies = self.favoriteMovies,
            let posterURL = favoriteMovies[indexPath.row].posterURL,
            let url = URL(string: "https://image.tmdb.org/t/p/w200/" + posterURL) else {
                DispatchQueue.main.async {
                    completion(UIImage())
                }
            return
        }
        imageProvider.load(from: url, key: posterURL+"200") { (result) in
            switch result {
            case let .success(image):
                completion(image)
            case let .failure(error):
                print(error)
            }
        }
    }
}
