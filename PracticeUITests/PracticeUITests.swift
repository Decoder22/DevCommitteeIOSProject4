//
//  PracticeUITests.swift
//  PracticeUITests
//
//  Created by Brian Johncox on 9/25/18.
//  Copyright © 2018 TabBarPractice. All rights reserved.
//

import XCTest

class PracticeUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.tabBars.buttons["Add Event"].tap()
        app.buttons["Take Picture"].tap()
        app.cells.element(boundBy: 1).tap()
        app.collectionViews.cells.element(boundBy: 1).tap()
        let button = app.tabBars.buttons["Add Event"]
        let exists = NSPredicate(format: "exists == 1")
        
        expectation(for: exists, evaluatedWith: button, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        app.textFields["Name of event"].tap()
        app.textFields["Name of event"].typeText("This is a really cool event!")
        
        app.buttons["Add Your Event"].tap()
        
        
        XCTAssert(app.alerts.element.staticTexts["Event was created"].exists)
        

    }
    
    func testNoNameEnteredOnEventCreation(){
        let app = XCUIApplication()
        app.tabBars.buttons["Add Event"].tap()
        app.buttons["Take Picture"].tap()
        app.cells.element(boundBy: 1).tap()
        app.collectionViews.cells.element(boundBy: 1).tap()
        let button = app.tabBars.buttons["Add Event"]
        let exists = NSPredicate(format: "exists == 1")
        
        expectation(for: exists, evaluatedWith: button, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        app.buttons["Add Your Event"].tap()
        
        
        XCTAssert(app.alerts.element.staticTexts["No name entered"].exists)
    }

}
