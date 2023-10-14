//
//  YaImageFeedTests.swift
//  YaImageFeedTests
//
//  Created by Сергей Денисенко on 14.10.2023.
//

import XCTest
@testable import YaImageFeed

final class ImagesListServiceTests: XCTestCase {

    func testExample() throws {
        let service = ImagesListService()

        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }

        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 10)

        XCTAssertEqual(service.photos.count, 10)
    }
}
