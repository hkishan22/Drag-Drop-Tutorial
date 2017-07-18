//
//  ViewController.swift
//  ImageLoader
//
//  Created by admin on 18/07/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let imagePickerController =  UIImagePickerController()
    
    @IBOutlet weak var imageView:  UIImageView!
    @IBOutlet weak var textField:  UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePickerController.delegate = self
        self.addInteraction()
    }
    
    
    
    
    @IBAction func photoFromLibrary(_ sender: UIButton) {
        
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        self.imageView.image = chosenImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController: UIDropInteractionDelegate {
    
    func addInteraction(){
        self.view.addInteraction(UIDropInteraction(delegate: self))
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        for item in session.items {
            
            item.itemProvider.loadObject(ofClass: NSString.self, completionHandler: { (object, error) in
                
                if let error = error   {
                    print("Failed to load dragged String due to ",error)
                    return
                }
                
                DispatchQueue.main.async {
                    guard let dropedString = object as? NSString else {
                        return
                    }
                    self.textField.text = dropedString as String!
                }
            })
            
            
            item.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                
                if let error = error   {
                    print("Failed to load dragged item due to ",error)
                    return
                }
                
                DispatchQueue.main.async {
                    guard let dropedImage = object as? UIImage else {
                        return
                    }
                    self.imageView.image = dropedImage
                }
            })
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        
        return UIDropProposal(operation: .copy)
    }
    
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self) || session.canLoadObjects(ofClass: NSString.self)
    }
}

