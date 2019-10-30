//
//  HalfTunesFakeTests.swift
//  Swift_CoreData_MVVMTests
//
//  Created by Ares on 27/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import XCTest
@testable import Swift_CoreData_MVVM

class HalfTunesFakeTests: XCTestCase {
  
  var viewModel: PhotoViewModel!
  
  override func setUp() {
    super.setUp()
    viewModel = PhotoViewModel(apiService: MockPhotoApiService())
  }
  
  override func tearDown() {
    viewModel = nil
    super.tearDown()
  }
  
  func testFakeJsonData() {
    // given
    let promise = expectation(description: "Status code: 200")

    // when
    viewModel.fetchPhotoData { (success) in
      if success {
        print("testFakeJsonData success!!!")
      }
      promise.fulfill()

      // then
      XCTAssertEqual(success, true, "result should be true!")
    }
    wait(for: [promise], timeout: 5)
  }
}

final class MockPhotoApiService: PhotoApiServiceProtocol, NetWorkResultProtocol {
  
  private lazy var endPoint: String = {
    return "https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=cars&nojsoncallback=1#"
  }()
  
  private var task: URLSessionTask?
  
  func getDataWith(completion: @escaping (Result<PhotoData, ErrorResult>) -> Void) {
    cancelFetch()
    task = RequestService().loadData(urlString: endPoint, completion: networkResult(completion: completion))
  }
  
  func networkResult<T>(completion: @escaping ((Result<T, ErrorResult>) -> Void)) -> ((Result<Data, ErrorResult>) -> Void) where T : Parsable {
    
    return { dataResult in
      DispatchQueue.global(qos: .background).async(execute: {
        switch dataResult {
        case .Success(_) :
          let testBundle = Bundle.main
          let path = testBundle.path(forResource: "CoreData", ofType: "json")
          let fakeData = try? Data(contentsOf: URL(fileURLWithPath: path!))
          ParserHelper.parse(data: fakeData!, completion: completion)
          break
        case .Error(let error) :
          debugPrint("\(type(of: self)): \(#function): Network error \(error)")
          completion(.Error(.network(string: "Network error " + error.localizedDescription)))
          break
        }
      })
    }
  }
  
  private func cancelFetch() {
    if let task = task {
      task.cancel()
    }
    task = nil
  }
}
