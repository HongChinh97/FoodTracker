//
//  ViewController.swift
//  FoodTracker
//
//  Created by admin on 7/26/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import os.log
//viewController có thể làm việc như 1 uỷ nhiệm trường văn bản hợp lệ khi thêm UITextFieldelegate
class MealViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    
   
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var meal: Meal?
    
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tự đề cập tới lớp ViewController
        nameTextField.delegate = self
        
       
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }

        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField từ bỏ câu trả lời đầu tiên khi thay đổi
        textField.resignFirstResponder()
        return true
    }
    //lấy văn bản và thay thế giá trị của nhãn
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
        updateSaveButtonState()
        navigationItem.title = textField.text
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        meal = Meal(name: name, photo: photo, rating: rating)
    }

    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //ẩn bàn phím
        nameTextField.resignFirstResponder()
        let imagePickerCntroller = UIImagePickerController()
        imagePickerCntroller.sourceType = .photoLibrary
        //cho phép thông báo khi chọn một hình ảnh
        imagePickerCntroller.delegate = self
        present(imagePickerCntroller, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Loại bỏ bộ chọn nếu người dùng đã hủy.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError(" The MealViewController is not inside a navigation controller")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("\(info)")
        }
        //hiển thị hình ảnh
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
        
    }
    private func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

