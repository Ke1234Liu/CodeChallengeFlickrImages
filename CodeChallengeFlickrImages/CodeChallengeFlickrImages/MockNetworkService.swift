//
//  MockNetworkService.swift
//  CodeChallengeFlickrImages
//
//  Created by Ke Liu on 1/14/25.
//

import Foundation

class MockNetworkService: NetworkService {
    var mockResult: Result<[MyImage], Error>?
    
    override func fetchImages(for tags: String, completion: @escaping (Result<[MyImage], Error>) -> Void) {
        if let result = mockResult {
            completion(result)
        }
    }
}
