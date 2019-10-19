//
//  PhotoViewModel.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 19/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import CoreData
import Network
import UIKit

class PhotoViewModel {
    
  var dataSource: PhotoDataSource?
  private var apiService: PhotoApiServiceProtocol?
  var checkInternetHandling: ((Bool?) -> Void)?
  var errorHandling: ((ErrorResult?) -> Void)?
  
  init(dataSource: PhotoDataSource = PhotoDataSource(),
       apiService: PhotoApiServiceProtocol = PhotoApiService()) {
    self.dataSource = dataSource
    self.apiService = apiService
  }
  
  func fetchPhotoData(completion: @escaping (_ sucess: Bool) -> ()) {
    
    guard let service = apiService else {
      errorHandling?(.custom(string: "Sevice missing!!!"))
      return
    }
    
    service.getDataWith { (result) in
      switch result {
      case .Success(let data):
        self.clearData()
        self.saveInCoreDataWith(array: data.photoArray)
        completion(true)
      case .Error(let message):
        DispatchQueue.main.async {
          self.errorHandling?(message)
          print(message)
          completion(false)
        }
      }
    }
  }
  
  func performFetch() {
    dataSource?.coreDataPerformFetch()
  }
  
  func fetchObjectAtIndex(index: IndexPath) -> Photo? {
    guard let photoObj = dataSource?.coreDatafetchObjectAtIndex(index) else {
      return nil
    }
    return photoObj
  }
  
  func fetchCountForView() -> Int {
    return dataSource?.coreDataFetchCountForView() ?? 0
  }
  
  // MARK: - Data Process
  
  private func createPhotoEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
    guard let context = dataSource?.getViewContext() else { return nil }
    if let photoEntity = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo {
      photoEntity.author = dictionary["author"] as? String
      photoEntity.tags = dictionary["tags"] as? String
      let mediaDictionary = dictionary["media"] as? [String: AnyObject]
      photoEntity.mediaURL = mediaDictionary?["m"] as? String
      return photoEntity
    }
    return nil
  }
  
  private func saveInCoreDataWith(array: [[String: AnyObject]]) {
    _ = array.map{ createPhotoEntityFrom(dictionary: $0) }
    dataSource?.saveDataWithViewContext()
  }
  
  private func clearData() {
    dataSource?.clearCoreData()
  }
}
