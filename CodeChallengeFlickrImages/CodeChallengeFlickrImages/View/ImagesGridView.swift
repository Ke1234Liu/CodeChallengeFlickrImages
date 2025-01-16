//
//  ImagesGridView.swift
//  CodeChallengeFlickrImages
//
//  Created by Ke Liu on 1/15/25.
//

import SwiftUI

struct ImagesGridView: View {
    @StateObject private var viewModel = MyViewModel()
    @State private var searchText: String = ""
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TextField("Type to search for images", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: searchText) {
                        viewModel.searchImages(for: searchText.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                    .background(Color.blue)
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                }
                
                scrollView
            }
        }
    }
    
    var scrollView: some View {
        ScrollView {
            if viewModel.images.isEmpty && !viewModel.isLoading {
                Text("No results found.")
                    .padding()
            } else {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.images) { image in
                        NavigationLink(destination: DetailView(image: image)) {
                            AsyncImage(url: image.imageURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let img):
                                    img
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipped()
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(height: 100)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ImagesGridView()
}
