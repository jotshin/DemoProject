//
//  APIManager.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/4/23.
//  Copyright © 2019 jotshin. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
    case dataError
}

protocol APIManagerProtocol {
    func fetchMovieDetail(id: Int, _ completion: @escaping (Result<MovieDetail, Error>) -> Void)
    func fetchMovies(keyword: String, _ completion: @escaping (Result<[Movie], Error>) -> Void)
}

struct APIManager: APIManagerProtocol {
    
    private let session = URLSession.shared
    private let baseURL = "https://api.themoviedb.org/3/"
    
    func fetchMovieDetail(id: Int, _ completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        request(method: "get", path: "movie/" + "\(id)" + "?api_key=4cb1eeab94f45affe2536f2c684a5c9e") { result in
            switch result {
            case let .success(data):
                do {
                    let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                    completion(.success(movieDetail))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
            
        }
    }
    
    func fetchMovies(keyword: String, _ completion: @escaping (Result<[Movie], Error>) -> Void) {
        request(method: "get", path: "search/movie?api_key=4cb1eeab94f45affe2536f2c684a5c9e&query=" + keyword) { result in
            switch result {
            case let .success(data):
                do {
                    let movieResults = try JSONDecoder().decode(MovieResults.self, from: data)
                    completion(.success(movieResults.results))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func request(method: String, path: String, _ completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: baseURL + path) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let _ = response as? HTTPURLResponse,
                let data = data else {
                completion(.failure(APIError.requestFailed))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}


