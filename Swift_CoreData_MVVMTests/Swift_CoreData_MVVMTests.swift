//
//  Swift_CoreData_MVVMTests.swift
//  Swift_CoreData_MVVMTests
//
//  Created by Ares on 19/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import XCTest
@testable import Swift_CoreData_MVVM

class Swift_CoreData_MVVMTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

final class MockPhotoApiService: PhotoApiServiceProtocol {
  
  func getDataWith(completion: @escaping (Result<PhotoData, ErrorResult>) -> Void) {
    
  }
}
