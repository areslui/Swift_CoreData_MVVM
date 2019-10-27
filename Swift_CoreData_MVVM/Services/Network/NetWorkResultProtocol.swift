//
//  RequestHandler.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 19/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import Foundation

protocol NetWorkResultProtocol {
  func networkResult<T: Parsable>(completion: @escaping ((Result<T, ErrorResult>) -> Void)) ->
  ((Result<Data, ErrorResult>) -> Void)
}
