//
//  ErrorResult.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 19/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import Foundation

enum ErrorResult: Error {
  case network(string: String)
  case parser(string: String)
  case custom(string: String)
  
  var value: String {
    switch self {
    case .network(string: let value):
      return value
    case .parser(string: let value):
      return value
    case let .custom(string: value):
      return value
    }
  }
}
