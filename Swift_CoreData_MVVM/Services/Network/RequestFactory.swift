//
//  RequestFactory.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 19/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import Foundation

final class RequestFactory {
  
  enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
  }
  
  static func request(method: Method, url: URL) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    return request
  }
}
