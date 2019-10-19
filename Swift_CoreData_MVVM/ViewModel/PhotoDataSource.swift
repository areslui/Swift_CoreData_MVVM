//
//  PhotoDataSource.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 19/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import UIKit
import CoreData

class PhotoDataSource: NSObject {
    
  private var coreDataManager: CoreDataManager?
  var fetchDataController: FetchDataController?
    
  init(_ fetchDataController: FetchDataController = FetchDataController()) {
    self.fetchDataController = fetchDataController
  }
  
  func getViewContext() -> NSManagedObjectContext? {
    return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  }
  
  func saveDataWithViewContext() {
    do {
      try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.save()
    } catch let error {
      print(error)
    }
  }
  
  func clearCoreData () {
    guard let context = getViewContext() else { return }
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
    do {
      let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
      _ = objects.map{$0.map{context.delete($0)}}
      saveDataWithViewContext()
    } catch let error {
      print("ERROR DELETING : \(error)")
    }
  }
  
  func coreDataPerformFetch() {
    do {
      try fetchDataController?.fetchHandler?.performFetch()
    } catch (let error) {
      debugPrint("\(type(of: self)): \(#function): \(error.localizedDescription)")
    }
  }
  
  func coreDatafetchObjectAtIndex(_ index: IndexPath) -> Photo? {
    guard let photo = fetchDataController?.fetchHandler?.object(at: index) as? Photo else {
      return nil
    }
    return photo
  }
  
  func coreDataFetchCountForView() -> Int? {
    return fetchDataController?.fetchHandler?.sections?.first?.numberOfObjects
  }
}
