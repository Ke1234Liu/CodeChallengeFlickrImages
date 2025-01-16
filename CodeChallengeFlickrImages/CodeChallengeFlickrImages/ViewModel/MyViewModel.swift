//
//  MyViewModel.swift
//  CodeChallengeFlickrImages
//
//  Created by Ke Liu on 1/14/25.
//

import Foundation

class MyViewModel: ObservableObject {
    @Published var images: [MyImage] = []
    @Published var isLoading: Bool = false
    var networkService = NetworkService()
    
    func searchImages(for tags: String) {
        guard !tags.isEmpty else {
            self.images = []
            return
        }
        
        isLoading = true
        
        networkService.fetchImages(for: tags) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let images):
                    self?.images = images
                case .failure(let error):
                    print("Error fetching images: \(error.localizedDescription)")
                }
            }
        }
    }
}

