//
//  ViewController.swift
//  FoodTracker
//
//  Created by admin on 7/26/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import os.log
//viewController có thể làm việc như 1 uỷ nhiệm trường văn bản hợp lệ khi thêm UITextFieldDelegate
class MealViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
//    var meals = [Meal]()
//    var person: Person?
//    var index: Int?
    var food: Food?
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tự đề cập tới lớp ViewController
        nameTextField.delegate = self
        // Xử lý đầu vào nội dung trường văn bản của người dùng thông qua gọi lại delegate
        if let food = food {
            navigationItem.title = food.name
            nameTextField.text = food.name
            photoImageView.image = food.photo as? UIImage
            ratingControl.rating = Int(food.rating)
        }

        //cập nhật lại nút save
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    // vo hieu hoa nut save khi khong nhap ten
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
//    @IBAction func saveMeal(_ sender: UIBarButtonItem) {
////        guard let meal = Meal(name: nameTextField.text ?? "", photo: photoImageView.image, rating: ratingControl.rating) else { return }
////        if let index = index {
////            DataService.shared.editMeals(index: index, meal: meal)
////        } else {
////            DataService.shared.addMeals(meal: meal)
////        }
//        guard let name = nameTextField.text  else {
//            return
//        }
//        guard let photo = photoImageView.image else {return}
//        if person == nil {
//            person = Person(context: (DataService.shared.fetchedResultsController.managedObjectContext))
//        }
//        person?.name = name
//        person?.photo = photo
//        DataService.shared.saveData()
//
//        exitToRootView()
//    }


    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //ẩn bàn phím
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        //cho phép thông báo khi chọn một hình ảnh
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
//        exitToRootView()
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem,
            button === saveButton else {
                os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        guard let name = nameTextField.text else {
            return
        }
        guard let photo = photoImageView.image else
            {return}
            
            let rating = ratingControl.rating
        
        if food == nil {
            food = Food(context: AppDelegate.context)
        }
        food?.name = name
        food?.photo = photo
        food?.rating = Int16(Int(rating))
        
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Loại bỏ bộ chọn nếu người dùng đã hủy.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("\(info)")
        }
        //hiển thị hình ảnh
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
        
    }
    //khi không nhâp gì trong nameTextField thì nút save sẽ bị mờ đi không chọn được
    private func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

