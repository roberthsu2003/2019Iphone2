//
//  ViewController.swift
//  login
//
//  Created by Robert on 2019/9/29.
//  Copyright © 2019 ios1. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet var loginBtn:UIButton!;
    var databaseRef:DatabaseReference = Database.database().reference(withPath: "DHT")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser != nil{
           //有登入
            loginBtn.setTitle("登出", for: .normal);
        }else{
            //沒有登入
            loginBtn.setTitle("登入", for: .normal);
        }
    }
    
    @IBAction func userClickTopButton(_ topButton:UIButton){
       
    }

    @IBAction func userClickBottomBtn(_ sender:UIButton){
        let celsiusRef = databaseRef.child("Celsius")
        celsiusRef.setValue("testValue"){
            (error:Error?, dataRef:DatabaseReference) in
            var message:String = "";
            if let error = error{
                print("user=\(error.localizedDescription)");
                message = error.localizedDescription
            }else{
                message = "資料讀取正常"
            }
            
            let alertController = UIAlertController(title: "請取狀態", message: message, preferredStyle: .alert);
            let alertAction = UIAlertAction(title: "ok", style: .default, handler: nil);
            alertController.addAction(alertAction);
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

