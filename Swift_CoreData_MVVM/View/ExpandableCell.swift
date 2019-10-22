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
    if let imageData = photo.imageData {
      photoImageview.image = UIImage(data: imageData)
    } else {
      photoImageview.image = UIImage(named: "placeholder")
    }
  }
  
  private func configureAll() {
    configureCell()
  }
  
  private func configureCell() {
    contentView.backgroundColor = .white
    contentView.layer.cornerRadius = 10
    contentView.layer.masksToBounds = true
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.3
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowRadius = contentView.layer.cornerRadius
  }
  
  // MARK: - Showing/Hiding Logic
  
  func hide(in collectionView: UICollectionView, frameOfSelectedCell: CGRect) {
    initialFrame = frame
    
    let currentY = frame.origin.y
    let newY: CGFloat
    
    if currentY < frameOfSelectedCell.origin.y {
      let offset = frameOfSelectedCell.origin.y - currentY
      newY = collectionView.contentOffset.y - offset
    } else {
      let offset = currentY - frameOfSelectedCell.maxY
      newY = collectionView.contentOffset.y + collectionView.frame.height + offset
    }
    frame.origin.y = newY
    layoutIfNeeded()
  }
  
  func show() {
    frame = initialFrame ?? frame
    initialFrame = nil
    layoutIfNeeded()
  }
  
  // MARK: - Expanding/Collapsing Logic
  
  func expand(in collectionView: UICollectionView) {
    initialFrame = frame
    initialCornerRadius = contentView.layer.cornerRadius
    contentView.layer.cornerRadius = 0
    frame = CGRect(x: 0, y: collectionView.contentOffset.y, width: collectionView.frame.width, height: collectionView.frame.height)
    layoutIfNeeded()
  }
  
  func collapse() {
    contentView.layer.cornerRadius = initialCornerRadius ?? contentView.layer.cornerRadius
    frame = initialFrame ?? frame
    initialFrame = nil
    initialCornerRadius = nil
    layoutIfNeeded()
  }
}
