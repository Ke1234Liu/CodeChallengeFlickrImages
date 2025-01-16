//
//  DetailView.swift
//  CodeChallengeFlickrImages
//
//  Created by Ke Liu on 1/14/25.
//

import SwiftUI

struct DetailView: View {
    let image: MyImage
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(image.title)
                    .font(.title)
                
                AsyncImage(url: image.imageURL)
                
                if let description = image.description.attributedHtmlString {
                    Text(description.string)
                        .font(.body)
                }
                
                Text("Author: \(image.author)")
                    .font(.body)
                
                if let date = formatPublishedDate(image.publishedDate) {
                    Text("Published date: \(date)")
                        .font(.body)
                }
                
                if let dimension = image.description.extractImageDimensions() {
                    Text("Width: \(dimension.width), Height: \(dimension.height)")
                        .font(.body)
                }
            }
            .padding()
        }
    }
    
    func formatPublishedDate(_ dateString: String) -> String? {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime]
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .short
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
}

extension String {
    
    var attributedHtmlString: NSAttributedString? {
        try? NSAttributedString(
            data: Data(utf8),
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
    }
    
    func extractImageDimensions() -> (width: Int, height: Int)? {
        let pattern = "width=\"(\\d+)\" height=\"(\\d+)\""
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            let widthRange = Range(match.range(at: 1), in: self)
            let heightRange = Range(match.range(at: 2), in: self)
            if let widthString = widthRange.map({ String(self[$0]) }),
               let heightString = heightRange.map({ String(self[$0]) }),
               let width = Int(widthString),
               let height = Int(heightString) {
                return (width, height)
            }
        }
        return nil
    }
}
