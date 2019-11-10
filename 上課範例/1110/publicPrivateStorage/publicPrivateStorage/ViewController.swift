//
//  ViewController.swift
//  publicPrivateStorage
//
//  Created by 徐國堂 on 2019/11/10.
//  Copyright © 2019 徐國堂. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UITableViewController {
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard userAuthentication() == true,checkCityplistInDocuments() == true else {
            print("出錯");
            return
           
        }
        parsePlistInDocument()
            
        
    }
    
   
    
    func userAuthentication() -> Bool{
        var boolState = true;
        if Auth.auth().currentUser == nil {
                   //尚未認證
            
            boolState = false;
                   Auth.auth().signInAnonymously { (result:AuthDataResult?, error:Error?) in
                       guard result != nil, error == nil else{
                           print("anoonymously失敗");
                           return
                       }
                        if self.checkCityplistInDocuments(){
                            self.parsePlistInDocument()
                        }
                    
                   }
                 
        }else{
        //已經認證
            boolState = true;
        }
        
       return boolState
    }
    
    func checkCityplistInDocuments() -> Bool{
        var boolState:Bool = true;
        let fileManager = FileManager.default;
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else{
            print("沒有取得documentsURL");
            return false;
        }
        
        let plistURL = documentsURL.appendingPathComponent("citylist.plist")
        if !fileManager.fileExists(atPath: plistURL.path){
            let plistInStorageRef = storage.reference(withPath: "h2/citylist.plist")
            plistInStorageRef.getData(maxSize: 1*1024*1024) { (data:Data?, error:Error?) in
                guard let plistData = data, error == nil else {
                    print("下載plist檔案有錯");
                    boolState = false;
                    return
                }
                do{
                   try plistData.write(to: plistURL)
                }catch let error as NSError{
                    print("寫入plist有錯:\(error.localizedDescription)")
                    boolState = false;
                    return
                }
                
                let imagesDirectoryURL = documentsURL.appendingPathComponent("images", isDirectory: true)
                do{
                try fileManager.createDirectory(at: imagesDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                   
                    
                }catch let error as NSError{
                    print("建立images Directory有問題:\(error.localizedDescription)");
                    boolState = false;
                    return;
                }
                
                
                
            }
            
        }
        
        return boolState;
    }
    
    
    func parsePlistInDocument(){
        print("parsePlistInDocument")
    }


}

