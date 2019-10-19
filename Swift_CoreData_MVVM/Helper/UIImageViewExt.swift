//
//  UIImageViewExt.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 19/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import UIKit

extension UIImageView {
  
  func loadImageUsingCacheWithURLString(_ URLString: String, placeHolder: UIImage?) {
    
    image = placeHolder

    if let url = URL(string: URLString) {
      let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
      URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
        print("RESPONSE FROM API: \(String(describing: response))")
        if error != nil {
          print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
          return
        }
        DispatchQueue.main.async {
          if let data = data {
            if let downloadedImage = UIImage(data: data) {
              self.image = downloadedImage
            }
          }
        }
      }).resume()
    }
  }
}
