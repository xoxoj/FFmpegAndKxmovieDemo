//
//  ViewController.swift
//  FFmpegAndKxmovieDemo
//
//  Created by 马超 on 16/4/12.
//  Copyright © 2016年 qq 714080794. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var tableView: UITableView!
    
    var dataController: FFHomeDataController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.dataController = FFHomeDataController()
        
        self.setupTableView()
       
        // init datas
        self.fetchDatas()
        
        let fps = MCFPSLabel()
        fps.size = CGSizeMake(60, 30)
        fps.bottom = self.view.bottom
        self.view.addSubview(fps)

    }

    func fetchDatas() {
        
        let url = "http://d.api.budejie.com/topic/list/chuanyue/41/baisi_xiaohao-iphone-4.1/0-50.json?appname=baisi_xiaohao&asid=8C66099E-C265-4990-B8EE-8A002E4D84D0&client=iphone&device=iPhone%204S&from=ios&jbk=0&mac=&market=&openudid=f5ff7b5919088e7d120443fcb85a4bc259cc515b&udid=&ver="

        self.dataController.fetchHomeListWithUrl(url) { (response, errorMsg) in
            print(response)
            self.tableView.reloadData()
        }
    }

    func setupTableView() {
        
        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.tableView.top = 20
        self.view.addSubview(self.tableView)
        
//        // 这个便利注册，有点问题，待优化
//        for item in self.dataController.list {
//            
//            self.tableView.registerClass(item.cellClass, forCellReuseIdentifier: item.reuseIdentifier)
//        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataController.list.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = self.dataController.list[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(item.reuseIdentifier)
        
        if cell == nil {

            cell = (item.cellClass as! UITableViewCell.Type).init(style: UITableViewCellStyle.Default, reuseIdentifier: item.reuseIdentifier)
        }
        item.updateCell(cell!)
        return cell!
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var paramers: Dictionary<String,AnyObject> = Dictionary()
        
        let video = self.dataController.list[indexPath.row]
        
        var url :String?
        
        if video.cellClass == FFHomeCell.self {
            
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! FFHomeCell
            
            let viewModel = cell.viewModel!
            
            url = viewModel.videoItem.video?.video?.first
            
        }


        if url == nil {
            
            return
        }

        let path: String = url!
        
        let pathUrl = NSURL(string: path)
   
        if let _ = pathUrl {
    
            if pathUrl!.pathExtension == "wmv" {
                
                paramers[KxMovieParameterMinBufferedDuration] = (5.0)
            }
            
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone {
                
                paramers[KxMovieParameterDisableDeinterlacing] = (true)
            }
            print(pathUrl!.scheme)
            let playVc = KxMovieViewController.movieViewControllerWithContentPath(path, parameters: paramers) as! UIViewController
            
            self.presentViewController(playVc, animated: true, completion: nil)
        }

    }
}
