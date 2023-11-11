//
//  ProfileViewTests.swift
//  YaImageFeedTests
//
//  Created by Сергей Денисенко on 05.11.2023.
//

@testable import YaImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testPresenterCallsLoadRequest() {

        //given
        let view = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter()
        presenter.view = view
        view.presenter = presenter

        //when
        presenter.configureSelf()
        presenter.viewDidLoad()

        //then
        XCTAssertTrue(view.didAvatarUpdate)
    }
}



