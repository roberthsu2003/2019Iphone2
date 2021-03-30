//
//  DetailViewController.swift
//  lesson3_1
//
//  Created by 徐國堂 on 2021/3/25.
//

import UIKit
struct YoubikeData:Codable{
    struct Site:Codable {
        let ar:String
        let bemp:Int
        let lat:Double
        let lng:Double
        let mday:String
        let sbi:Int
        let sna:String
        let tot:Int
    }
    let data:[Site]
}

class DetailViewController: UITableViewController {
    var regionName:String!
    lazy var urlSession:URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.allowsExpensiveNetworkAccess = true
        let mySession = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        return mySession
    }()
    
    var sites = [YoubikeData.Site]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var urlComponets = URLComponents()
        urlComponets.scheme = "https"
        urlComponets.host = "flask-robert.herokuapp.com"
        urlComponets.path = "/youbike/" + regionName
        guard let url = urlComponets.url else{
            print("url編碼錯誤")
            return
        }
        print(url.absoluteString)
        
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        
    }
        
        
        

    // MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}

extension DetailViewController:URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession,
       downloadTask: URLSessionDownloadTask,
       didFinishDownloadingTo location: URL){
        guard let data = try? Data(contentsOf: location) else{
            print("轉換資料有問題")
            return
        }
        //print(String(data: data, encoding: .utf8)!)
        let jsonDecoder = JSONDecoder()
        guard let youbikeData = try? jsonDecoder.decode(YoubikeData.self, from: data) else{
            print("json無法解析")
            return
        }
        
        sites = youbikeData.data
        print(sites)
    }
}
   

    
    

    


