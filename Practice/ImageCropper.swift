//
//  ImageCropper.swift
//  Practice
//
//  Created by Siddhesh jadhav on 01/06/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import TOCropViewController
import MobileCoreServices

class ImageCropper: UIViewController,UIScrollViewDelegate{
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var subScrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var mainScrollHeight: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        mainScrollView.delegate = self
        subScrollView.delegate = self
        
        mainScrollView.bounces = false
        tableView.bounces = false
        
        mainScrollHeight = mainScrollView.frame.height
        screenHeight = UIScreen.main.bounds.height
        print("mainScrollHeight",mainScrollHeight)
        print("screenHeight",screenHeight)
        
        if mainScrollHeight >= screenHeight{
            tableView.isScrollEnabled = false
            print("table view scroll disabled from did load")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yOffset = mainScrollView.contentOffset.y
        let tableyOffset = tableView.contentOffset.y
        
        //        if yOffset <= 0{
        //            self.tableView.isScrollEnabled = false
        //            print("table view scroll disabled")
        //            print("yOffset",yOffset)
        //        }
        
        if scrollView == mainScrollView{
            print("mainScrollView",yOffset)
            if yOffset >=  mainScrollView.bounds.minY {
                print("table view scroll enabled:- mainScrollView")
                self.tableView.isScrollEnabled = true
            }
        }else if scrollView == tableView{
            print("tableScrollView",tableyOffset)
            if tableyOffset <= 0 {
                print("table view scroll disabled :- tableView")
                self.tableView.isScrollEnabled = false
            }
        }
    }
    
    
    @IBAction func btnTapped(_ sender: UIButton) {
        let sourceView = UIView()
        let alert = tappedOnImageAlert(imagePicker)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        if let presentationController = alert.popoverPresentationController {
            presentationController.delegate = self
            presentationController.sourceView = sourceView
            presentationController.sourceRect = sourceView.bounds
        }
        self.present(alert, animated: true, completion:nil)
    }
    
    func tappedOnImageAlert(_ imagePicker: UIImagePickerController) -> UIAlertController {
        let alert = UIAlertController(title: title, message: "Select an option", preferredStyle: UIAlertController.Style.actionSheet)
        alert.view.tintColor = .red
        
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: UIAlertAction.Style.default,handler: {_ in
            self.selectPhotoLibrary(imagePicker)
        })
        
        let docAction = UIAlertAction(title: "Documents", style: UIAlertAction.Style.default,handler: {_ in
            self.selectDocument()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel,handler: nil)
        
        alert.addAction(libraryAction)
        alert.addAction(docAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    func selectPhotoLibrary(_ imagePicker: UIImagePickerController) {
        UINavigationBar.appearance().tintColor = UIColor.black
        imagePicker.sourceType = .photoLibrary
        UINavigationBar.appearance().tintColor = UIColor.white
        present(imagePicker, animated: true, completion: nil)
    }
    
    func selectDocument() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
        //Call Delegate
        documentPicker.delegate = self
        UINavigationBar.appearance().tintColor = .black
        self.present(documentPicker, animated: true)
    }
}

extension ImageCropper: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else
        {print("return");return}
        let cropper = TOCropViewController(image: pickedImage)
        cropper.delegate = self
        cropper.customAspectRatio = CGSize(width: 1.0, height: 2.0)
        cropper.aspectRatioLockEnabled = false
        cropper.resetAspectRatioEnabled = false
        cropper.aspectRatioPickerButtonHidden = true
        cropper.rotateButtonsHidden = false
        cropper.rotateClockwiseButtonHidden = true
        
        picker.pushViewController(cropper, animated: false)
        UINavigationBar.appearance().tintColor = UIColor.white
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        UINavigationBar.appearance().tintColor = UIColor.white
        dismiss(animated: true, completion: nil)
    }
}


extension ImageCropper: TOCropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        
        let pickedOG = image.jpegData(compressionQuality: 1.0)!
        
        let nimage = image.compressImage()
        let ndata = nimage!.jpegData(compressionQuality: 1.0)!
        let ndatacount = ndata.count
        let nSize = Float(Double(ndata.count)/1024/1024)
        
        var fileSizeInMb = Double()
        print("ndatacount", ndatacount)
        print("nSize", nSize)
        fileSizeInMb = Double(ndatacount)/Double(1024*1024)
        print("fileSizeInMb",fileSizeInMb)
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB]
        bcf.countStyle = .file
        let string2 = bcf.string(fromByteCount: Int64(pickedOG.count))
        let string3 = bcf.string(fromByteCount: Int64(ndata.count))
        
        print("Original formatted result: \(string2)  - \(pickedOG.count)")
        print("Original formatted result mb: \(Double(pickedOG.count)/Double(1024*1024))")
        
        
        print("Compressed formatted result: \(string3)  - \(ndatacount)")
        print("Compressed formatted result mb: \(Double(ndatacount)/Double(1024*1024))")
        
        
        
        imagePicker.dismiss(animated: true)
        
        
        
        
    }
}


extension ImageCropper: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        UINavigationBar.appearance().tintColor = UIColor.white
        let myURL = url as URL
        print("import result : \(myURL)")
        let fileData = try! Data.init(contentsOf: url)
        
        let base64PdfSuffix = "data:application/pdf;base64,"
        
        let base64String: String = base64PdfSuffix + fileData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        print("didPickDocumentAt base64String result : \(base64String)")
        
        
        
        
        
    }
    
    func documentMenu(_ documentMenu:UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        UINavigationBar.appearance().tintColor = UIColor.white
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        UINavigationBar.appearance().tintColor = UIColor.white
        dismiss(animated: true, completion: nil)
    }
}


extension ImageCropper: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Example"
        return cell
    }
    
    
}


extension UIImage{
    func compressImage() -> UIImage? {
        // Reducing file size to a 10th
        var actualHeight: CGFloat = self.size.height
        var actualWidth: CGFloat = self.size.width
        let maxHeight: CGFloat = 1024.0
        let maxWidth: CGFloat = 768.0
        var imgRatio: CGFloat = actualWidth/actualHeight
        let maxRatio: CGFloat = maxWidth/maxHeight
        var compressionQuality: CGFloat = 1
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            } else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
                compressionQuality = 1
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        
        guard let imageData = img.jpegData(compressionQuality: compressionQuality) else { return nil}
        
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB]
        bcf.countStyle = .file
        let string2 = bcf.string(fromByteCount: Int64(imageData.count))
        
        print("Original formatted result: \(string2)  - \(imageData.count)")
        print("inside compression script", imageData.count)
        
        return UIImage(data: imageData)
    }
}

