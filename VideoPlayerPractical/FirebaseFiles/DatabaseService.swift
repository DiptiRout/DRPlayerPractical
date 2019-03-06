//
//  DatabaseService.swift
//  VideoPlayerPractical
//
//  Created by Muvi on 05/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DatabaseService {
    
    static let shared = DatabaseService()
    private init() {}
    
    let postsReference = Database.database().reference().child("posts")
    let beersReference = Database.database().reference().child("videos")
    
}
