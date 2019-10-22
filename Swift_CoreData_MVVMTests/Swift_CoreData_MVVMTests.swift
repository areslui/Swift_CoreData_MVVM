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
  var dataSource: PhotoDataSource!
  fileprivate var service: MockPhotoApiService!
  
  override func setUp() {
    super.setUp()
    viewModel = PhotoViewModel(apiService: MockPhotoApiService())
  }
  
  override func tearDown() {
    viewModel = nil
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
      var dataAry = [[String: Any]]()
      for var i in 0...20 {
        let images = ["sample1", "sample2", "sample3", "sample4", "sample5", "sample6"]
        let idx = Int(arc4random()) % images.count
        let randName = images[idx]
        let image = UIImage(contentsOfFile: Bundle.main.path(forResource: randName, ofType: "jpg")!)
        guard let imagedata = image?.jpegData(compressionQuality: 1) else {
          debugPrint("\(type(of: self)): \(#function): image to data error!")
          return
        }
        let randomDict = ["author": String.anyName, "tag": String.loremIpsum, "imageData": imagedata] as [String : Any]
        dataAry.append(randomDict)
        i += 1
      }
      let photoData = PhotoData(photoArray: dataAry)
      completion(.Success(photoData))
    }
  }
}

public extension String {
  /// Ramdomly generated text
  static var loremIpsum: String {
    let baseStr = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas blandit aliquet orci, tincidunt pellentesque eros condimentum quis. Morbi efficitur, metus at tristique gravida, nisi nisi accumsan dolor, a porttitor libero libero eu nunc. Aenean augue mi, facilisis in vulputate at, luctus eget nibh. Nulla condimentum metus sit amet nunc commodo, at tempor velit hendrerit. Vivamus vitae pharetra quam, a fermentum diam. Aliquam dapibus justo ut turpis mattis, in feugiat purus fringilla. In hac habitasse platea dictumst."
    let strLst = baseStr.components(separatedBy: " ")
    let offset = Int(arc4random_uniform(UInt32(strLst.count)))
    let substringLst = strLst[offset..<strLst.count]
    return substringLst.joined(separator: " ")
  }
  
  private static var nameList = ["Emily", "Michael", "Hannah", "Jacob", "Alex", "Ashley", "Tyler", "Taylor", "Andrew", "Jessica", "Daniel", "Katie", "John", "Emma", "Matthew", "Lauren", "Ryan", "samantha", "Austin", "Rachel", "David", "olivia", "Chris", "Kayla", "Nick", "Anna", "Brandon", "Megan", "Nathan", "Alyssa", "Anthony", "Alexis", "Grace", "Justin", "Madison", "Joshua", "elizabeth", "Jordan", "Nicole", "Jake", "Jack", "Abby", "Dylan", "Victoria", "james", "Brianna", "kyle", "Morgan", "Kevin", "Amber", "Ben", "Sydney", "Noah", "Brittany", "Eric", "Haley", "Sam", "Natalie", "Christian", "Julia", "Josh", "Savannah", "Zach", "Danielle", "Joseph", "Courtney", "Logan", "Rebecca", "Jonathan", "Paige", "Adam", "Jasmine", "Aaron", "Sara", "Jason", "Stephanie", "Christopher"]
  /// Ramdomly generated name
  static var anyName: String {
    let randIdx = Int(arc4random_uniform(UInt32(nameList.count)))
    return nameList[randIdx]
  }
}
