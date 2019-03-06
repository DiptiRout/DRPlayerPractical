//
//  NewFeedCell.swift
//  NewsFeedsPractical
//
//  Created by Dipti on 03/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit
import Kingfisher

class NewFeedCell: UICollectionViewCell {
  
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var captionLabel: UILabel!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
    
    var videoData: VideoDetailsModel? {
    didSet {
      if let data = videoData {
        captionLabel.text = data.title
        descriptionLabel.text = data.description
        if let thumb = data.thumb {
            imageView.kf.setImage(with: URL(string: thumb))
        }
      }
    }
  }
}
