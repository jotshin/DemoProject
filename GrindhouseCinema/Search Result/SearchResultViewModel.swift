//
//  SearchResultViewModel.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/4/24.
//  Copyright © 2019 jotshin. All rights reserved.
//

import UIKit

struct SearchResultViewModel {
    let movies: [Movie]
    let apiManager: APIManagerProtocol
    let title: String
    
    init(movies: [Movie], apiManager: APIManagerProtocol, title: String) {
        self.movies = movies
        self.apiManager = apiManager
        self.title = title
    }
    
    func numberOfItemsInSection() -> Int {
        return movies.count
    }
    
    func titleForDisplay(indexPath: IndexPath) -> String {
        return movies[indexPath.row].title
    }
    
    func posterForDisplay(indexPath: IndexPath) -> UIImage {
        guard let posterURL = movies[indexPath.row].posterURL,
            let url = URL(string: "https://image.tmdb.org/t/p/w200/" + posterURL),
            let image = try? UIImage(data: Data(contentsOf: url)) else {
                return UIImage()
        }
        return image
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
    
    func getMovies() -> [Movie] {
        return movies
    }
    
    func getTitle() -> String {
        return title
    }
}
