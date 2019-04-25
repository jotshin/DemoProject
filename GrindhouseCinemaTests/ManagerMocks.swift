//
//  ManagerMocks.swift
//  GrindhouseCinemaTests
//
//  Created by Kai-Hong Tseng on 2019/4/25.
//  Copyright © 2019 jotshin. All rights reserved.
//

import Foundation
@testable import GrindhouseCinema

class APIManagerMock: APIManagerProtocol {
    var isFetchMovieDetailCalled = false
    var isFetchMoviesCalled = false
    
    func fetchMovieDetail(id: Int, _ completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        isFetchMovieDetailCalled = true
    }
    
    func fetchMovies(keyword: String, _ completion: @escaping (Result<[Movie], Error>) -> Void) {
        isFetchMoviesCalled = true
    }
}

class DataManagerMock: DataManagerProtocol {
    var isSaveFetchedMoviesCalled = false
    var isFetchSavedMoviesCalled = false
    
    func saveFetchedMovies(_ movies: [Movie]) {
        isSaveFetchedMoviesCalled = true
    }
    
    func fetchSavedMovies(_ completion: @escaping ([Movie]) -> Void) {
        isFetchSavedMoviesCalled = true
    }
}
