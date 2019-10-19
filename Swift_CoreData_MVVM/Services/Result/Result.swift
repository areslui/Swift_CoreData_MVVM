//
//  Result.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 19/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import Foundation

enum Result <T, E: Error> {
  case Success(T)
  case Error(E)
}
