//
//  SearchResultViewModelTests.swift
//  GrindhouseCinemaTests
//
//  Created by Kai-Hong Tseng on 2019/4/24.
//  Copyright © 2019 jotshin. All rights reserved.
//

import Quick
import Nimble
@testable import GrindhouseCinema

class SearchResultViewModelTests: QuickSpec {
    override func spec() {
        var subject: SearchResultViewModel!
        var apiManager: APIManagerMock!
        var movies: [Movie] = []
        
        beforeEach {
            let movie1 = Movie(id: 1, title: "Captain Marvel1", posterURL: "75AsB4NRKaYanuCeKYgIh2hfsR1.jpg")
            let movie2 = Movie(id: 2, title: "Captain Marvel2", posterURL: "rXmc4jvDBU04Wp8r5JMWy3HbhB3.jpg")
            let movie3 = Movie(id: 3, title: "Captain Marvel3", posterURL: "AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg")
            apiManager = APIManagerMock()
            movies = [movie1, movie2, movie3]
            subject = SearchResultViewModel(movies: movies, apiManager: apiManager, title: "Captain Marvel")
        }
        
        describe(".numberOfItemsInSection") {
            context("when there are 3 items") {
                it("returns 3") {
                    expect(subject.numberOfItemsInSection()).to(equal(3))
                }
            }
        }
        
        describe(".titleForDisplay") {
            it("returns 2nd item's title") {
                expect(subject.titleForDisplay(indexPath: IndexPath(row: 1, section: 0))).to(equal("Captain Marvel2"))
            }
        }
        
        describe(".posterForDisplay") {
            it("returns 3rd item's poster") {
                var resultImage: UIImage?
                let expectedImage = UIImage(named: "w200.jpg")!
                subject.posterForDisplay(indexPath: IndexPath(row: 2, section: 0), completion: { image in
                    resultImage = image
                })
                expect(resultImage?.pngData()!).toEventually(equal(expectedImage.pngData()!))
            }
        }
        
        describe(".fetchMovieDetail") {
            it("calls APIManager's fetchMovieDetail") {
                subject.fetchMovieDetail(id: 123, { _ in })
                expect(apiManager.isFetchMovieDetailCalled).to(beTrue())
            }
        }
        
        describe(".getMovies") {
            it("returns movies") {
                expect(subject.getMovies().count).to(equal(movies.count))
            }
        }
        
        describe(".getTitle") {
            it("returns correct title") {
                expect(subject.getTitle()).to(equal("Captain Marvel"))
            }
        }
    }
}
