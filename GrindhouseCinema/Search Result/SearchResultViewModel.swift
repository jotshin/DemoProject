//
//  SearchResultViewModel.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/4/24.
//  Copyright © 2019 jotshin. All rights reserved.
//

import UIKit

struct SearchResultViewModel {
    private(set) var movies: [Movie]
    private let apiManager: APIManagerProtocol
    private(set) var title: String
    
    private let callback: () -> ()
    
    init(movies: [Movie], apiManager: APIManagerProtocol, title: String, callback: @escaping () -> ()) {
        self.movies = movies
        self.apiManager = apiManager
        self.title = title
        self.callback = callback
    }
    
    func numberOfItemsInSection() -> Int {
        return movies.count
    }
    
    func titleForDisplay(indexPath: IndexPath) -> String {
        return movies[indexPath.row].title
    }
    
    func posterForDisplay(indexPath: IndexPath, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async {
            guard let posterURL = self.movies[indexPath.row].posterURL,
                let url = URL(string: "https://image.tmdb.org/t/p/w200/" + posterURL),
                let image = try? UIImage(data: Data(contentsOf: url)) else {
                    DispatchQueue.main.async {
                        completion(UIImage())
                    }
                return
            }
            DispatchQueue.main.async {
                completion(image)
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
    
    func getMovies() -> [Movie] {
        return movies
    }
    
    func getTitle() -> String {
        return title
    }
}
