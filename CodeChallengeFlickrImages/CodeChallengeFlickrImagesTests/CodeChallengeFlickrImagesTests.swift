//
//  CodeChallengeFlickrImagesTests.swift
//  CodeChallengeFlickrImagesTests
//
//  Created by Ke Liu on 1/14/25.
//

import Testing
@testable import CodeChallengeFlickrImages
import XCTest

final class FlickrViewModelTests: XCTestCase {
    var viewModel: MyViewModel!
    var mockService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        viewModel = MyViewModel()
        viewModel.networkService = mockService
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testSearchImagesSuccess() {
        let mockImages = [
            MyImage(
                title: "Test Image 1",
                description: "Description 1",
                author: "Author 1",
                publishedDate: Date.now,
                imageURL: URL(string: "https://example.com/image1.jpg")!
            ),
            MyImage(
                title: "Test Image 2",
                description: "Description 2",
                author: "Author 2",
                publishedDate: Date.now,
                imageURL: URL(string: "https://example.com/image2.jpg")!
            )
        ]
        mockService.mockResult = .success(mockImages)
        
        let expectation = self.expectation(description: "Fetching images")
        viewModel.searchImages(for: "test")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(viewModel.images.count, mockImages.count)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.images[0].title, "Test Image 1")
    }
    
    func testSearchImagesFailure() {
        mockService.mockResult = .failure(NSError(domain: "Test Error", code: -1, userInfo: nil))
        
        let expectation = self.expectation(description: "Fetching images")
        viewModel.searchImages(for: "test")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(viewModel.images.count, 0)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testSearchImagesEmptyTags() {
        viewModel.searchImages(for: "")
        
        XCTAssertEqual(viewModel.images.count, 0)
        XCTAssertFalse(viewModel.isLoading)
    }
}


