//
//  SearchFavoriteViewModelTests.swift
//  GrindhouseCinemaTests
//
//  Created by Kai-Hong Tseng on 2019/4/24.
//  Copyright © 2019 jotshin. All rights reserved.
//

import Quick
import Nimble
@testable import GrindhouseCinema

class SearchFavoriteViewModelTests: QuickSpec {
    override func spec() {
        var subject: SearchFavoriteViewModel!
        var apiManager: APIManagerMock!
        var dataManager: DataManagerMock!
        var movies: [Movie] = []
        
        beforeEach {
            let movie1 = Movie(id: 1, title: "Captain Marvel1", posterURL: "75AsB4NRKaYanuCeKYgIh2hfsR1.jpg")
            let movie2 = Movie(id: 2, title: "Captain Marvel2", posterURL: "rXmc4jvDBU04Wp8r5JMWy3HbhB3.jpg")
            let movie3 = Movie(id: 3, title: "Captain Marvel3", posterURL: "AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg")
            movies = [movie1, movie2, movie3]
            apiManager = APIManagerMock()
            dataManager = DataManagerMock()
            subject = SearchFavoriteViewModel(apiManager: apiManager, dataManager: dataManager)
            subject.movies = movies
        }
        
        describe(".fetchMovies") {
            it("calls APIManager's fetchMovies") {
                subject.fetchMovies(keyword: "test", { _ in })
                expect(apiManager.isFetchMoviesCalled).to(beTrue())
            }
        }
        
        describe(".getMoviesForResult") {
            it("returns all movies") {
                expect(subject.getMoviesForResult().count).to(equal(movies.count))
            }
        }
    }
}
