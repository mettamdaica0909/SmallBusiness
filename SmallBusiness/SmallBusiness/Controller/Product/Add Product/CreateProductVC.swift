//
//  CreateProductVC.swift
//  SmallBusiness
//
//  Created by Duy Le on 9/15/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit
import OpalImagePicker
import Photos
import RSKImageCropper
import Firebase
import FirebaseAuth
import PKHUD

class CreateProductVC: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var btnAvatar: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    var product: Product?
    var avatarData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let id = UUID().uuidString
        self.product = Product(id: id, name: "", price: 0, avatarURL: "", owner: (Auth.auth().currentUser?.uid)!)
        self.btnAvatar.layer.cornerRadius = self.btnAvatar.bounds.width / 2
        NOTIFICATION_CENTER.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NOTIFICATION_CENTER.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.txtPrice.keyboardType = .numberPad
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        btnSave.isHidden = true
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        btnSave.isHidden = false
    }

    @IBAction func onAvatarAction(_ sender: Any) {
        let customActionSheetVC = CustomActionSheetViewController(items: [
            MenuViewItem(title: "Chụp hình", onTap: { [weak self] in
                guard let me = self else { return }
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = me
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = false
                    me.present(imagePicker, animated: true, completion: nil)
                }
            }),
            MenuViewItem(title: "Thư viện ảnh", onTap: { [weak self] in
                guard let me = self else { return }
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                me.present(imagePicker, animated: true, completion: nil)
            }),
            MenuViewItem(title: "Huỷ", type: .Cancel)
            ])
        self.present(customActionSheetVC, animated: true, completion: nil)
    }
    
    @IBAction func onSaveAction(_ send: Any) {
        self.view.endEditing(true)
        let name = txtName.text?.trimmed()
        if name.isNilOrEmpty {
            let msg = "Bạn chưa nhập tên sản phẩm"
            AlertService.shared.showAlert(vc: self, title: "", message: msg)
            return
        }
        
        let price = txtPrice.text?.trimmed()
        if price.isNilOrEmpty {
            let msg = "Bạn chưa nhập giá sản phẩm"
            AlertService.shared.showAlert(vc: self, title: "", message: msg)
            return
        }
        
        guard let priceNum = Double(price ?? "") else {
            let msg = "Giá sản phẩm chưa đúng"
            AlertService.shared.showAlert(vc: self, title: "", message: msg)
            return
        }
        
        if self.avatarData == nil {
            let msg = "Bạn chưa chọn hình sản phẩm"
            AlertService.shared.showAlert(vc: self, title: "", message: msg)
            return
        }
        self.product?.name = name
        self.product?.price = priceNum
        
        // upload product avata
        let finalRef = productPhotosRef.child((self.product?.id)!)
        let storageRef = finalRef.child("\((self.product?.id)!).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        HUD.show(.progress)
        storageRef.putData(self.avatarData!, metadata: metaData, completion: { metaData, error in
            if (error != nil) {
                HUD.hide()
                AlertService.shared.showAlert(vc: self, title: "SERVER ERROR!", message: "Can not save product picture")
            } else {
                storageRef.downloadURL(completion: { [weak self] (url, error) in
                    HUD.hide()
                    guard let me = self else { return }
                    if let url = url?.absoluteString {
                        me.product?.avatarURL = url
                        ConnectionManager.shared.createProduct(product: (me.product)!) { (ref, error) in
                            if error != nil {
                                AlertService.shared.showAlert(vc: me, title: "", message: "Create product fail")
                            } else {
                                me.navigationController?.popViewController(animated: true)
                            }
                        }

                    }
                })
            }
        })
    }
}

extension CreateProductVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage?
        if let image  = info[UIImagePickerControllerEditedImage] as? UIImage {
            newImage = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newImage = image
        } else {
            return
        }
        
        let imageCropVC = RSKImageCropViewController(image: newImage!, cropMode: .square)
        imageCropVC.delegate = self
        imageCropVC.avoidEmptySpaceAroundImage = true
        imageCropVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(imageCropVC, animated: true)
        
        dismiss(animated: true, completion: nil)
    }
}

extension CreateProductVC: RSKImageCropViewControllerDelegate {
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        if let data = croppedImage.toData(stride: 0.05) {
            self.avatarData = data
            self.btnAvatar.setBackgroundImage(croppedImage, for: .normal)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.navigationController?.popViewController(animated: true)
    }
}
