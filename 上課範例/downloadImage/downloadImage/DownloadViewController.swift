//
//  DownloadViewController.swift
//  downloadImage
//
//  Created by 徐國堂 on 2021/4/6.
//

import UIKit

class DownloadViewController: UIViewController {
    @IBOutlet var cityImageView:UIImageView!
    @IBOutlet var progressView:UIProgressView!
    let pathString = "https://flask-robert.herokuapp.com/static/cityImage/Akihabara.jpg"
    lazy var session:URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = true
        config.allowsExpensiveNetworkAccess = true
        let session = URLSession(configuration: config)
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func doElaborateHTTP(_ sender:UIButton){
        cityImageView.image = nil
        let url = URL(string: pathString)!
        let task = session.downloadTask(with: url) { (url:URL?, response:URLResponse?, error:Error?) in
            guard let url = url, let response = response, error == nil else{
                print("下載出現問題")
                return
            }
            
            print("下載完成")
            
            let status = (response as! HTTPURLResponse).statusCode
            if status != 200{
                print("下載失敗")
                return
            }
            
            if let data = try? Data(contentsOf: url){
                let cityImage = UIImage(data: data)
                DispatchQueue.main.async {
                    self.cityImageView.image = cityImage
                }
            }
            
        }
        task.resume()
    }

}
