//
//  ConversionsUITests.swift
//  ConversionsUITests
//
//  Created by Petr Zvoníček on 26.03.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import XCTest

class ConversionsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScreen1() {        
        snapshot("01MainScreen")
    }
    
    func testScreen2() {
        let app = XCUIApplication()
        NSThread.sleepForTimeInterval(0.5)
        app.collectionViews.childrenMatchingType(.Cell).elementBoundByIndex(0).tap()
        NSThread.sleepForTimeInterval(2.0)
        app.buttons["Play"].tap()
        NSThread.sleepForTimeInterval(0.1)
        app.buttons["1 yard"].tap()
        
        snapshot("02ClosedEnded")
    }

    func testScreen3() {
        let app = XCUIApplication()
        NSThread.sleepForTimeInterval(0.5)
        app.collectionViews.childrenMatchingType(.Cell).elementBoundByIndex(0).tap()
        NSThread.sleepForTimeInterval(2.0)
        app.buttons["Play"].tap()
        NSThread.sleepForTimeInterval(0.1)
        app.buttons["1 yard"].tap()
        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).elementBoundByIndex(2).childrenMatchingType(.Other).element
        element.tap()
        app.buttons["10 inches"].tap()
        element.tap()
        app.buttons["Check"].tap()
        element.tap()
        
        app.buttons["1"].tap()
        app.buttons["6"].tap()
        app.buttons["SUBMIT"].tap()
        
        snapshot("04Numeric")
    }

    func testScreen4() {
        let app = XCUIApplication()
        NSThread.sleepForTimeInterval(0.5)
        app.collectionViews.childrenMatchingType(.Cell).elementBoundByIndex(0).tap()
        NSThread.sleepForTimeInterval(2.0)
        app.buttons["Play"].tap()
        NSThread.sleepForTimeInterval(0.1)
        app.buttons["1 yard"].tap()
        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).elementBoundByIndex(2).childrenMatchingType(.Other).element
        element.tap()
        app.buttons["10 inches"].tap()
        element.tap()
        app.buttons["Check"].tap()
        element.tap()
        
        app.buttons["1"].tap()
        app.buttons["6"].tap()
        app.buttons["SUBMIT"].tap()
        element.tap()
        
        snapshot("03Numeric")
    }
    
}
