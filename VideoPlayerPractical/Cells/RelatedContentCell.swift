//
//  RelatedContentCell.swift
//  VideoPlayerPractical
//
//  Created by Muvi on 03/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit

class RelatedContentCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var thumbImageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }

    var videoData: VideoDetailsModel? {
        didSet {
            if let data = videoData {
                titleLabel.text = data.title
                descriptionLabel.text = data.description
                if let thumb = data.thumb {
                    thumbImageView.kf.setImage(with: URL(string: thumb))
                }
            }
        }
    }

}
