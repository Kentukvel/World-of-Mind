//
//  NewRecordViewController.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/14/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit

class NewRecordViewController: UIViewController, UITextViewDelegate {

    var selectedRecord: Diary?
    var updateTable: ((Diary?) -> ())?
    var diaryViewModel = DiaryViewModel()
    var hasImage = false
    
    @IBOutlet weak var setImageButton: UIButton!
    @IBOutlet weak var imageOfRecord: UIImageView!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var titleOfRecord: UITextField!
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if selectedRecord != nil {
            selectedRecord?.recordName = titleOfRecord.text
            selectedRecord?.recordText = notes.text
            diaryViewModel.save()
            updateTable!(nil)
        } else {
            let newRecord = diaryViewModel.saveNewRecord(name: titleOfRecord.text!,
                                                         text: notes.text,
                                                         hasImage: hasImage,
                                                         image: hasImage ? imageOfRecord.image?.pngData() : nil)
           
            
            updateTable!(newRecord)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func setImage(_ sender: UIButton) {
        showImagePickerControllerActionSheet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if selectedRecord != nil {
            notes.text = selectedRecord?.recordText
            titleOfRecord.text = selectedRecord?.recordName
        }
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - TextView delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notes.textColor == UIColor.lightGray {
            notes.text = nil
            notes.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if notes.text.isEmpty {
            notes.text = "Notes"
            notes.textColor = UIColor.lightGray
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension NewRecordViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func showImagePickerControllerActionSheet() {
        let alert = UIAlertController(title: "Pick image", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default , handler:{ (UIAlertAction)in
            self.showImagePickerController(sourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction) in
            self.showImagePickerController(sourceType: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageOfRecord.image = editedImage
            hasImage = true
        } else {
            
        }
        
        
        dismiss(animated: true, completion: nil)
    }
}

