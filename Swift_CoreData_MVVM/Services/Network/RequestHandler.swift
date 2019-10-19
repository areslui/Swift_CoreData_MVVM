//
//  RequestHandler.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 19/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import Foundation

class RequestHandler {
  
  func networkResult<T: Parsable>(completion: @escaping ((Result<T, ErrorResult>) -> Void)) ->
    ((Result<Data, ErrorResult>) -> Void) {
      
      return { dataResult in
        DispatchQueue.global(qos: .background).async(execute: {
          switch dataResult {
          case .Success(let data) :
            ParserHelper.parse(data: data, completion: completion)
            break
          case .Error(let error) :
            print("Network error \(error)")
            completion(.Error(.network(string: "Network error " + error.localizedDescription)))
            break
          }
        })
      }
  }
}
