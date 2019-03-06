//
//  Post.swift
//  VideoPlayerPractical
//
//  Created by Muvi on 05/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import Foundation

struct Post {
    
    let postId: String
    let videoURL: String
    let playTime: Double
    
    init?(postId: String, dict: [String: Any]) {
        self.postId = postId
        
        guard let videoURL = dict["videoURL"] as? String,
            let playTime = dict["playTime"] as? Double
            else { return nil }
        
        self.videoURL = videoURL
        self.playTime = playTime        
    }
    
}
