//
//  EditProductVC.swift
//  SmallBusiness
//
//  Created by Duy Le on 9/17/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit
import OpalImagePicker
import Photos
import RSKImageCropper
import Firebase
import FirebaseAuth
import PKHUD


class EditProductVC: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var btnAvatar: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    var product: Product!
    var avatarData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnAvatar.layer.cornerRadius = self.btnAvatar.bounds.width / 2
        self.txtName.isUserInteractionEnabled = false
        self.txtPrice.isUserInteractionEnabled = false
        self.title = self.product.name
        self.txtName.text = self.product.name
        self.txtPrice.text = self.product.price
        if let productAvatar = self.product.avatarURL, productAvatar != "" {
            self.btnAvatar.sd_setBackgroundImage(with: URL(string: productAvatar), for: .normal, completed: nil)
        }
    }
    
    func fillProduct() {
        if let product = self.product {
            txtName.text = product.name
            txtPrice.text = product.price
        }
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
        
        self.product?.name = name
        self.product?.price = price
        if self.avatarData != nil {
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
                        guard let me = self else { return }
                        if error != nil {
                            HUD.hide()
                            AlertService.shared.showAlert(vc: me, title: "SERVER ERROR!", message: "Can not save product picture")
                        } else {
                            if let url = url?.absoluteString {
                                me.product?.avatarURL = url
                                ConnectionManager.shared.updateProduct(product: me.product!)
                                runAfterDelay(0.5, closure: {
                                    HUD.hide()
                                    me.navigationController?.popViewController(animated: true)
                                })
                            }

                        }
                    })
                }
            })
        } else {
            ConnectionManager.shared.updateProduct(product: product!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onEditNameAction(_ send: Any) {
        self.view.endEditing(true)
        
        let vc = EnterTextVC()
        vc.editType = .productName(self.product)
        vc.didSaveBlock = { [weak self] (product) in
            if let product = product as? Product {
                self?.product?.name = product.name
                self?.fillProduct()
                self?.title = product.name
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onEditPriceAction(_ send: Any) {
        self.view.endEditing(true)
        
        let vc = EnterCurrencyVC()
        vc.product = self.product
        
        vc.didSaveBlock = { [weak self] (product) in
            if let product = product as? Product {
                self?.product?.price = product.price
                self?.fillProduct()
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
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
}

extension EditProductVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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

extension EditProductVC: RSKImageCropViewControllerDelegate {
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
