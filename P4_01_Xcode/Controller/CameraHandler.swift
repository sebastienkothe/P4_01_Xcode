//
//  CameraHandler.swift
//  P4_01_Xcode
//
//  Created by Sébastien Kothé on 24/04/2020.
//  Copyright © 2020 Sébastien Kothé. All rights reserved.
//

import Foundation
import UIKit

class CameraHandler: NSObject {
    
    //MARK: Internal Properties
    
    var imagePickedBlock: ((UIImage) -> Void)?
    
    // MARK: - Internal methods
    
    /// Method that allows the user to select a photo from their photo library or to use the phone camera
    func showActionSheet(viewController: UIViewController) {
        currentViewController = viewController
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: Private Properties
    
    private var currentViewController: UIViewController!
    
    //MARK: Private methods
    
    private func camera() {
        presentImageControllerWith(sourceType: .camera)
    }
    
    private func photoLibrary() {
        presentImageControllerWith(sourceType: .photoLibrary)
    }
    
    private func presentImageControllerWith(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            imagePickerController.allowsEditing = true
            currentViewController.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
}

extension CameraHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentViewController.dismiss(animated: true, completion: nil)
    }
    
    /// This method allows to recover the photo (info dictionary)
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            self.imagePickedBlock?(image)
        }
        
        currentViewController.dismiss(animated: true, completion: nil)
    }
    
}
