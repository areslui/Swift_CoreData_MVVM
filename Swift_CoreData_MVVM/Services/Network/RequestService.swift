//
//  RequestService.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 19/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import Foundation

final class RequestService {
  
  func loadData(urlString: String, session: URLSession = URLSession(configuration: .default), completion: @escaping (Result<Data, ErrorResult>) -> Void) -> URLSessionTask? {
    
    guard let url = URL(string: urlString) else {
      completion(.Error(.network(string: "Wrong url format")))
      return nil
    }
    
    var request = RequestFactory.request(method: .GET, url: url)
    
    InternetMonitor().checkInternetConnection { (result) in
      switch result {
      case .Success(_):
        break
      case .Error(let error):
        completion(.Error(.network(string: "no internet!" + error.localizedDescription)))
        request.cachePolicy = .returnCacheDataDontLoad
        return
      }
    }
    
    let task = session.dataTask(with: request) { (data, response, error) in
      if let error = error {
        completion(.Error(.network(string: "An error occured during request :" + error.localizedDescription)))
        return
      }
      
      if let data = data {
        completion(.Success(data))
      }
    }
    task.resume()
    return task
  }
}
