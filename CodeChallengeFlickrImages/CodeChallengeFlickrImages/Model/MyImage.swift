//
//  MyImage.swift
//  CodeChallengeFlickrImages
//
//  Created by Ke Liu on 1/14/25.
//

import Foundation

struct MyImage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let author: String
    let publishedDate: String
    let imageURL: URL
}

struct MyImageResponse: Decodable {
    let items: [Item]
    
    struct Item: Decodable {
        let title: String
        let description: String
        let author: String
        let published: String
        let media: Media
    }
    
    struct Media: Decodable {
        let m: String
    }
}

