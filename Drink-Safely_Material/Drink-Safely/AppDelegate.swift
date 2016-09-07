//
//  AppDelegate.swift
//  Drink-Safely
//
//  Created by Matthew Liu on 4/17/16.
//  Copyright © 2016 Matthew Liu. All rights reserved.
//

import UIKit
import CoreLocation
import Material

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var locationManager: CLLocationManager?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// White Status Bar
		 UIApplication.sharedApplication().statusBarStyle = .LightContent
		
		// Request Location Permissions
		locationManager = CLLocationManager()
		locationManager?.requestAlwaysAuthorization()
		
		// Get View Controllers from storyboard
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		
		let sideViewController = storyboard.instantiateViewControllerWithIdentifier("SideDrawerViewController") as! SideDrawerViewController
		
		// Set up initial view with Side Drawer
		let rootViewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
		let sideDrawer: SideNavigationController = SideNavigationController(rootViewController: rootViewController, leftViewController: sideViewController)
		sideDrawer.setLeftViewWidth(280, hidden: true, animated: false)
		
		// Setup navigation drawer
		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		window?.rootViewController = sideDrawer
		window?.makeKeyAndVisible()
		let saveData = NSUserDefaults.standardUserDefaults()
		
		// Check if User Data is already in system, else present registration view
		if let _ = saveData.stringForKey("userName") {}
		else {
			let editProfileView = storyboard.instantiateViewControllerWithIdentifier("EditProfile") as! EditProfileViewController
			rootViewController.presentViewController(editProfileView, animated: true, completion: nil)
		}
		
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

}

