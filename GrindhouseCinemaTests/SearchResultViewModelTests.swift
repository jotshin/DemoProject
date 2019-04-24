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
        
        beforeEach {
            let movie1 = Movie(id: 1, title: "Captain Marvel1", posterURL: "75AsB4NRKaYanuCeKYgIh2hfsR1.jpg")
            let movie2 = Movie(id: 2, title: "Captain Marvel2", posterURL: "rXmc4jvDBU04Wp8r5JMWy3HbhB3.jpg")
            let movie3 = Movie(id: 3, title: "Captain Marvel3", posterURL: "AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg")
            subject = SearchResultViewModel(movies: [movie1, movie2, movie3], apiManager: APIManagerMock())
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
                let expectedImage = try? UIImage(data: Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w200/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg")!))
                expect(subject.posterForDisplay(indexPath: IndexPath(row: 2, section: 0)).pngData()!).to(equal(expectedImage?.pngData()!))
            }
        }
    }
}
