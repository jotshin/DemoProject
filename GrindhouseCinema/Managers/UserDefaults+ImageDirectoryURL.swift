//
//  UserDefaults+ImageDirectoryURL.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/5/3.
//  Copyright © 2019 jotshin. All rights reserved.
//

import Foundation

extension UserDefaults {
    private static let imageDictoryURLKey = "ImageDirectoryURLKey"
    
    func imageDirectoryURL() -> URL? {
        return url(forKey: UserDefaults.imageDictoryURLKey)
    }
    
    func setImageDirectoryURL(_ url: URL) {
        set(url, forKey: UserDefaults.imageDictoryURLKey)
    }
}
