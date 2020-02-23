//
//  FullScreenPlayerController.swift
//  GSAVPlayer
//
//  Created by Gati Shah on 12/02/20.
//  Copyright © 2020 iGatiTech. All rights reserved.
//

import UIKit
import AVKit

class FullScreenPlayerController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //        let playerController = AVPlayerViewController()
        //        playerController.player = player
        //        present(playerController, animated: true) {
        //            player.play()
        //        }
        // Do any additional setup after loading the view.
        
        let videoURL = URL(string: videoUrl)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
