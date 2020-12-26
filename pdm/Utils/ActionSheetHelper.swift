//
//  ActionSheetHelper.swift
//  AthTracker
//
//  Created by Muhammad Aqeel on 20/05/2020.
//  Copyright © 2020 AthTracker. All rights reserved.
//

import Foundation
import UIKit
class BotttomSheetHelper{
    var callBack : ((PhotoMediaType)->Void)? = nil
    func showAttachmentActionSheet(vc: UIViewController) {
        let actionSheet = UIAlertController(title: "ADD PHOTO", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            if let callBack = self.callBack {
                callBack(PhotoMediaType.camera)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action) -> Void in
            if let callBack = self.callBack {
                callBack(PhotoMediaType.gallery)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        }))
        
        if UIDevice.modelName.contains("iPad"){
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = vc.view
                popoverController.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.maxY , width: 0, height: 0)
                popoverController.permittedArrowDirections = [.right,.down]
            }
        }
        
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
}
