//
//  DRPlayerView.swift
//  VideoPlayerPractical
//
//  Created by Dipti on 04/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import Foundation
import UIKit
import AVKit

public class DRPlayerView: UIView {
    
    var asset: AVAsset!
    var playerItem: AVPlayerItem!
    
    // Key-value observing context
    private var playerItemContext = 0
    var isVideoPlaying = false
    var playerItems = [AVPlayerItem]()
    var currentTrack = 0
    var timeObserverToken: Any?
    var currentTime = Double()
    var posts = [Post]()
    var videoID = ""
    
    let requiredAssetKeys = [
        "playable",
        "hasProtectedContent"
    ]
    
    lazy var avPlayer : AVPlayer = {
        let player = AVPlayer()
        return player
    }()
    
    lazy var avPlayerLayer : AVPlayerLayer = {
        let layer = AVPlayerLayer(player: self.avPlayer)
        return layer
    }()
    
    // top view
    open var topView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        return view
    }()
    // bottom view
    open var bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        return view
    }()
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Pause", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(playPauseToggle), for: .touchUpInside)
        return button
    }()
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(">>", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(playNextVideo), for: .touchUpInside)
        return button
    }()
    lazy var previousButton: UIButton = {
        let button = UIButton()
        button.setTitle("<<", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(playPreviousVideo), for: .touchUpInside)
        return button
    }()
    fileprivate var backgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        return blurredEffectView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(self.bounds)
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        setBlurView()
    }
    
    
    func setBlurView() {
        backgroundView.frame = self.bounds
        self.addSubview(backgroundView)
    }
    func setBottomView() {
        backgroundView.contentView.addSubview(bottomView)
        let vRect = avPlayerLayer.videoRect
        bottomView.frame = CGRect(x: vRect.minX, y: vRect.maxY - 52, width: vRect.width, height: 52)
        bottomView.addSubview(playButton)
        playButton.anchor(nil, left: bottomView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        bottomView.addSubview(nextButton)
        nextButton.anchor(nil, left: nil, bottom: nil, right: bottomView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 50, heightConstant: 50)
        bottomView.addSubview(previousButton)
        previousButton.anchor(nil, left: nil, bottom: nil, right: nextButton.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 50, heightConstant: 50)
    }
    
    // MARK: - Selector Actions
    @objc func playPauseToggle(){
        if isVideoPlaying {
            avPlayer.pause()
            self.playButton.setTitle("Play", for: .normal)
        }
        else {
            avPlayer.play()
            self.playButton.setTitle("Pause", for: .normal)
        }
        isVideoPlaying = !isVideoPlaying
    }
    @objc func playNextVideo() {
        nextTrack()
    }
    @objc func playPreviousVideo() {
        previousTrack()
    }
    @objc func playerDidFinishPlaying(note: NSNotification){
        print("Video Finished")
        if currentTrack != playerItems.count-1 {
            nextTrack()
        }
    }
    
    // MARK: - AVPlayer handler methods
    func previousTrack() {
        if currentTrack - 1 < 0 {
            currentTrack = (playerItems.count - 1) < 0 ? 0 : (playerItems.count - 1)
        } else {
            currentTrack -= 1
        }
        nextButton.isHidden = false
        playTrack()
    }
    
    func nextTrack() {
        if currentTrack + 1 > playerItems.count {
            currentTrack = 0
        } else {
            currentTrack += 1;
        }
        previousButton.isHidden = false
        playTrack()
    }
    
    func playTrack() {
        if currentTrack == 0 {
            previousButton.isHidden = true
        }
        if currentTrack == playerItems.count - 1 {
            nextButton.isHidden = true
        }
        if playerItems.count > 0 {
            avPlayer.replaceCurrentItem(with: playerItems[currentTrack])
            self.avPlayerLayer.frame = self.frame
            self.backgroundView.contentView.layer.addSublayer(self.avPlayerLayer)
        }
    }
    
    func attachPlayerToCell(urlString: String, videoTrack: [String], videoID: String) {
        
        self.removePlayerFromCell()
        self.videoID = videoID
        var mainTrack = videoTrack.filter { $0 != urlString }
        mainTrack.insert(urlString, at: 0)
        
        for item in mainTrack {
            let url = URL(string: item)
            if url != nil {
                let asset = AVAsset(url: url!)
                let avItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: requiredAssetKeys)
                avItem.addObserver(self,
                                   forKeyPath: #keyPath(AVPlayerItem.status),
                                   options: [.old, .new],
                                   context: &playerItemContext)
                playerItems.append(avItem)
            }
        }
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
        playTrack()
    }
    
    public func removePlayerFromCell()
    {
        if (self.avPlayerLayer.superlayer != nil)
        {
            print(currentTime)
            let asset = self.avPlayer.currentItem?.asset
            if asset == nil {
                print("nil Asset")
            }
            if let urlAsset = asset as? AVURLAsset {
                print(urlAsset.url)
                let parameters = ["videoURL"    : "\(urlAsset.url)",
                    "playTime"    : currentTime] as [String : Any]
                
                DatabaseService.shared.postsReference.child("Video\(videoID)").setValue(parameters)
            }
            self.avPlayerLayer.removeFromSuperlayer()
            self.removeFromSuperview()
            self.avPlayer.pause()
            self.avPlayer.replaceCurrentItem(with: nil)
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over status value
            switch status {
            case .readyToPlay:
                setBottomView()
                seekToResumeWatch()
                addPeriodicTimeObserver()
            // Player item is ready to play.
            case .failed: break
            // Player item failed. See error.
            case .unknown: break
                // Player item is not yet ready.
            }
        }
    }
    
    func seekToResumeWatch() {
        
        DatabaseService.shared.postsReference.observe(.value, with: { (snapshot) in
            print(snapshot)
            if let postsSnapshot = PostsSnapshot(with: snapshot) {
                self.posts = postsSnapshot.posts
            }
            let asset = self.avPlayer.currentItem?.asset
            if asset == nil {
                print("nil Asset")
            }
            if let urlAsset = asset as? AVURLAsset {
                let seekTime = self.posts.filter {
                    $0.videoURL == "\(urlAsset.url)"
                    }.first?.playTime
                print(seekTime ?? 0.00)
                let myTime = CMTime(seconds: seekTime ?? 0.1, preferredTimescale: 60000)
                self.avPlayer.seek(to: myTime)
                self.avPlayer.play()
            }
        })
        
    }
    
    func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        
        timeObserverToken = avPlayer.addPeriodicTimeObserver(forInterval: time,
                                                           queue: .main) {
                                                            [weak self] time in
                                                            // update player transport UI
                                                            
                                                            print(time.seconds)
                                                            self?.currentTime = time.seconds
        }
    }
    
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            avPlayer.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }

    deinit {
        removePlayerFromCell()
        removePeriodicTimeObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
