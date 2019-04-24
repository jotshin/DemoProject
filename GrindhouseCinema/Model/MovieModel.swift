//
//  MovieModel.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/4/24.
//  Copyright © 2019 jotshin. All rights reserved.
//

import Foundation

struct MovieResults: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let title: String
    let posterURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterURL = "poster_path"
    }
}
