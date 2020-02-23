//
//  Constant.swift
//  GSAVPlayer
//
//  Created by Gati Shah on 12/02/20.
//  Copyright © 2020 iGatiTech. All rights reserved.
//

import Foundation
import UIKit

let videoUrl = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"

enum ImageSource {
    case photoLibrary
    case camera
}

//MARK:- Storyboards
enum Storyboards : String {
    case Main = "Main"
}

enum ControllerIdentifier : String {
    case ViewPlayer = "ViewPlayerController"
    case DefaultControls = "DefaultControlsController"
    case FullScreenPlayer = "FullScreenPlayerController"
}

//MARK:- Get View Controller
func GetViewController(StoryBoard : Storyboards,Identifier : ControllerIdentifier) ->UIViewController?{
    
    return UIStoryboard(name: StoryBoard.rawValue, bundle: nil).instantiateViewController(withIdentifier: Identifier.rawValue)
}

