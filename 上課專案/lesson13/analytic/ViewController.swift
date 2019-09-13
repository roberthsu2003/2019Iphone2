//
//  ViewController.swift
//  analytic
//
//  Created by Robert on 2019/5/20.
//  Copyright © 2019 ios1. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title="FirstViewContorller"
        recordScreenView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //自訂的 custom_event
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-\(title!)" as NSObject,
            AnalyticsParameterItemName: title! as NSObject,
            AnalyticsParameterContentType:"cont" as NSObject,
            ])
    }
    
    func recordScreenView(){
        guard let screenName = title else{
            return
        }
        let screenClass = classForCoder.description()
        print("screenName:\(screenName)")
        print("screenClass:\(screenClass)");
        Analytics.setScreenName(screenName, screenClass: screenClass);
        
    }


}

