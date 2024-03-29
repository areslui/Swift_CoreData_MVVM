//
//  FetchDataController.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 19/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import UIKit
import CoreData

struct FetchDataController {
  
  lazy var fetchHandler: NSFetchedResultsController<NSFetchRequestResult>? = {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Photo.self))
    
    // sort contents by author's name
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "author", ascending: true)]
    guard let viewContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
      return NSFetchedResultsController()
    }
    let dataFetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    return dataFetchResultController
  }()
}
