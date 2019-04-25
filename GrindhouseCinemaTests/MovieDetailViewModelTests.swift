//
//  MovieDetailViewModelTests.swift
//  GrindhouseCinemaTests
//
//  Created by Kai-Hong Tseng on 2019/4/25.
//  Copyright © 2019 jotshin. All rights reserved.
//

import Quick
import Nimble
@testable import GrindhouseCinema

class MovieDetailViewModelTests: QuickSpec {
    override func spec() {
        var subject: MovieDetailViewModel!
        var movie: MovieDetail!
        let userDefault: UserDefaultsMock = UserDefaultsMock()
        
        beforeEach {
            movie = MovieDetail(id: 123, title: "Captain Marvel", posterURL: "AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg", overview: "blah blah blah", rating: 7.1)
            subject = MovieDetailViewModel(movie: movie, userDefaults: userDefault)
        }
        
        describe(".titleForMovie") {
            it("returns movie title") {
                expect(subject.titleForMovie()).to(equal(movie.title))
            }
        }
        
        describe(".overviewForMovie") {
            it("returns movie overview") {
                expect(subject.overviewForMovie()).to(equal(movie.overview))
            }
        }
        
        describe(".ratingForMovie") {
            it("returns movie rating") {
                let expectedRating = "IMDB score: 7.1 / 10"
                expect(subject.ratingForMovie()).to(equal(expectedRating))
            }
        }
        
        describe(".posterForMovie") {
            it("returns movie poster") {
                let expectedImage = try? UIImage(data: Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w500/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg")!))
                expect(subject.posterForMovie().pngData()!).to(equal(expectedImage?.pngData()!))
            }
        }
        
        describe(".getMovieIsFavorite") {
            it("get false by default") {
                _ = subject.getMovieIsFavorite()
                let dic = userDefault.object(forKey: userDefaultKeyFavorite) as! [String: Bool]
                expect(dic["123"]).to(equal(false))
            }
        }
        
        describe(".movieFavoriteIsTapped") {
            it("set UserDefault's corresponding dic's value for given key") {
                subject.movieFavoriteIsTapped()
                let dic = userDefault.object(forKey: userDefaultKeyFavorite) as! [String: Bool]
                expect(dic["123"]).to(equal(true))
            }
        }
        
        describe(".getMovieFavoriteString") {
            it("return ❤️") {
                expect(subject.getMovieFavoriteString()).to(equal("❤️"))
            }
        }
    }
}
