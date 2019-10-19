//
//  ExpandableCell.swift
//  Swift_CoreData_MVVM
//
//  Created by Ares on 19/10/2019.
//  Copyright © 2019 haochen. All rights reserved.
//

import UIKit

class ExpandableCell: UICollectionViewCell, Expandable {
  
  @IBOutlet weak var photoImageview: UIImageView!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var tagsLabel: UILabel!
  
  private var initialFrame: CGRect?
  private var initialCornerRadius: CGFloat?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureAll()
  }
  
  // MARK: - Configuration
  
  func setPhotoCellWith(photo: Photo) {
    authorLabel.text = photo.author
    tagsLabel.text = photo.tags
    if let url = photo.mediaURL {
      photoImageview.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
    }
  }
  
  private func configureAll() {
    configureCell()
  }
  
  private func configureCell() {
    self.contentView.backgroundColor = .white
    self.contentView.layer.cornerRadius = 10
    self.contentView.layer.masksToBounds = true
    
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOpacity = 0.3
    self.layer.shadowOffset = CGSize(width: 0, height: 0)
    self.layer.shadowRadius = self.contentView.layer.cornerRadius
  }
  
  // MARK: - Showing/Hiding Logic
  
  func hide(in collectionView: UICollectionView, frameOfSelectedCell: CGRect) {
    initialFrame = self.frame
    
    let currentY = self.frame.origin.y
    let newY: CGFloat
    
    if currentY < frameOfSelectedCell.origin.y {
      let offset = frameOfSelectedCell.origin.y - currentY
      newY = collectionView.contentOffset.y - offset
    } else {
      let offset = currentY - frameOfSelectedCell.maxY
      newY = collectionView.contentOffset.y + collectionView.frame.height + offset
    }
    
    self.frame.origin.y = newY
    
    layoutIfNeeded()
  }
  
  func show() {
    self.frame = initialFrame ?? self.frame
    
    initialFrame = nil
    
    layoutIfNeeded()
  }
  
  // MARK: - Expanding/Collapsing Logic
  
  func expand(in collectionView: UICollectionView) {
    initialFrame = self.frame
    initialCornerRadius = self.contentView.layer.cornerRadius
    
    self.contentView.layer.cornerRadius = 0
    self.frame = CGRect(x: 0, y: collectionView.contentOffset.y, width: collectionView.frame.width, height: collectionView.frame.height)
    
    layoutIfNeeded()
  }
  
  func collapse() {
    self.contentView.layer.cornerRadius = initialCornerRadius ?? self.contentView.layer.cornerRadius
    self.frame = initialFrame ?? self.frame
    
    initialFrame = nil
    initialCornerRadius = nil
    
    layoutIfNeeded()
  }
  
}
