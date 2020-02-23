//
//  DefaultControlsController.swift
//  GSAVPlayer
//
//  Created by Gati Shah on 22/02/20.
//  Copyright © 2020 iGatiTech. All rights reserved.
//

import UIKit
import AVKit

class DefaultControlsController: UIViewController {
    //MARK:- IBOutlet
    @IBOutlet weak var viewPlayer : UIView!
    @IBOutlet weak var buttonChoose : UIButton!
    
    //MARK:- Variables
    var avPlayer : AVPlayer?
    var playerController = AVPlayerViewController()
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    //MARK:- Custom Methods
    func setUpView() {
        buttonChoose.titleLabel?.textAlignment = .center
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
        avPlayer = AVPlayer(url: URL(fileURLWithPath: path))
        playerController.player = avPlayer
        playerController.view.frame = viewPlayer.bounds
        self.addChild(playerController)
        viewPlayer.addSubview(playerController.view)
        playerController.didMove(toParent: self)
    }
    
    func playVideoWithRemoteORLocalURL(urlString : String) {
        let videoURL = URL(string: urlString)
        avPlayer = AVPlayer(url: videoURL!)
        playerController.player = avPlayer
        playerController.view.frame = viewPlayer.bounds
        self.addChild(playerController)
        viewPlayer.addSubview(playerController.view)
        playerController.didMove(toParent: self)
    }

}

extension DefaultControlsController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let videoURL = info[.mediaURL]
        print(videoURL!)
        playVideoWithRemoteORLocalURL(urlString: (videoURL as? URL)?.absoluteString ?? "")
        self.dismiss(animated: true, completion: nil)
    }
}
