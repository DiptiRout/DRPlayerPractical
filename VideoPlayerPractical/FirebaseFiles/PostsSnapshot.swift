//
//  PostsSnapshot.swift
//  VideoPlayerPractical
//
//  Created by Muvi on 05/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct PostsSnapshot {
    
    let posts: [Post]
    
    init?(with snapshot: DataSnapshot) {
        var posts = [Post]()
        guard let snapDict = snapshot.value as? [String: [String: Any]] else { return nil }
        for snap in snapDict {
            guard let post = Post(postId: snap.key, dict: snap.value) else { continue }
            posts.append(post)
        }
        self.posts = posts
    }
}

