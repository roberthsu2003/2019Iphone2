//
//  DataSource.swift
//  CitysImage
//
//  Created by 徐國堂 on 2019/11/4.
//  Copyright © 2019 徐國堂. All rights reserved.
//

import Foundation
import Firebase

class DataSource{
    var firestore = Firestore.firestore()
    var createUpLoadButton:(() -> Void)!
    
    static var dataSource:DataSource = {
        print("執行");
        return DataSource();
    }()
    
    private init(){
        checkDataInFirestore()
    }
    
    func checkDataInFirestore(){
        firestore.collection("citys").addSnapshotListener { (snapshot:QuerySnapshot?, error:Error?) in
            guard error == nil else{
                print("error:\(error!.localizedDescription)");
                return
            }
            
            guard let snapshot = snapshot else{
                print("snapshot是nil");
                return
            }
            
            if snapshot.isEmpty{
                
                print("snapshot是empty");
                if self.createUpLoadButton != nil {
                    self.createUpLoadButton();
                }
                
            }
            
            
        }
    }
    
    func uploadDataToFireStore(){
        print("uploadDataToFireStore");
        guard let cityListPath = Bundle.main.path(forResource: "citylist", ofType: "plist") else{
            print("解析citylist路徑出錯");
            return
        }
        
        guard let cityList = NSArray(contentsOfFile: cityListPath) as? [[String:String]] else{
            print("解析citylist的陣列出錯");
            return
        }
        
        for cityItem in cityList{
            //開始上傳資料
            print(cityItem);
        }
    }
}
