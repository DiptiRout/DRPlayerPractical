//
//  VideoDetailsModel.swift
//  NewsFeedsPractical
//
//  Created by Dipti on 03/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import Foundation
import UIKit

struct VideoDetailsModel: Codable {
    var description: String?
    var title: String?
    var thumb: String?
    var url: String?
    var id: String?
    
    init(description: String, title: String, thumb: String, url: String, id: String) {
        self.description = description
        self.title = title
        self.thumb = thumb
        self.url = url
        self.id = id
    }
}
