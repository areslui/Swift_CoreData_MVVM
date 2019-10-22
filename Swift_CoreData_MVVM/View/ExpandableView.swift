//
//  ExpandableView.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 22/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import Foundation
import UIKit

class ExpandableView {
  
  private var hiddenCells: [ExpandableCell] = []
  private var expandedCell: ExpandableCell?
  
  func startExpandableAnimation(with controller: PhotoViewController, didSelectItemAt indexPath: IndexPath) {
    if controller.collectionView.contentOffset.y < 0 ||
      controller.collectionView.contentOffset.y > controller.collectionView.contentSize.height - controller.collectionView.frame.height {
      return
    }
    let dampingRatio: CGFloat = 0.8
    let initialVelocity: CGVector = CGVector.zero
    let springParameters: UISpringTimingParameters = UISpringTimingParameters(dampingRatio: dampingRatio, initialVelocity: initialVelocity)
    let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: springParameters)
    
    controller.view.isUserInteractionEnabled = false
    
    if let selectedCell = expandedCell {
      controller.isStatusBarHidden = false
      
      animator.addAnimations {
        selectedCell.collapse()
        
        for cell in self.hiddenCells {
          cell.show()
        }
      }
      animator.addCompletion { _ in
        controller.collectionView.isScrollEnabled = true
        
        self.expandedCell = nil
        self.hiddenCells.removeAll()
      }
    } else {
      controller.isStatusBarHidden = true
      
      controller.collectionView.isScrollEnabled = false
      
      let selectedCell = controller.collectionView.cellForItem(at: indexPath)! as! ExpandableCell
      let frameOfSelectedCell = selectedCell.frame
      
      expandedCell = selectedCell
      hiddenCells = controller.collectionView.visibleCells.map { $0 as! ExpandableCell }.filter { $0 != selectedCell }
      
      animator.addAnimations {
        selectedCell.expand(in: controller.collectionView)
        
        for cell in self.hiddenCells {
          cell.hide(in: controller.collectionView, frameOfSelectedCell: frameOfSelectedCell)
        }
      }
    }
    animator.addAnimations {
      controller.setNeedsStatusBarAppearanceUpdate()
    }
    animator.addCompletion { _ in
      controller.view.isUserInteractionEnabled = true
    }
    animator.startAnimation()
  }
}
