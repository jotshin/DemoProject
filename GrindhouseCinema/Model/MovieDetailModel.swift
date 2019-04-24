//
//  MovieDetailModel.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/4/24.
//  Copyright © 2019 jotshin. All rights reserved.
//

import Foundation

struct MovieDetail: Codable {
    let id: String
    let title: String
    let posterURL: String
    let overview: String
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterURL = "poster_path"
        case overview
        case rating = "vote_average"
    }
}
