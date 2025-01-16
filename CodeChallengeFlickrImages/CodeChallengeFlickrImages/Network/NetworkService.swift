//
//  NetworkService.swift
//  CodeChallengeFlickrImages
//
//  Created by Ke Liu on 1/14/25.
//

import Foundation

class NetworkService {

    func fetchImages(for tags: String, completion: @escaping (Result<[MyImage], Error>) -> Void) {
        guard !tags.isEmpty else {
            completion(.success([]))
            return
        }
        
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(tags)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MyImageResponse.self, from: data)
                let images = response.items.compactMap { item in
                    MyImage(
                        title: item.title,
                        description: item.description,
                        author: item.author,
                        publishedDate: item.published,
                        imageURL: URL(string: item.media.m)!
                    )
                }
                completion(.success(images))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
