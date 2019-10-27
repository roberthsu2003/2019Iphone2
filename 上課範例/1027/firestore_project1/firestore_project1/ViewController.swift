//
//  ViewController.swift
//  firestore_project1
//
//  Created by 徐國堂 on 2019/10/20.
//  Copyright © 2019 徐國堂. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {
    //default value當有多行時,請使用closure執行
    //使用closure的執行，必需明確宣告資料類型
    //在closure內要傳出資料
    
    lazy var firestore = Firestore.firestore()
    
    var queryDocuments:[QueryDocumentSnapshot] = [];
    
    lazy var presidents:[[String:String]] = {
        let path = Bundle.main.path(forResource: "PresidentList", ofType: "plist")
        guard let rootDictionary = NSDictionary(contentsOfFile: path!) as? [String:Any] else{
            print("解析資料有問題")
            return [[String:String]]()
        }
        
        let presidents = rootDictionary["presidents"] as! [[String:String]]
        return presidents;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("count:\(presidents)")
        firestore.collection("presidents").order(by: "time", descending: true).addSnapshotListener { (snapshot:QuerySnapshot?, error:Error?) in
            guard error == nil, snapshot != nil else{
                print("error:\(error!.localizedDescription)")
                return
            }
            
            if snapshot!.isEmpty{
                //出現匯入資料的按鈕
                self.navigationItem.rightBarButtonItems = [
                    UIBarButtonItem(title: "匯入資料", style: .plain, target: self, action: #selector(self.importData(_:)))
                    
                ]
            }else{
                //取出資料
                print("取出資料")
                self.queryDocuments = snapshot!.documents
                self.tableView.reloadData();
            }
        }
    }
    
    @objc func importData(_ sender:UIBarButtonItem){
        let batch = firestore.batch();
        for president in presidents{
            let documentRef = firestore.collection("presidents").document()
            var newPresident:[String:Any] = president
            newPresident["time"] = Date().timeIntervalSince1970
            batch.setData(newPresident, forDocument: documentRef)
        }
        
        batch.commit { (error:Error?) in
            guard error == nil else{
                print("error:\(error!.localizedDescription)");
                return
            }
            print("資料匯入完成");
            self.navigationItem.rightBarButtonItems = [
                UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addData(_:)))
            ];
            self.firestore.collection("presidents").order(by: "time", descending: true).addSnapshotListener(includeMetadataChanges: false) { (snapshot:QuerySnapshot?, error:Error?) in
                guard error == nil else{
                    print("error:\(error!.localizedDescription)");
                    return;
                }
                self.queryDocuments = snapshot!.documents
                self.tableView.reloadData();
                print("資料匯入完成後，取出資料");
                
            }
        }
    }
    
    @objc func addData(_ sender:UIBarButtonItem){
        print("add");
    }


}

extension ViewController{
    //UITableViewDataSource
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return queryDocuments.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let queryDocumentSnapshot = queryDocuments[indexPath.row]
        let presidentDict = queryDocumentSnapshot.data()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        cell.textLabel?.text = presidentDict["name"] as? String;
        cell.detailTextLabel?.text = presidentDict["url"] as? String
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            let queryDocumentSnapshot = queryDocuments[indexPath.row]
            let documentId = queryDocumentSnapshot.documentID;
            firestore.collection("presidents").document(documentId).delete { (error:Error?) in
                guard error == nil else{
                    print("刪除失敗");
                    return;
                }
                print("刪除成功");
            }
        }
    }
}

