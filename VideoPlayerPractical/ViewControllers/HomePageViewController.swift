//
//  HomePageViewController.swift
//  NewsFeedsPractical
//
//  Created by Dipti on 03/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class HomePageViewController: UICollectionViewController {
    
    let controller = APIController()
    var videoData = [VideoDetailsModel]()
    var activityIndicatorView: NVActivityIndicatorView!


    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        collectionView?.backgroundColor = .clear
        collectionView?.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80), type: .ballClipRotate, color: #colorLiteral(red: 0.04787462205, green: 0.3609589934, blue: 0.1635327637, alpha: 1), padding: 5)
        activityIndicatorView.center = view.center
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        callVideoApi()
    }
   
    func callVideoApi() {
        controller.getTopHeadLines(countryCode: "us", completion: { (result, newsData) -> () in
            DispatchQueue.main.async {
                if result {
                    self.videoData = newsData
                    self.collectionView.reloadData()
                    self.activityIndicatorView.stopAnimating()
                }
                else {
                    print(result)
                }
            }
        })
    }
}

extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewFeedCell", for: indexPath as IndexPath) as! NewFeedCell
        cell.videoData = videoData[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize: CGFloat = 220
        let itemWidth = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10))
        return CGSize(width: itemWidth, height: itemSize)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsPageVC = storyboard.instantiateViewController(withIdentifier: "VideoDetailsTableViewController") as! VideoDetailsTableViewController
        let selectedElement = videoData[indexPath.item]
        var videoArray = videoData
        videoArray.remove(at: indexPath.item)
        videoArray.insert(selectedElement, at: 0)
        detailsPageVC.videoDataArray = videoArray
        navigationController?.pushViewController(detailsPageVC, animated: false)
    }
}
