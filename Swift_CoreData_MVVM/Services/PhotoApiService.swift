//
//  PhotoApiService.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 19/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import Foundation

protocol PhotoApiServiceProtocol: class {
  func getDataWith(completion: @escaping (Result<PhotoData, ErrorResult>) -> Void)
}

final class PhotoApiService: RequestHandler, PhotoApiServiceProtocol {
    
  private lazy var endPoint: String = { return "https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=cars&nojsoncallback=1#"
  }()
  
  private var task: URLSessionTask?
  
  func getDataWith(completion: @escaping (Result<PhotoData, ErrorResult>) -> Void) {
    cancelFetch()
    task = RequestService().loadData(urlString: endPoint, completion: networkResult(completion: completion))
  }
  
  private func cancelFetch() {
    if let task = task {
      task.cancel()
    }
    task = nil
  }
}

final class MockPhotoApiService: PhotoApiServiceProtocol {
  
  func getDataWith(completion: @escaping (Result<PhotoData, ErrorResult>) -> Void) {
    
  }
}
