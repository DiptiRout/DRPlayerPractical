//
//  VideoDetailsCell.swift
//  VideoPlayerPractical
//
//  Created by Muvi on 03/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit

protocol CellSubclassDelegate: class {
    func playButtonTapped(cell: VideoDetailsCell)
}

class VideoDetailsCell: UITableViewCell {

    @IBOutlet fileprivate weak var bannerImageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var playButton: UIButton!
    
    weak var delegate: CellSubclassDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }

    var videoData: VideoDetailsModel? {
        didSet {
            if let data = videoData {
                titleLabel.text = data.title
                descriptionLabel.text = data.description
                if let thumb = data.thumb {
                    bannerImageView.kf.setImage(with: URL(string: thumb))
                }
            }
        }
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        self.delegate?.playButtonTapped(cell: self)
    }
}
