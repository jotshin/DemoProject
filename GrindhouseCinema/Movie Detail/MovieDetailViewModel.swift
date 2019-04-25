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
    case fav = "❤️"
    case not = "♡"
}

struct MovieDetailViewModel {
    var movie: MovieDetail
    let userDefaults: UserDefaults
    
    init(movie: MovieDetail, userDefaults: UserDefaults) {
        self.movie = movie
        self.userDefaults = userDefaults
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
    
    func posterForMovie() -> UIImage {
        guard let posterURL = movie.posterURL,
            let url = URL(string: "https://image.tmdb.org/t/p/w500/" + posterURL),
            let image = try? UIImage(data: Data(contentsOf: url)) else {
                return UIImage()
        }
        return image
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
