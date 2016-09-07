//
//  SideDrawerViewController.swift
//  Drink-Safely
//
//  Created by Matthew Liu on 4/18/16.
//  Copyright © 2016 Matthew Liu. All rights reserved.
//

import UIKit
import Material

private struct Item {
	var text: String
	var imageName: String
}

class SideDrawerViewController: UIViewController {
	// tableView for navigation items
	private let tableView: UITableView = UITableView()
	// List of navigation items
	private var items: Array<Item> = Array<Item>()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
		prepareView()
		prepareCells()
		prepareTableView()
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		/*
		The dimensions of the view will not be updated by the side navigation
		until the view appears, so loading a dyanimc width is better done here.
		The user will not see this, as it is hidden, by the drawer being closed
		when launching the app. There are other strategies to mitigate from this.
		This is one approach that works nicely here.
		*/
		prepareProfileView()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// General Preparation Statements
	private func prepareView() {
		view.backgroundColor = MaterialColor.grey.darken4
	}
	
	// Add Navigation Options
	private func prepareCells() {
		items.append(Item(text: "Home", imageName: "Home"))
		items.append(Item(text: "User Profile", imageName: "Star"))
		items.append(Item(text: "Settings", imageName: "Settings"))
	}
	
	// Prepare profile view
	private func prepareProfileView() {
		let backgroundView: MaterialView = MaterialView()
		backgroundView.image = UIImage(named: "MaterialBackground")
		
		// Profile Picture
		let profileView: MaterialView = MaterialView()
		profileView.image = UIImage(named: "Profile")?.resize(toWidth: 72)
		profileView.backgroundColor = MaterialColor.clear
		profileView.shape = .Circle
		profileView.borderColor = MaterialColor.white
		profileView.borderWidth = 3
		view.addSubview(profileView)
		
		// Profile Name, Get from storage
		let saveData = NSUserDefaults.standardUserDefaults()
		let nameLabel: UILabel = UILabel()
		nameLabel.text = ""
		nameLabel.text = saveData.stringForKey("userName")
		nameLabel.textColor = MaterialColor.white
		nameLabel.font = RobotoFont.mediumWithSize(18)
		view.addSubview(nameLabel)
		
		// Layout Stuff
		profileView.translatesAutoresizingMaskIntoConstraints = false
		
		MaterialLayout.alignFromTopLeft(view, child: profileView, top: 30, left: (view.bounds.width - 72) / 2)
		MaterialLayout.size(view, child: profileView, width: 72, height: 72)
		
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: nameLabel, top: 130)
		MaterialLayout.alignToParentHorizontally(view, child: nameLabel, left: 20, right: 20)
	}
	
	// Load tableView
	private func prepareTableView() {
		tableView.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "MaterialTableViewCell")
		tableView.backgroundColor = MaterialColor.clear
		// This Class will handle data source (Extended below)
		tableView.dataSource = self
		tableView.delegate = self
		// No Separators for empty rows
		tableView.tableFooterView = UIView(frame: CGRectZero)
		
		// Layout page
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignToParent(view, child: tableView, top: 170)
	}
}

// Extends TableView Properties for Navigation Drawer
extension SideDrawerViewController: UITableViewDataSource {
	// Determines the number of rows in tableView
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	// Prepares cells inside tableView
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		// Setup current Cell
		let cell: MaterialTableViewCell = tableView.dequeueReusableCellWithIdentifier("MaterialTableViewCell", forIndexPath: indexPath) as! MaterialTableViewCell
		// Get Item in list
		let item: Item = items[indexPath.row]
		// Set Up cell format
		cell.textLabel!.text = item.text
		cell.textLabel!.textColor = MaterialColor.grey.lighten2
		cell.textLabel!.font = RobotoFont.medium
		cell.imageView!.image = UIImage(named: item.imageName)?.imageWithRenderingMode(.AlwaysTemplate)
		cell.imageView!.tintColor = MaterialColor.grey.lighten2
		cell.backgroundColor = MaterialColor.clear
		
		return cell
	}
	
}

/// Extends UITableViewDelegate
extension SideDrawerViewController: UITableViewDelegate {
	/// Sets the tableView cell height.
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 64
	}
	
	/// Transition to correct view
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let item: Item = items[indexPath.row]
		switch item.text {
		case "Home":
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let homeViewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
			sideNavigationController?.transitionFromRootViewController(homeViewController,duration: 1, options: .TransitionNone, animations: nil, completion: { [weak self] _ in self?.sideNavigationController?.closeLeftView()})
		case "User Profile":
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let userProfileViewController = storyboard.instantiateViewControllerWithIdentifier("UserProfile") as! UserProfileViewController
			sideNavigationController?.transitionFromRootViewController(userProfileViewController,duration: 1, options: .TransitionNone, animations: nil, completion: { [weak self] _ in self?.sideNavigationController?.closeLeftView()})
		case "Settings":
			sideNavigationController?.transitionFromRootViewController(SettingsViewController(),duration: 1, options: .TransitionNone, animations: nil, completion: { [weak self] _ in self?.sideNavigationController?.closeLeftView()})
		default:break
		}
		
	}
}
