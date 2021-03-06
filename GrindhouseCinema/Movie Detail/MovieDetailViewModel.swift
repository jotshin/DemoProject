//
//  MovieDetailViewModel.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/4/25.
//  Copyright © 2019 jotshin. All rights reserved.
//

import UIKit

let userDefaultKeyFavorite = "favorites"

enum Favorite: String {
    case fav = "\u{2665}"
    case not = "\u{2661}"
}

struct MovieDetailViewModel {
    private(set) var movie: MovieDetail
    private let userDefaults: UserDefaults
    private let imageProvider: ImageProvider
    
    private let callback: () -> ()
    
    init(movie: MovieDetail, imageProvider: ImageProvider = ImageProvider(), userDefaults: UserDefaults, callback: @escaping () -> ()) {
        self.movie = movie
        self.userDefaults = userDefaults
        self.callback = callback
        self.imageProvider = imageProvider
    }
    
    func titleForMovie() -> String {
        return movie.title
    }
    
    func overviewForMovie() -> String {
        return movie.overview ?? ""
    }
    
    func ratingForMovie() -> String {
        return "IMDB score: \(movie.rating ?? 0) / 10"
    }
    
    func posterForMovie(completion: @escaping (UIImage) -> Void) {
        guard let posterURL = self.movie.posterURL,
            let url = URL(string: "https://image.tmdb.org/t/p/w500/" + posterURL) else {
            DispatchQueue.main.async {
                completion(UIImage())
            }
            return
        }
        imageProvider.load(from: url, key: posterURL+"500") { (result) in
            switch result {
            case let .success(image):
                completion(image)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func movieFavoriteIsTapped() {
        // We use UserDefault dictionary to store the ids of movies that are favored
        guard var dic = userDefaults.object(forKey: userDefaultKeyFavorite) as? [String: Bool],
            let isFavorite = dic["\(movie.id)"] else {
            return
        }
        dic["\(movie.id)"] = !isFavorite
        userDefaults.set(dic, forKey: userDefaultKeyFavorite)
    }
    
    func getMovieIsFavorite() -> Bool {
        // We use UserDefault dictionary to store the ids of movies that are favored
        guard var dic = userDefaults.object(forKey: userDefaultKeyFavorite) as? [String: Bool] else {
            userDefaults.set(["\(movie.id)": false], forKey: userDefaultKeyFavorite)
            return false
        }
        guard let isFavorite = dic["\(movie.id)"] else {
            dic["\(movie.id)"] = false
            userDefaults.set(dic, forKey: userDefaultKeyFavorite)
            return false
        }
        return isFavorite
    }
    
    func getMovieFavoriteString() -> String {
        return getMovieIsFavorite() ? Favorite.fav.rawValue : Favorite.not.rawValue
    }
}
