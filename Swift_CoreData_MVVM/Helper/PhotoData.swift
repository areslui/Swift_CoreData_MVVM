//
//  PhotoData.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 19/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import Foundation

struct PhotoData {
  let photoArray: [[String : Any]]
}

extension PhotoData: Parsable {
  
  static func parseObject(dictionary: [String : Any]) -> Result<PhotoData, ErrorResult> {
    if let ary = dictionary["items"] as? [[String : Any]] {
      
      let photoData = PhotoData(photoArray: ary)
      return Result.Success(photoData)
    } else {
      return Result.Error(ErrorResult.parser(string: "Unable to parse"))
    }
  }
}
