//
//  ImageProvider.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/5/3.
//  Copyright © 2019 jotshin. All rights reserved.
//

import UIKit

enum ImageProviderError: Error {
    case dataError
}

struct ImageProvider {
    
    private let operationQueue = OperationQueue()
    private let cache = NSCache<NSString, NSData>()
    
    // MARK: - Public methods
    func load(from url: URL, key: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let existingImage = imageForKey(key: key) {
            completion(.success(existingImage))
            return
        }
        guard !operationQueue.isSuspended else { return }
        
        operationQueue.addOperation {
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    OperationQueue.main.addOperation {
                        completion(.failure(ImageProviderError.dataError))
                    }
                    return
                }
                try self.setImage(data, forKey: key)
                OperationQueue.main.addOperation {
                    completion(.success(image))
                }
            } catch {
                OperationQueue.main.addOperation {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func suspendLoading() {
        operationQueue.isSuspended = true
    }
    
    func resumeLoading() {
        operationQueue.isSuspended = false
    }
}

// MARK: - Helpers
extension ImageProvider {
    private func imageURLForKey(_ key: String) -> URL? {
        
        let documentsDirectories =
            FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        guard let documentDirectory = documentsDirectories.first else {
            return nil
        }
        return documentDirectory.appendingPathComponent(key)
    }
    
    private func setImage(_ imageData: Data, forKey key: String) throws {
        cache.setObject(imageData as NSData, forKey: key as NSString)
        
        if let imageURL = imageURLForKey(key) {
            do {
                try imageData.write(to: imageURL, options: .atomicWrite)
            } catch {
                throw error
            }
        }
    }
    
    private func imageForKey(key: String) -> UIImage? {
        if let data = cache.object(forKey: key as NSString),
            let existingImage = UIImage(data: data as Data)
            {
            return existingImage
        }

        guard let imageURL = imageURLForKey(key),
            let imageFromDisk = UIImage(contentsOfFile: imageURL.path),
            let imageData = imageFromDisk.pngData() else {
            return nil
        }

        cache.setObject(imageData as NSData, forKey: key as NSString)
        return imageFromDisk
    }
}
