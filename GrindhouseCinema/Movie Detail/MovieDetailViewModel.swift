//
//  MovieDetailViewModel.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/4/25.
//  Copyright © 2019 jotshin. All rights reserved.
//

import UIKit

enum Favorite: String {
    case fav = "❤️"
    case not = "♡"
}

struct MovieDetailViewModel {
    var movie: MovieDetail
    
    init(movie: MovieDetail) {
        self.movie = movie
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
        UserDefaults.standard.set(!getMovieIsFavorite(), forKey: "\(movie.id)")
    }
    
    func getMovieIsFavorite() -> Bool {
        return UserDefaults.standard.bool(forKey: "\(movie.id)")
    }
    
    func getMovieFavoriteString() -> String {
        return getMovieIsFavorite() ? Favorite.fav.rawValue : Favorite.not.rawValue
    }
}
