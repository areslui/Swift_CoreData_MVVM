//
//  PhotoListViewModel.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 20/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import Foundation
import UIKit

class PhotoListViewModel {
  let title = Observable<String>(value: "Loading...")
  let isLoading = Observable<Bool>(value: false)
  let isTableViewHidden = Observable<Bool>(value: false)
}
