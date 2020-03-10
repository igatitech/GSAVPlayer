//
//  VideoTableCell.swift
//  GSAVPlayer
//
//  Created by Gati Shah on 23/02/20.
//  Copyright © 2020 iGatiTech. All rights reserved.
//

import UIKit
import AVKit

class VideoTableCell: UITableViewCell {
    //MARK:- IBoutlets
    @IBOutlet weak var viewPlayer : UIView!
    
    //MARK:- Variables
    var avPlayer : AVPlayer?
    var playerController = AVPlayerViewController()
    var videoData : Videos? {
        didSet {
            setUpData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Custom Methods
    func setUpData() {
        playVideoWithRemoteURL(urlString: videoData?.sources ?? "")
    }
    
    func playVideoWithRemoteURL(urlString : String) {
        let videoURL = URL(string: urlString)
        avPlayer = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame = viewPlayer.bounds
        playerLayer.videoGravity = .resizeAspectFill
        viewPlayer.layer.addSublayer(playerLayer)
        avPlayer?.play()
    }
    
}
