//
//  ViewController.swift
//  barCode1
//
//  Created by 徐國堂 on 2019/11/18.
//  Copyright © 2019 徐國堂. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet var phothImageView:UIImageView!
    @IBOutlet var messageOfBarCodeRecognizer:UITextView!
    lazy var vision = Vision.vision()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func selectImage(_ sender:UIBarButtonItem){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self;
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func barCodeScan(_ sender:UIButton){
        let formats = VisionBarcodeFormat.all
        //let formats = VisionBarcodeFormat(arrayLiteral: .code39,.qrCode)
        let barcodeOptions = VisionBarcodeDetectorOptions(formats: formats)
        let barcodeDetector = vision.barcodeDetector(options: barcodeOptions)
        guard let originalImage = phothImageView.image else{
            print("沒有選擇圖片");
            showMessage(message: "沒有選擇圖片")
            return
        }
        let visionImage = VisionImage(image: originalImage)
        barcodeDetector.detect(in: visionImage) { (barcodes:[VisionBarcode]?, error:Error?) in
            guard error == nil else{
                print("辨識有錯誤:\(error!.localizedDescription)");
                self.showMessage(message: "辨識有錯誤:\(error!.localizedDescription)")
                return
            }
            guard barcodes != nil,!barcodes!.isEmpty else{
               
                self.showMessage(message: "沒有偵測到")
                return
            }
            var displayString = ""
            
            for visionBarcode in barcodes!{
                if let value = visionBarcode.displayValue{
                    displayString += value
                    displayString += "\n"                    
                }
                
                let frame = visionBarcode.frame
                displayString += "x:\(frame.origin.x),y:\(frame.origin.y),width:\(frame.size.width),height:\(frame.size.height)"
                displayString += "============================\n"
            }
            self.messageOfBarCodeRecognizer.text = displayString;
        }
        
    }
    
    func showMessage(message:String){
        let alertController = UIAlertController(title: "錯誤", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let originalImage = info[.originalImage] as? UIImage else{
            print("取得圖片錯誤");
            return
        }
        
        phothImageView.image = originalImage
        dismiss(animated: true, completion: nil)
    }
}

