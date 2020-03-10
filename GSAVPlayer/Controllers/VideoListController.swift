//
//  FullScreenPlayerController.swift
//  GSAVPlayer
//
//  Created by Gati Shah on 12/02/20.
//  Copyright © 2020 iGatiTech. All rights reserved.
//

import UIKit
import AVKit
import SwiftyJSON

class VideoListController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var tableViewVideos : UITableView!
    
    //MARK:- Variables
    var videoBase : VideoBase?
    var arrayVideos = [Videos]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let videoURL = URL(string: videoUrl)
//        let player = AVPlayer(url: videoURL!)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        self.present(playerViewController, animated: true) {
//            playerViewController.player!.play()
//        }
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTmpVideoDataFromJSONFile()
    }
    
    //MARK:- Custom Methods
    
    func setUpView() {
        tableViewVideos.register(UINib(nibName: CellIdentifier.VideoTableCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.VideoTableCell)
    }
    
    //MARK:- API Call
    func getTmpVideoDataFromJSONFile() {
        guard let path = Bundle.main.path(forResource: StringConstant.videoData, ofType: StringConstant.json) else {
            return }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let responseJson = try JSON(data: data)
            if let dictResponse = responseJson.dictionaryObject as NSDictionary? {
                self.videoBase = VideoBase(dictionary: dictResponse)
                arrayVideos = self.videoBase?.videos ?? [Videos]()
                self.tableViewVideos.reloadData()
            }
        } catch {
            print(error)
        }
    }
}

//MARK:- TableView Datasource & Delegate Methods
extension VideoListController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayVideos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.VideoTableCell) as! VideoTableCell
        cell.videoData = arrayVideos[indexPath.row]
        return cell
    }
    
}
