//
//  Observable.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 20/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import Foundation

class Observable<T> {
  var value: T {
    didSet {
      DispatchQueue.main.async {
        self.valueChanged?(self.value)
      }
    }
  }
  
  private var valueChanged: ((T) -> Void)?
  
  init(value: T) {
    self.value = value
  }
  
  /// Add closure as an observer and trigger the closure imeediately if fireNow = true
  func addObserver(fireNow: Bool = true, _ onChange: ((T) -> Void)?) {
    valueChanged = onChange
    if fireNow {
      onChange?(value)
    }
  }
  
  func removeObserver() {
    valueChanged = nil
  }
}
