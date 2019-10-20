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
  
  var blockOperations: [BlockOperation] = []
  private var hiddenCells: [ExpandableCell] = []
  private var expandedCell: ExpandableCell?
  private var isStatusBarHidden = false
  
  override var prefersStatusBarHidden: Bool {
    return isStatusBarHidden
  }
  
  lazy var viewModel: PhotoViewModel = {
    return PhotoViewModel()
  }()
  
  lazy var activityView: ActivityView = {
    return ActivityView(loadingView: view)
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // for test
    view.accessibilityIdentifier = "onboardingView"
    collectionView.accessibilityIdentifier = "onboardingTableView"
    
    initView()
    initBinding()
    viewModel.dataSource?.fetchDataController?.fetchHandler?.delegate = self
    errorHandler()
    updateTableContent()
  }
  
  func initView() {
    view.backgroundColor = .white
  }
  
  func initBinding() {
    viewModel.isCollectionViewHidden.addObserver { [weak self] (isHidden) in
      self?.collectionView.isHidden = isHidden
    }
    viewModel.isLoading.addObserver { [weak self] (isLoading) in
      if isLoading {
        self?.activityView.loadingIdicator.startAnimating()
      } else {
        self?.activityView.loadingIdicator.stopAnimating()
      }
    }
  }
  
  private func updateTableContent() {
    
    viewModel.performFetch()
    
    InternetMonitor().checkInternetConnection(completion: { result in
      
      switch result {
      case .Success(let hasInternet):
        if hasInternet {
          self.viewModel.fetchPhotoData(completion: { (success) in
            if success {
              self.reloadCollectionViewInMainThread()
            }
          })
        }
      case .Error(let error):
        if let errorHandler = self.viewModel.errorHandling {
          errorHandler(error)
        }
      }
    })
  }
  
  private func reloadCollectionViewInMainThread() {
    if Thread.isMainThread {
      self.collectionView.reloadData()
    } else {
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
  
  func errorHandler() {
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
  
  // MARK: - Deinit
  
  deinit {
    blockOperations.forEach { $0.cancel() }
    blockOperations.removeAll(keepingCapacity: false)
  }
}

// MARK: - NSFetchedResultsControllerDelegate

extension PhotoViewController: NSFetchedResultsControllerDelegate {
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    switch type {
      
    case .insert:
      guard let newIndexPath = newIndexPath else { return }
      let op = BlockOperation { [weak self] in
        self?.collectionView.insertItems(at: [(newIndexPath as IndexPath)])
      }
      blockOperations.append(op)
      
    case .update:
      guard let newIndexPath = newIndexPath else { return }
      let op = BlockOperation { [weak self] in
        self?.collectionView.reloadItems(at: [(newIndexPath as IndexPath)])
      }
      blockOperations.append(op)
      
    case .move:
      guard let indexPath = indexPath else { return }
      guard let newIndexPath = newIndexPath else { return }
      let op = BlockOperation { [weak self] in
        self?.collectionView.moveItem(at: indexPath as IndexPath, to: newIndexPath as IndexPath)
      }
      blockOperations.append(op)
      
    case .delete:
      guard let indexPath = indexPath else { return }
      let op = BlockOperation { [weak self] in
        self?.collectionView.deleteItems(at: [(indexPath as IndexPath)])
      }
      blockOperations.append(op)
      
    @unknown default:
      fatalError()
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    collectionView.performBatchUpdates({
      self.blockOperations.forEach { $0.start() }
    }, completion: { finished in
      self.blockOperations.removeAll(keepingCapacity: false)
    })
  }
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    blockOperations.removeAll(keepingCapacity: false)
  }
}

