//
//  EditProfileViewController.swift
//  Drink-Safely
//
//  Created by Matthew Liu on 4/24/16.
//  Copyright © 2016 Matthew Liu. All rights reserved.
//

import UIKit
import Material

class EditProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

	let genderOptions = ["", "Male", "Female"]
	@IBOutlet weak var userName: TextField!
	@IBOutlet weak var userAge: TextField!
	@IBOutlet weak var userGender: TextField!
	@IBOutlet weak var userPhoneNumber: TextField!
	
	@IBOutlet weak var emergencyName: TextField!
	@IBOutlet weak var emergencyPhoneNumber: TextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
		view.backgroundColor = MaterialColor.deepOrange.darken1
		self.sideNavigationController?.enabledLeftView = false
		self.sideNavigationController?.enabledRightView = false
		
		// Gender Picker
		let pickerView = UIPickerView()
		pickerView.delegate = self
		userGender.inputView = pickerView
		
		// Populate Text Fields
		populateFields()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	/**
	* If These Values exist in dictionary, fill these fields
	**/
	private func populateFields() {
		let saveData = NSUserDefaults.standardUserDefaults()
		if let getUserName = saveData.stringForKey("userName") {
			userName.text = getUserName
			userName.userInteractionEnabled = false
		}
		if let getUserAge = saveData.stringForKey("userAge") { userAge.text = getUserAge }
		if let getUserGender = saveData.stringForKey("userGender") {
			userGender.text = getUserGender
			userGender.userInteractionEnabled = false
		}
		if let getUserPhoneNumber = saveData.stringForKey("userPhoneNumber") { userPhoneNumber.text = getUserPhoneNumber }
		if let getEmergencyName = saveData.stringForKey("emergencyName") { emergencyName.text = getEmergencyName }
		if let getEmergencyPhoneNumber = saveData.stringForKey("emergencyPhoneNumber") { emergencyPhoneNumber.text = getEmergencyPhoneNumber }
	}
	
	// MARK: - PickerView Methods
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int { return 1 }
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return genderOptions.count }
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return genderOptions[row] }
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { userGender.text = genderOptions[row] }
	
	@IBAction func segueToHome(sender: RaisedButton) {
		if (userName.text?.isEmpty)! || (userAge.text?.isEmpty)! || (userGender.text?.isEmpty)! || (userPhoneNumber.text?.isEmpty)! || (emergencyName.text?.isEmpty)! || (emergencyPhoneNumber.text?.isEmpty)! {
			let emptyFields = UIAlertController(title: "Warning", message: "Please fill in all fields.", preferredStyle: .Alert)
			let defaultAction = UIAlertAction(title: "Ok", style: .Default) { (alert: UIAlertAction!) -> Void in NSLog("Filling in fields") }
			emptyFields.addAction(defaultAction)
			self.presentViewController(emptyFields, animated: true, completion: nil)
		}
		else {
			// Save Data Locally
			let saveData = NSUserDefaults.standardUserDefaults()
			saveData.setValue(userName.text, forKey: "userName")
			saveData.setValue(userAge.text, forKey: "userAge")
			saveData.setValue(userGender.text, forKey: "userGender")
			saveData.setValue(userPhoneNumber.text, forKey: "userPhoneNumber")
			saveData.setValue(emergencyName.text, forKey: "emergencyName")
			saveData.setValue(emergencyPhoneNumber.text, forKey: "emergencyPhoneNumber")
			saveData.setValue(30, forKey: "timerLength")
			saveData.synchronize()
			
			// Segue to home screen
			self.dismissViewControllerAnimated(true, completion: nil)
			NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
			return
		}
	}
}

extension UIViewController {
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.dismissKeyboard))
		view.addGestureRecognizer(tap)
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
}
