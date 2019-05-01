//
//  ViewController.swift
//  firestore
//
//  Created by Robert on 2019/5/1.
//  Copyright © 2019 Robert. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {
    let firestore = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let presidentsCols = firestore.collection("presidents")
        presidentsCols.addSnapshotListener { (presidentsSnapshot:QuerySnapshot?, error:Error?) in
            if error != nil {
                print("error:\(error!.localizedDescription)");
                return;
            }
            
            if presidentsSnapshot!.isEmpty{
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "上傳資料", style: .plain, target: self, action: #selector(self.importData(_:)))
            }else{
                print("集合已經有資料");
            }
            
            
        }
    }

    @objc func importData(_ sender:UIBarButtonItem){
        print("上傳資料");
    }
}

