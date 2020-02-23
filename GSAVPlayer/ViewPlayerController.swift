//
//  ViewPlayerController.swift
//  GSAVPlayer
//
//  Created by Gati Shah on 12/02/20.
//  Copyright © 2020 iGatiTech. All rights reserved.
//

import UIKit
import AVKit

class ViewPlayerController: UIViewController {
    //MARK:- IBOutlet
    @IBOutlet weak var viewPlayer : UIView!
    @IBOutlet weak var viewPlayerControls : UIView!
    @IBOutlet weak var buttonChoose : UIButton!
    @IBOutlet weak var buttonPlayPause : UIButton!
    @IBOutlet weak var buttonReplay : UIButton!
    @IBOutlet weak var buttonForward : UIButton!
    @IBOutlet weak var buttonBackward : UIButton!
    @IBOutlet weak var buttonMuteUnMute : UIButton!
    @IBOutlet weak var sliderDuration : UISlider!
    
    //MARK:- Variables
    var player : AVPlayer?
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    //MARK:- IBActions
    @IBAction func loadVideoFromURLClicked(_ sender : Any) {
        playVideoWithRemoteORLocalURL(urlString: videoUrl)
    }
    
    @IBAction func chooseVideoFromGalleryClicked(_ sender : Any) {
        chooseOrCapture()
    }
    
    @IBAction func loadFromBundleClicked(_ sender : Any) {
        playVideoFromBundle()
    }
    
    @IBAction func buttonPlayPauseClicked(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            player?.play()
        } else {
            player?.pause()
        }
    }
    
    @IBAction func buttonReplayClicked(_ sender : UIButton) {
        self.buttonReplay.isHidden = true
        self.buttonPlayPause.isHidden = false
        self.buttonPlayPause.isSelected = true
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    @IBAction func buttonForwardClicked(_ sender : UIButton) {
        forwardVideo(by: 10)
    }
    
    @IBAction func buttonBackwardClicked(_ sender : UIButton) {
        rewindVideo(by: 10)
    }
    
    @IBAction func buttonMuteUnMuteClicked(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            player?.isMuted = true
        } else {
            player?.isMuted = false
        }
    }
    
    @IBAction func sliderDurationValueChanged(_ sender : UISlider) {
        let seconds = sender.value * Float(CMTimeGetSeconds(player?.currentItem?.duration ?? CMTime()))
        player?.seek(to: CMTime(value: CMTimeValue(seconds * 1000), timescale: 1000))
    }
    
    //MARK:- Custom Methods
    func setUpView() {
        buttonChoose.titleLabel?.textAlignment = .center
        viewPlayerControls.isHidden = true
        viewPlayer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureOnView(_:))))
        viewPlayerControls.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureOnView(_:))))
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = [StringConstant.publicMovie]
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func chooseOrCapture() {
        let optionMenuController = UIAlertController(title: nil, message: StringConstant.chooseOption, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: StringConstant.camera, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                //Show message, camera not available
                self.showAlert(withTitle: StringConstant.error, withMessage: StringConstant.noCamera)
                return
            }
            self.selectImageFrom(.camera)
        })
        let galleryAction = UIAlertAction(title: StringConstant.gallery, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.selectImageFrom(.photoLibrary)
        })
        
        let cancelAction = UIAlertAction(title: StringConstant.cancel, style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })

        // Add UIAlertAction in UIAlertController
        optionMenuController.addAction(cameraAction)
        optionMenuController.addAction(galleryAction)
        optionMenuController.addAction(cancelAction)
        
        // Present UIAlertController with Action Sheet
        self.present(optionMenuController, animated: true, completion: nil)
    }
    
    private func playVideoFromBundle() {
        guard let path = Bundle.main.path(forResource: "ForBiggerBlazes", ofType:"mp4") else {
            print("ForBiggerBlazes.m4v not found")
            return
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = viewPlayer.bounds
        playerLayer.videoGravity = .resizeAspectFill
        viewPlayer.layer.addSublayer(playerLayer)
        buttonPlayPauseClicked(buttonPlayPause)
        addPeriodicObserver()
    }
    
    func playVideoWithRemoteORLocalURL(urlString : String) {
        let videoURL = URL(string: urlString)
        player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = viewPlayer.bounds
        playerLayer.videoGravity = .resizeAspectFill
        viewPlayer.layer.addSublayer(playerLayer)
        buttonPlayPauseClicked(buttonPlayPause)
        addPeriodicObserver()
    }
    
    func forwardVideo(by seconds: Float64) {
        if let currentTime = player?.currentTime(), let duration = player?.currentItem?.duration {
            var newTime = CMTimeGetSeconds(currentTime) + seconds
            if newTime >= CMTimeGetSeconds(duration) {
                newTime = CMTimeGetSeconds(duration)
            }
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    func rewindVideo(by seconds: Float64) {
        if let currentTime = player?.currentTime() {
            var newTime = CMTimeGetSeconds(currentTime) - seconds
            if newTime <= 0 {
                newTime = 0
            }
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    func addPeriodicObserver() {
        player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 2), queue: DispatchQueue.main) {[weak self] (progressTime) in
//            self?.player?.currentItem?.loadedTimeRanges
            if let duration = self?.player?.currentItem?.duration {
                
                let durationSeconds = CMTimeGetSeconds(duration)
                let seconds = CMTimeGetSeconds(progressTime)
                let progress = Float(seconds/durationSeconds)
                
                DispatchQueue.main.async {
                    self?.sliderDuration.value = progress
                    if progress >= 1.0 {
                        self?.sliderDuration.value = 0.0
                        self?.buttonReplay.isHidden = false
                        self?.buttonPlayPause.isHidden = true
                    }
                }
            }
        }
    }
    
    func showPlayerControlView(bool : Bool) {
        if bool == true {
            self.viewPlayerControls.alpha = 0
            self.viewPlayerControls.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.viewPlayerControls.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.viewPlayerControls.alpha = 0
            }) { (finished) in
                self.viewPlayerControls.isHidden = finished
            }
        }
    }
    
    //MARK:- Selector Methods
    @objc func tapGestureOnView(_ tapGesture : UITapGestureRecognizer) {
        let viewTag = tapGesture.view?.tag
        switch viewTag {
        case 1:
            showPlayerControlView(bool: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [unowned self] in
                self.showPlayerControlView(bool: false)
            }
        case 2:
            showPlayerControlView(bool: false)
        default:
            print("Default")
        }
    }
}

extension ViewPlayerController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let videoURL = info[.mediaURL]
        print(videoURL!)
        playVideoWithRemoteORLocalURL(urlString: (videoURL as? URL)?.absoluteString ?? "")
        self.dismiss(animated: true, completion: nil)
    }
}
