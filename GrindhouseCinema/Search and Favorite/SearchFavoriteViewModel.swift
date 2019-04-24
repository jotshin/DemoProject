//
//  SearchFavoriteViewModel.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/4/24.
//  Copyright © 2019 jotshin. All rights reserved.
//

import Foundation

class SearchFavoriteViewModel {
    let apiManager: APIManagerProtocol
    var movies: [Movie]?
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func fetchMovies(keyword: String, _ completion: @escaping (Error?) -> Void) {
        apiManager.fetchMovies(keyword: keyword) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(movies):
                    self.movies = movies
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
}
