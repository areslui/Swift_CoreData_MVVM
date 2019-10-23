//
//  ImageDownloader.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 22/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader {
  
  private let url: URL
  
  init(url: String?) {
    self.url = URL(string: url ?? "")!
  }
  
  func startDownloadImage(completeDownload: ((Data?) -> ())?) {
    let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
    URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
      print("RESPONSE FROM API: \(String(describing: response))")
      if error != nil {
        print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
        return
      }
      DispatchQueue.main.async {
        if let data = data {
          completeDownload?(data)
        }
      }
    }).resume()
  }
}
