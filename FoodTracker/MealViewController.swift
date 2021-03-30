//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Rio Michelini on 24/02/2021.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	// MARK: Properties
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var photoImageView: UIImageView!
	@IBOutlet weak var ratingControl: RatingControl!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	
	var meal: Meal?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		nameTextField.delegate = self
		if let meal = meal {
			navigationItem.title = meal.name
			nameTextField.text = meal.name
			photoImageView.image = meal.photo
			ratingControl.rating = meal.rating
		}
		self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
		self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		updateSaveButtonState()
	}
	
	// MARK: UITextFieldDelegate
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		// Hide Keyboard
		textField.resignFirstResponder()
		return true
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		updateSaveButtonState()
		navigationItem.title = textField.text
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		saveButton.isEnabled = false
	}
	
	// MARK: UIImagePickerControllerDelegate
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
			fatalError("Expected a dictionary containing an image, but was provided the following \(info)")
		}
		photoImageView.image = selectedImage
		dismiss(animated: true)
	}
	
	// MARK: Navigation
	@IBAction func cancel(_ sender: UIBarButtonItem) {
		let isPresentingInAddMealMode = presentingViewController is UINavigationController
		if isPresentingInAddMealMode {
			dismiss(animated: true)
		} else if let owningNavigationController = navigationController {
			owningNavigationController.popViewController(animated: true)
		} else {
			fatalError("The MealViewController is not inside a navigation controller.")
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		guard let button = sender as? UIBarButtonItem, button === saveButton else {
			os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
			return
		}
		let name = nameTextField.text ?? ""
		let photo = photoImageView.image
		let rating = ratingControl.rating
		meal = Meal(name: name, photo: photo, rating: rating)
	}
	
	// MARK: Actions
	@IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
		nameTextField.resignFirstResponder()
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			let ac = UIAlertController(title: "Choose input", message: nil, preferredStyle: .actionSheet)
			ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: openCamera))
			ac.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: openPhotoLibrary))
			ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
			present(ac, animated: true)
		} else {
			openPhotoLibrary(action: UIAlertAction())
		}
	}
	
	@objc func openCamera(action: UIAlertAction) {
		let cameraController = UIImagePickerController()
		cameraController.sourceType = .camera
		cameraController.allowsEditing = false
		cameraController.delegate = self
		present(cameraController, animated: true)
	}
	
	@objc func openPhotoLibrary(action: UIAlertAction) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = .photoLibrary
		imagePickerController.delegate = self
		present(imagePickerController, animated: true)
	}
	
	// MARK: Private Methods
	private func updateSaveButtonState() {
		let text = nameTextField.text ?? ""
		saveButton.isEnabled = !text.isEmpty
	}
	
}

