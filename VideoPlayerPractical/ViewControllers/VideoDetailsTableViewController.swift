//
//  VideoDetailsTableViewController.swift
//  VideoPlayerPractical
//
//  Created by Muvi on 03/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit
import AVKit

class VideoDetailsTableViewController: UITableViewController {

    public var videoDataArray = [VideoDetailsModel]()
    var videoTrack = [String]()
    
    lazy var drPlayer: DRPlayerView = {
        let drPlayer = DRPlayerView()
        return drPlayer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let patternImage = UIImage(named: "Pattern") {
            tableView.backgroundColor = UIColor(patternImage: patternImage)
        }
        tableView.estimatedRowHeight = 287
        tableView.rowHeight = UITableView.automaticDimension
        
        for item in videoDataArray {
            videoTrack.append(item.url ?? "")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        drPlayer.removePlayerFromCell()
        super.viewWillDisappear(false)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return videoDataArray.count - 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoDetailsCell", for: indexPath) as! VideoDetailsCell
            cell.videoData = videoDataArray[0]
            cell.delegate = self
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RelatedContentCell", for: indexPath) as! RelatedContentCell
            cell.videoData = videoDataArray[indexPath.row + 1]
            return cell
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }
        else {
            return UITableView.automaticDimension
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }
        else {
            return "Related Contents"
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        else {
            return 50
        }
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        drPlayer.removePlayerFromCell()
    }
}

extension VideoDetailsTableViewController: CellSubclassDelegate {
    func playButtonTapped(cell: VideoDetailsCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        drPlayer.frame = cell.contentView.bounds
        cell.contentView.addSubview(drPlayer)
        drPlayer.attachPlayerToCell(urlString: videoDataArray[indexPath.row].url ?? "", videoTrack: videoTrack, videoID: videoDataArray[indexPath.row].id ?? "")
    }
}

