//
//  YaImageFeedUITests.swift
//  YaImageFeedUITests
//
//  Created by Сергей Денисенко on 05.11.2023.
//

import XCTest
@testable import YaImageFeed

final class YaImageFeedUITests: XCTestCase {
    

    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testAuth() throws {

        app.buttons["Authenticate"].tap()

        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))

        loginTextField.tap()
        loginTextField.typeText("")
        dismissKeyboardIfPresent()
        webView.swipeUp()

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))

        passwordTextField.tap()
        passwordTextField.typeText("")

        webView.swipeUp()
        webView.buttons["Login"].tap()

        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }

    func testFeed() throws {

        

        sleep(10)
        let tablesQuery = app.tables

        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cell.waitForExistence(timeout: 15))
        cell.buttons["likeButtonToTap"].tap()

        sleep(10)

        cellToLike.buttons["likeButtonToTap"].tap()

        sleep(10)

        cell.tap()

        sleep(30)

        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        let navBackButton = app.buttons["navBackButton"]
        navBackButton.tap()

        sleep(10)

        cellToLike.swipeUp()

        sleep(5)

    }

    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts["Sergey Denisenko"].exists)
        XCTAssertTrue(app.staticTexts["@selick"].exists)

        app.buttons["LogoutButtonId"].tap()

        app.alerts["Уверены что хотите выйти?"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(5)
        let button = app.buttons["Authenticate"]
        XCTAssertTrue(button.exists)
    }

    func dismissKeyboardIfPresent() {
        if app.keyboards.element(boundBy: 0).exists {
            if UIDevice.current.userInterfaceIdiom == .pad {
                app.keyboards.buttons["Hide keyboard"].tap()
            } else {
                app.toolbars.buttons["Done"].tap()
            }
        }
    }
}
