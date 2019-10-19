//
//  ViewController.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 19/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import UIKit
import CoreData

class PhotoViewController: UICollectionViewController {
  
  //  var photoIndexPath = IndexPath()
  var blockOperations: [BlockOperation] = []
  private var hiddenCells: [ExpandableCell] = []
  private var expandedCell: ExpandableCell?
  private var isStatusBarHidden = false
  
  override var prefersStatusBarHidden: Bool {
    return isStatusBarHidden
  }
  
  lazy var viewModel: PhotoViewModel = {
    let viewModel = PhotoViewModel()
    return viewModel
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // for test
    view.accessibilityIdentifier = "onboardingView"
    collectionView.accessibilityIdentifier = "onboardingTableView"
    viewModel.dataSource?.fetchDataController?.fetchHandler?.delegate = self
    errorHandler()
    updateTableContent()
  }
  
  func updateTableContent() {
    
    viewModel.performFetch()
    
    InternetMonitor().checkInternetConnection(completion: { result in
      
      switch result {
      case .Success(let hasInternet):
        if hasInternet {
          self.viewModel.fetchPhotoData(completion: { (success) in
            if success {
              if Thread.isMainThread {
                self.collectionView.reloadData()
              } else {
                DispatchQueue.main.async {
                  self.collectionView.reloadData()
                }
              }
            }
          })
        }
      case .Error(let error):
        if let errorHandler = self.viewModel.errorHandling {
          errorHandler(error)
        }
      }
    })
    print("COUNT FETCHED FIRST: \(String(describing: viewModel.fetchCountForView()))")
  }
  
  func errorHandler() {
    // error handler
    viewModel.errorHandling = { [weak self] errorMessage in
      
      DispatchQueue.main.async {
        let controller = UIAlertController(title: "Error!!!", message: errorMessage?.value, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        
        guard let self = self else {
          return
        }
        self.present(controller, animated: true, completion: nil)
      }
    }
  }
  
  //  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  //    if segue.identifier == "showPhotDetail" {
  //      let vc = segue.destination as! PhotoDetailViewController
  //      let photoInfo = viewModel.fetchObjectAtIndex(index: photoIndexPath)
  //      if let url =  photoInfo?.mediaURL {
  //        vc.imageUrl = url
  //      }
  //      if let text = photoInfo?.tags {
  //        vc.detailText = text
  //      }
  //    }
  //  }
  
  // MARK: - CollectionView delegate
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView.contentOffset.y < 0 ||
      collectionView.contentOffset.y > collectionView.contentSize.height - collectionView.frame.height {
      return
    }
    let dampingRatio: CGFloat = 0.8
    let initialVelocity: CGVector = CGVector.zero
    let springParameters: UISpringTimingParameters = UISpringTimingParameters(dampingRatio: dampingRatio, initialVelocity: initialVelocity)
    let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: springParameters)
    
    view.isUserInteractionEnabled = false
    
    if let selectedCell = expandedCell {
      isStatusBarHidden = false
      
      animator.addAnimations {
        selectedCell.collapse()
        
        for cell in self.hiddenCells {
          cell.show()
        }
      }
      animator.addCompletion { _ in
        collectionView.isScrollEnabled = true
        
        self.expandedCell = nil
        self.hiddenCells.removeAll()
      }
    } else {
      isStatusBarHidden = true
      
      collectionView.isScrollEnabled = false
      
      let selectedCell = collectionView.cellForItem(at: indexPath)! as! ExpandableCell
      let frameOfSelectedCell = selectedCell.frame
      
      expandedCell = selectedCell
      hiddenCells = collectionView.visibleCells.map { $0 as! ExpandableCell }.filter { $0 != selectedCell }
      
      animator.addAnimations {
        selectedCell.expand(in: collectionView)
        
        for cell in self.hiddenCells {
          cell.hide(in: collectionView, frameOfSelectedCell: frameOfSelectedCell)
        }
      }
    }
    animator.addAnimations {
      self.setNeedsStatusBarAppearanceUpdate()
    }
    animator.addCompletion { _ in
      self.view.isUserInteractionEnabled = true
    }
    animator.startAnimation()
  }
  
  // MARK: - CollectionView DataSource
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpandableCell", for: indexPath) as! ExpandableCell
    if let photo = viewModel.fetchObjectAtIndex(index: indexPath) {
      cell.setPhotoCellWith(photo: photo)
    }
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.fetchCountForView()
  }
}

// MARK: - NSFetchedResultsControllerDelegate

extension PhotoViewController: NSFetchedResultsControllerDelegate {
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    switch type {
    case .insert:
      print("Insert Object: \(String(describing: newIndexPath))")
      blockOperations.append(
        BlockOperation(block: { [weak self] in
          if let self = self {
            self.collectionView.insertItems(at: [newIndexPath!])
          }
        })
      )
      break
    case .update:
      print("Update Object: \(String(describing: indexPath))")
      blockOperations.append(
        BlockOperation(block: { [weak self] in
          if let self = self {
            self.collectionView.reloadItems(at: [indexPath!])
          }
        })
      )
      break
    case .move:
      print("Move Object: \(String(describing: indexPath))")
      blockOperations.append(
        BlockOperation(block: { [weak self] in
          if let self = self {
            self.collectionView.moveItem(at: indexPath!, to: newIndexPath!)
          }
        })
      )
      break
    case .delete:
      print("Delete Object: \(String(describing: indexPath))")
      blockOperations.append(
        BlockOperation(block: { [weak self] in
          if let self = self {
            self.collectionView.deleteItems(at: [indexPath!])
          }
        })
      )
      break
    @unknown default:
      fatalError()
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    collectionView.performBatchUpdates({ () -> Void in
      for operation: BlockOperation in self.blockOperations {
        operation.start()
      }
    }, completion: { (finished) -> Void in
      self.blockOperations.removeAll(keepingCapacity: false)
    })
  }
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    blockOperations.removeAll(keepingCapacity: false)
  }
}

