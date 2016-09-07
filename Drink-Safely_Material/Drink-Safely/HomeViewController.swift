//
//  ViewController.swift
//  Test
//
//  Created by Matthew Liu on 4/10/16.
//  Copyright © 2016 Matthew Liu. All rights reserved.
//

import UIKit
import Material

class HomeViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// Material ToolBar
		addToolbar()
		// Intro Card
		addIntroCard()
		
		view.backgroundColor = MaterialColor.grey.lighten3
	}
	
	func addToolbar() {
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Home"
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
		
		// Help button.
		/**
		image = UIImage(named:"Help")
		let helpButton: FlatButton = FlatButton()
		helpButton.pulseColor = MaterialColor.white
		helpButton.pulseScale = false
		helpButton.tintColor = MaterialColor.white
		helpButton.setImage(image, forState: .Normal)
		helpButton.setImage(image, forState: .Highlighted)
		helpButton.addTarget(self, action: #selector(HomeViewController.addHelpCard(_:)), forControlEvents: UIControlEvents.TouchUpInside)
		**/
		
		let toolbar: Toolbar = Toolbar()
		toolbar.statusBarStyle = .LightContent
		toolbar.backgroundColor = MaterialColor.deepOrange.base
		toolbar.titleLabel = titleLabel
		toolbar.leftControls = [menuButton]
		// toolbar.rightControls = [helpButton]

		
		view.addSubview(toolbar)
	}
	
	func addIntroCard() {
		let cardView: CardView = CardView()
		cardView.tag = 1
		cardView.divider = false
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.font = UIFont(name:"Roboto", size: 15)
		titleLabel.text = "Welcome to Drink-Safely!"
		titleLabel.textColor = MaterialColor.blue.darken1
		titleLabel.font = RobotoFont.mediumWithSize(20)
		cardView.titleLabel = titleLabel
		
		// Detail label.
		let detailLabel: UILabel = UILabel()
		detailLabel.font = RobotoFont.regularWithSize(12)
		detailLabel.text = "This Application is a CS 465 Project geared towards college students that consume alchohol. Our hope is that this application will help keep you, the user, safe as well as help you better understand your own drinking habits (and maybe even change that)!"
		detailLabel.numberOfLines = 0
		cardView.detailView = detailLabel
		
		// To support orientation changes, use MaterialLayout.
		view.addSubview(cardView)
		cardView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: cardView, top: 80)
		MaterialLayout.alignToParentHorizontally(view, child: cardView, left: 15, right: 15)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	// Toggles Navigation Drawer
	func toggleNavigationDrawer() {
		sideNavigationController?.toggleLeftView()
	}
	
	/**
	* Starts Party Mode
	* Transitions with SideNavigation 
	**/
	@IBAction func startPartyMode(sender: RaisedButton) {
		// Current Time to String
		let currentDate = NSDate()
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
		let dateString = dateFormatter.stringFromDate(currentDate)
		
		// Log start time in database
		let saveData = NSUserDefaults.standardUserDefaults()
		saveData.setValue(dateString, forKey: "startTime")
		saveData.synchronize()

		// Transition with SideDrawer
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let partyViewController = storyboard.instantiateViewControllerWithIdentifier("PartyViewController") as! PartyViewController
		sideNavigationController?.transitionFromRootViewController(partyViewController,duration: 1, options: .TransitionNone, animations: nil, completion: nil)
	}
	
	/**
	* Tutorial Message Alert
	* Adds Help Card
	**/
	func addHelpCard(sender: FlatButton) {
		if (self.view.viewWithTag(3) == nil) {
			let cardView: CardView = CardView()
			cardView.tag = 3
			
			// Title label.
			let titleLabel: UILabel = UILabel()
			titleLabel.font = UIFont(name:"Roboto", size: 15)
			titleLabel.text = "What do you see on this screen?"
			titleLabel.textColor = MaterialColor.green.darken1
			titleLabel.font = RobotoFont.mediumWithSize(20)
			cardView.titleLabel = titleLabel
			
			// Detail label.
			let detailLabel: UILabel = UILabel()
			detailLabel.font = UIFont(name:"Roboto", size: 13)
			detailLabel.text = "This screen is the home page of our app! Here you will see some general statistics of your alcohol usage, some random facts, and a huge button on the bottom! That buttom starts Party Mode, in other words our proprietary Health tracking algorithm. Recommended to use right before a night of extensive alcohol consumption! There are more interesting things on the left!!"
			detailLabel.numberOfLines = 0
			cardView.detailView = detailLabel
			
			// Yes button.
			let btn1: FlatButton = FlatButton()
			btn1.pulseColor = MaterialColor.blue.lighten1
			btn1.pulseScale = false
			btn1.setTitle("Thanks!", forState: .Normal)
			btn1.setTitleColor(MaterialColor.lightGreen.darken1, forState: .Normal)
			btn1.addTarget(self, action: #selector(HomeViewController.removeHelp(_:)), forControlEvents: UIControlEvents.TouchUpInside)
			
			// Add buttons to right side.
			cardView.rightButtons = [btn1]
			
			// To support orientation changes, use MaterialLayout.
			view.addSubview(cardView)
			cardView.translatesAutoresizingMaskIntoConstraints = false
			MaterialLayout.alignFromTop(view, child: cardView, top: 290)
			MaterialLayout.alignToParentHorizontally(view, child: cardView, left: 15, right: 15)
		}
	}
	// Removes Help Card
	func removeHelp(sender: FlatButton) {
		if let viewWithTag = self.view.viewWithTag(3) {
			viewWithTag.removeFromSuperview()
		}
	}
}

