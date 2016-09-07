//
//  UserProfileViewController.swift
//  Drink-Safely
//
//  Created by Matthew Liu on 4/18/16.
//  Copyright © 2016 Matthew Liu. All rights reserved.
//

import UIKit
import Material

class UserProfileViewController: UIViewController {

	@IBOutlet weak var GraphCardTitle: UILabel!
	@IBOutlet weak var GraphCard: CardView!
	@IBOutlet weak var UsageGraph: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		addToolbar()
		addUserProfile()
		prepareGraphCard()
		view.backgroundColor = MaterialColor.grey.lighten3
		
		// Update User Name after Editing
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserProfileViewController.refreshProfile(_:)), name:"refresh", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func refreshProfile(notification: NSNotification) {
//		let userGridView = view.viewWithTag(5)
		// Call This from Edit Profile to Update view
		print("Edited Profile")
	}
	
	private func addUserProfile() {
		// Get User Info
		let saveData = NSUserDefaults.standardUserDefaults()
		
		let userGridView: MaterialPulseView = MaterialPulseView(frame: CGRectMake(16, 80, view.bounds.width - 32, 152))
		userGridView.pulseColor = MaterialColor.blueGrey.base
		userGridView.depth = .Depth1
		userGridView.tag = 5
		view.addSubview(userGridView)

		// Profile Picture
		let profilePicture: UIImage? = UIImage(named: "Profile")
		let pictureView: MaterialView = MaterialView()
		pictureView.image = profilePicture
		pictureView.contentsGravityPreset = .ResizeAspectFill
		userGridView.addSubview(pictureView)

		// User Information
		let userInformationView: MaterialView = MaterialView()
		userInformationView.backgroundColor = MaterialColor.clear
		userGridView.addSubview(userInformationView)
		
		// User Name
		let userName: UILabel = UILabel()
		userName.text = saveData.stringForKey("userName")
		userName.font = RobotoFont.mediumWithSize(14)
		userName.textColor = MaterialColor.blue.darken1
		userName.backgroundColor = MaterialColor.clear
		userInformationView.addSubview(userName)
		
		// User Gender and Birthdate
		let userGenderDate: UILabel = UILabel()
		userGenderDate.text = saveData.stringForKey("userGender")! + ", " + saveData.stringForKey("userAge")!
		userGenderDate.font = RobotoFont.regularWithSize(11)
		userGenderDate.textColor = MaterialColor.blueGrey.darken4
		userGenderDate.backgroundColor = MaterialColor.clear
		userInformationView.addSubview(userGenderDate)

		// User Home Address
		let userAddress: UILabel = UILabel()
		userAddress.numberOfLines = 0
		userAddress.lineBreakMode = .ByTruncatingTail
		userAddress.text = "555 E. Siebel St. Apt 1234 Champaign IL, 61820"
		userAddress.font = RobotoFont.regularWithSize(11)
		userAddress.textColor = MaterialColor.blueGrey.darken4
		userAddress.backgroundColor = MaterialColor.clear
		userInformationView.addSubview(userAddress)
		
		// User Emergency Contact
		let userContact: UILabel = UILabel()
		userContact.numberOfLines = 0
		userContact.lineBreakMode = .ByWordWrapping
		userContact.font = RobotoFont.regularWithSize(11)
		userContact.textColor = MaterialColor.blueGrey.darken4
		userContact.backgroundColor = MaterialColor.clear
		userContact.preferredMaxLayoutWidth = 200
		userContact.text = "E.C.: " + saveData.stringForKey("emergencyName")! + " - " + saveData.stringForKey("emergencyPhoneNumber")!
		userInformationView.addSubview(userContact)
		
		// Grid Layout system
		pictureView.grid.columns = 4
		userInformationView.grid.columns = 8
		userGridView.grid.views = [
			pictureView,
			userInformationView
		]
		
		userName.grid.rows = 3
		userName.grid.columns = 8
		
		userGenderDate.grid.rows = 2
		userGenderDate.grid.offset.rows = 3
		userGenderDate.grid.columns = 8
		
		userAddress.grid.rows = 4
		userAddress.grid.offset.rows = 5
		userAddress.grid.columns = 8
		
		userContact.grid.rows = 2
		userContact.grid.offset.rows = 9
		userContact.grid.columns = 8
		
		userInformationView.grid.spacing = 8
		userInformationView.grid.axis.direction = .None
		userInformationView.grid.contentInsetPreset = .Square3
		userInformationView.grid.views = [
			userName,
			userGenderDate,
			userAddress,
			userContact
		]

	}
	
	private func addToolbar() {
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "User Profile"
		titleLabel.textAlignment = .Left
		titleLabel.textColor = MaterialColor.white
		
		var image: UIImage? = UIImage(named:"Menu")
		
		// Menu button.
		let menuButton: FlatButton = FlatButton()
		menuButton.pulseColor = MaterialColor.white
		menuButton.pulseScale = false
		menuButton.tintColor = MaterialColor.white
		menuButton.setImage(image, forState: .Normal)
		menuButton.setImage(image, forState: .Highlighted)
		menuButton.addTarget(self, action: #selector(UserProfileViewController.toggleNavigationDrawer), forControlEvents: .TouchUpInside)
		
		// Edit button.
		image = UIImage(named:"Edit")
		let editButton: FlatButton = FlatButton()
		editButton.pulseColor = MaterialColor.white
		editButton.pulseScale = false
		editButton.tintColor = MaterialColor.white
		editButton.setImage(image, forState: .Normal)
		editButton.setImage(image, forState: .Highlighted)
		editButton.addTarget(self, action: #selector(UserProfileViewController.editingProfile), forControlEvents: .TouchUpInside)
		
		let toolbar: Toolbar = Toolbar()
		toolbar.statusBarStyle = .LightContent
		toolbar.backgroundColor = MaterialColor.deepOrange.base
		toolbar.titleLabel = titleLabel
		toolbar.leftControls = [menuButton]
		toolbar.rightControls = [editButton]
		
		view.addSubview(toolbar)
	}
	
	// Toggles Navigation Drawer
	func toggleNavigationDrawer() {
		sideNavigationController?.toggleLeftView()
	}
	
	func editingProfile() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let editProfileView = storyboard.instantiateViewControllerWithIdentifier("EditProfile") as! EditProfileViewController
		self.presentViewController(editProfileView, animated: true, completion: nil)
	}
	
	/// Sets up graph card
	private func prepareGraphCard() {
		GraphCard.cornerRadius = 0
		GraphCardTitle.text = "Usage Graphs"
		GraphCardTitle.textColor = MaterialColor.blue.darken1
		UsageGraph.image = UIImage(named: "Graph1")
	}
	
	@IBAction func switchGraphs(sender: UISegmentedControl) {
		if sender.selectedSegmentIndex == 0 {
			UsageGraph.image = UIImage(named: "Graph1")
		}
			
		else if sender.selectedSegmentIndex == 1 {
			UsageGraph.image = UIImage(named: "Graph2")
		}
			
		else if sender.selectedSegmentIndex == 2 {
			UsageGraph.image = UIImage(named: "Graph3")
		}

	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}