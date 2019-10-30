//
//  Swift_CoreData_MVVMUITests.swift
//  Swift_CoreData_MVVMUITests
//
//  Created by Ares on 19/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import XCTest

class Swift_CoreData_MVVMUITests: XCTestCase {
  
  var app: XCUIApplication!
  
  override func setUp() {
    app = XCUIApplication()
    app.launch()
    continueAfterFailure = false
  }
  
  func testPhotoTapped() {
    
    // given
    let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
    
    // then
    if firstChild.exists {
         firstChild.tap()
    }
  }
  
  func testLaunchPerformance() {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
      // This measures how long it takes to launch your application.
      measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
        XCUIApplication().launch()
      }
    }
  }
}
