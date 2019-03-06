//
//  APIController.swift
//  NewsFeedsPractical
//
//  Created by Dipti on 03/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import Foundation
import UIKit

class APIController: NSObject {
    
    let baseUrl = "https://interview-e18de.firebaseio.com/media.json?print=pretty"
// https://interview-e18de.firebaseio.com/media.json?print=pretty
    func getTopHeadLines(countryCode: String, completion: @escaping (_ result: Bool, _ newsData: [VideoDetailsModel])->()) {
        let url = URL(string: baseUrl)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let newsData = VideoDetailsModel(description: "", title: "", thumb: "", url: "", id: "")
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            guard let data = data else{
                return completion(false, [newsData])
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode([VideoDetailsModel].self, from: data)
                return completion(true, responseModel)

            } catch let error{
                print(error.localizedDescription)
                return completion(false, [newsData])
            }
        }).resume()
    }
    
}
