//
//  ViewController.swift
//  GSAVPlayer
//
//  Created by Gati Shah on 12/02/20.
//  Copyright © 2020 iGatiTech. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    @IBOutlet weak var buttonViewCustom : UIButton!
    @IBOutlet weak var buttonFullScreenDefault : UIButton!
    @IBOutlet weak var buttonViewDefault : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpView()
    }

    func setUpView() {
        self.title = StringConstant.avPlayer
        buttonFullScreenDefault.titleLabel?.textAlignment = .center
    }
    
    //MARK:- IBActions
    @IBAction func playVideoInViewClicked(_ sender : Any) {
        guard let vcViewPlayer = GetViewController(StoryBoard: .Main, Identifier: .ViewPlayer) else {
            return
        }
        self.navigationController?.pushViewController(vcViewPlayer, animated: true)
    }
    
    @IBAction func playVideoInFullScreenClicked(_ sender : Any) {
        let videoURL = URL(string: videoUrl)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    @IBAction func playVideoInViewWithDefaultControlsClicked(_ sender : Any) {
        guard let vcDefaultControls = GetViewController(StoryBoard: .Main, Identifier: .DefaultControls) else {
            return
        }
        self.navigationController?.pushViewController(vcDefaultControls, animated: true)
    }
    
    @IBAction func videoListButtonClicked(_ sender : UIButton) {
//        guard let vcVideoList = GetViewController(StoryBoard: .Main, Identifier: .VideoList) else {
//            return
//        }
//        self.navigationController?.pushViewController(vcVideoList, animated: true)
    }

}

