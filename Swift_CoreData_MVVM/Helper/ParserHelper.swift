//
//  ParserHelper.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 19/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import Foundation

protocol Parsable {
  static func parseObject(dictionary: [String: Any]) -> Result<Self, ErrorResult>
}

final class ParserHelper {
  
  static func parse<T: Parsable>(data: Data, completion: (Result<T, ErrorResult>) -> Void) {
    
    do {
      if let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
        
        // init final result
        // check foreach dictionary if parsable
        switch T.parseObject(dictionary: dictionary) {
        case .Error(let error):
          completion(.Error(error))
          break
        case .Success(let newModel):
          completion(.Success(newModel))
          break
        }
      } else {
        // not an array
        completion(.Error(.parser(string: "Json data is not an array")))
      }
    } catch {
      // can't parse json
      completion(.Error(.parser(string: "Error while parsing json data")))
    }
  }
}
