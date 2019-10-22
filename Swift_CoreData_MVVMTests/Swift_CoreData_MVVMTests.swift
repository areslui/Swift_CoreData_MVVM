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
  
  var viewModel: PhotoViewModel!
  private var service: MockPhotoApiService!
  
  override func setUp() {
    super.setUp()
    viewModel = PhotoViewModel(apiService: service)
  }
  
  override func tearDown() {
    viewModel = nil
    service = nil
    super.tearDown()
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
    DispatchQueue.global().async {
      usleep(1000000 + (arc4random() % 9)*100000)
      
      let dataAry = [["autor": "John", "mediaUrl: "]]
      let images = ["sample", "sample2", "sample3", "sample4", "sample5", "profile"]
      let idx = Int(arc4random()) % images.count
      let randName = images[idx]
      let image = UIImage(contentsOfFile: Bundle.main.path(forResource: randName, ofType: "jpg")!)
      completion(.Success(PhotoData))
    }
  }
}
