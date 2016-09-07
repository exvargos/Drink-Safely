//
//  SettingsViewController.swift
//  Drink-Safely
//
//  Created by Matthew Liu on 4/18/16.
//  Copyright © 2016 Matthew Liu. All rights reserved.
//

import UIKit
import Material

private struct Item {
	var text: String
	var detail: String
}

class SettingsViewController: UIViewController {

	/// tableView for Settings
	private let tableView: UITableView = UITableView()
	/// Array of settings
	private var settings: Array<Item> = Array<Item>()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = MaterialColor.grey.lighten3
		addToolbar()
		prepareItems()
		prepareTableView()
		prepareCardView()
    }
	
	/// Loads Settings into array
	private func prepareItems() {
		settings.append(Item(text: "Reset Application", detail: "Deletes all User Data"))
		settings.append(Item(text: "Change Timer for User Test", detail: "Timer in Seconds"))
		settings.append(Item(text: "Option", detail: "Option"))
		settings.append(Item(text: "Option", detail: "Option"))
		// Add More here
	}
	
	/// Prepares tableView
	/// Setup this file to take over providing data for tableview and managing table
	private func prepareTableView() {
		tableView.tableFooterView = UIView()
		tableView.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "Cell")
		tableView.dataSource = self
		tableView.delegate = self
		tableView.scrollEnabled = false
	}
	
	/// Prepares the CardView for Settings
	private func prepareCardView() {
		let cardView: CardView = CardView()
		cardView.pulseColor = nil
		cardView.backgroundColor = MaterialColor.grey.lighten5
		cardView.cornerRadiusPreset = .Radius1
		cardView.divider = false
		cardView.contentInsetPreset = .None
		cardView.leftButtonsInsetPreset = .Square2
		cardView.rightButtonsInsetPreset = .Square2
		cardView.detailViewInsetPreset = .None
		
		let titleLabel: UILabel = UILabel()
		titleLabel.font = RobotoFont.mediumWithSize(20)
		titleLabel.text = "Options"
		titleLabel.textAlignment = .Center
		titleLabel.textColor = MaterialColor.blueGrey.darken4
		
		let v: UIView = UIView()
		v.backgroundColor = MaterialColor.blue.accent1
		
		// Use MaterialLayout to easily align the tableView.
		cardView.titleLabel = titleLabel
		cardView.detailView = tableView
		
		cardView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(cardView)
		MaterialLayout.alignToParent(view, child: cardView, left: 15, right: 15, top: 80, bottom: 100)
	}
	
	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func addToolbar() {
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Settings"
		titleLabel.textAlignment = .Left
		titleLabel.textColor = MaterialColor.white
		
		let image: UIImage? = UIImage(named:"Menu")
		
		// Menu button.
		let menuButton: FlatButton = FlatButton()
		menuButton.pulseColor = MaterialColor.white
		menuButton.pulseScale = false
		menuButton.tintColor = MaterialColor.white
		menuButton.setImage(image, forState: .Normal)
		menuButton.setImage(image, forState: .Highlighted)
		menuButton.addTarget(self, action: #selector(toggleNavigationDrawer), forControlEvents: .TouchUpInside)
		
		let toolbar: Toolbar = Toolbar()
		toolbar.statusBarStyle = .LightContent
		toolbar.backgroundColor = MaterialColor.deepOrange.base
		toolbar.titleLabel = titleLabel
		toolbar.leftControls = [menuButton]
		
		view.addSubview(toolbar)
	}
	
	// Toggles Navigation Drawer
	func toggleNavigationDrawer() {
		sideNavigationController?.toggleLeftView()
	}

}

/// TableView Methods, Implement here so another file is not needed
extension SettingsViewController: UITableViewDataSource {
	/// Determines number of rows
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return settings.count
	}
	
	/// Returns the number of sections
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	/// Prepares the cells within the tableView
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
		
		let setting: Item = settings[indexPath.row]
		cell.selectionStyle = .None
		cell.textLabel!.text = setting.text
		cell.textLabel!.font = RobotoFont.regularWithSize(14)
		cell.detailTextLabel!.text = setting.detail
		cell.detailTextLabel!.font = RobotoFont.regularWithSize(13)
		cell.detailTextLabel!.textColor = MaterialColor.grey.darken1
		cell.detailTextLabel?.numberOfLines = 0
		
		// Buttons for each cell
		let btn: RaisedButton = RaisedButton(frame: CGRectMake(40, 60, 80, 24))
		btn.setTitle("Apply", forState: UIControlState.Normal)
		btn.titleLabel?.font = RobotoFont.regularWithSize(11)
		btn.addTarget(self, action: #selector(SettingsViewController.buttonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
		btn.backgroundColor = MaterialColor.orange.darken1
		btn.shadowOpacity = 0
		btn.tag = indexPath.row   // Tag Based on row, different functions
		let cellHeight: CGFloat = 60
		btn.center = CGPoint(x: cell.bounds.width * (17/20), y: cellHeight / 2.0)
		
		cell.addSubview(btn)
		
		return cell
	}
	
	func buttonAction(sender: UIButton!) {
		let btnsendtag: UIButton = sender
		if btnsendtag.tag == 0 {
			// Reset Application Entry
			let clearProfile = UIAlertController(title: "Warning:", message: "You are about to reset the app. Are you sure?", preferredStyle: .Alert)
			let defaultAction = UIAlertAction(title: "NO!", style: .Default) { (alert: UIAlertAction!) -> Void in NSLog("NO: Not wiping") }
			let secondaryAction = UIAlertAction(title: "DO IT", style: .Default) {
				(alert: UIAlertAction!) -> Void in NSLog("You got home")
				
				// Clear Dictionary
				let appDomain = NSBundle.mainBundle().bundleIdentifier!
				NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
				
				exit(0)
			}
			
			// Adds Button to Alert
			clearProfile.addAction(defaultAction)
			clearProfile.addAction(secondaryAction)
			
			// Adds Alert to View
			presentViewController(clearProfile, animated: true, completion: nil)
		} else if btnsendtag.tag == 1 {
			// Set Party Alert Timer
			let setTimer = UIAlertController(title: "Set Timer:", message: "Please enter in seconds how long you want the timer to go for.", preferredStyle: .Alert)
			let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (_) in
				if let field = setTimer.textFields![0] as UITextField! {
					// store your data
					NSUserDefaults.standardUserDefaults().setValue(field.text, forKey: "timerLength")
					NSUserDefaults.standardUserDefaults().synchronize()
				} else {
					// user did not fill field
				}
			}
			
			let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
			
			setTimer.addTextFieldWithConfigurationHandler { (textField) in
				textField.placeholder = NSUserDefaults.standardUserDefaults().stringForKey("timerLength")
			}
			
			// Adds Alert to View
			setTimer.addAction(confirmAction)
			setTimer.addAction(cancelAction)
			presentViewController(setTimer, animated: true, completion: nil)
		} else {
			let template = UIAlertController(title: "TEMPLATE", message: "[INSERT TEXT HERE]", preferredStyle: .Alert)
			let defaultAction = UIAlertAction(title: "TEMP", style: .Default) { (alert: UIAlertAction!) -> Void in NSLog("temp") }
			template.addAction(defaultAction)
			presentViewController(template, animated: true, completion: nil)

		}
	}
	
	/// Cell Button Functionality
	func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
		
		print(cell.textLabel?.text)
	}
}

/// TableViewDelegate Methods
extension SettingsViewController: UITableViewDelegate {
	/// Sets the tableView cell height.
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 60
	}
}