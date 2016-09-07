//
//  ViewController.swift
//  Test
//
//  Created by Matthew Liu on 4/10/16.
//  Copyright © 2016 Matthew Liu. All rights reserved.
//
//	MapKit Tutorial: http://www.techotopia.com/index.php/Working_with_Maps_on_iOS_8_with_Swift,_MapKit_and_the_MKMapView_Class
//

import UIKit
import EventKit
import MapKit
import Material
import MessageUI

class PartyViewController: UIViewController, MKMapViewDelegate, MFMessageComposeViewControllerDelegate {

	// Map View
	@IBOutlet weak var mapView: MKMapView!
	var timer: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Enable User Location
		mapView.showsUserLocation = true
		mapView.delegate = self
		
		// Material ToolBar
		addToolbar()
		
		// Temporary standin. Change so you can pick in settings
//		timer = 10
		
		// Party Mode Condition Tracker
		startTimer()

		// Start Timer after User Test
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PartyViewController.startTimer), name:"startTimer", object: nil)
		// Failed User Test, send SOS
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PartyViewController.emergency), name:"sos", object: nil)
	}
	
	func startTimer() {
		print("Start Timer")
		let timerLength:Int? = Int(NSUserDefaults.standardUserDefaults().stringForKey("timerLength")!)
		timer = timerLength!
		print(timer)
		_ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(PartyViewController.updateTimer), userInfo: nil, repeats: true)
	}
	
	func emergency() {
		// User Failed Test, send texts and restart timer
		self.startTimer()
		self.sendText()
	}
	
	func updateTimer(systemTimer: NSTimer) {
		if (timer > 0) {
			print(timer)
			timer -= 1
		} else if (timer <= 0) {
			let checkUser = UIAlertController(title: "Alert:", message: "You will be presented with a simple math question to check for consciousness.", preferredStyle: .Alert)
			let defaultAction = UIAlertAction(title: "Ok", style: .Default) {
				(alert: UIAlertAction!) -> Void in NSLog("Segue to Math Question")
				
				// Segue to Math Question
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let UserTestView = storyboard.instantiateViewControllerWithIdentifier("UserTest") as! UserTestViewController
				self.presentViewController(UserTestView, animated: true, completion: nil)
			}
			// Adds Button to Alert
			checkUser.addAction(defaultAction)
			// Adds Alert to View
			presentViewController(checkUser, animated: true, completion: nil)
			// reset timer
			timer = 10
			systemTimer.invalidate()
		}
	}
	
	func addToolbar() {
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Party"
		titleLabel.textAlignment = .Left
		titleLabel.textColor = MaterialColor.white
		
		var image: UIImage? = UIImage(named:"Menu")
		
		// In theory if user is in party mode, they would not need to open up and look at these other features.
		// Also unsure how to tie in side bar into this view, will reintroduce later.
		// Menu button.
		let menuButton: FlatButton = FlatButton()
		menuButton.pulseColor = MaterialColor.white
		menuButton.pulseScale = false
		menuButton.tintColor = MaterialColor.white
		menuButton.setImage(image, forState: .Normal)
		menuButton.setImage(image, forState: .Highlighted)
		menuButton.addTarget(self, action: #selector(PartyViewController.toggleNavigationDrawer), forControlEvents: .TouchUpInside)
		

		// Search button.
		image = UIImage(named:"Search")
		let searchButton: FlatButton = FlatButton()
		searchButton.pulseColor = MaterialColor.white
		searchButton.pulseScale = false
		searchButton.tintColor = MaterialColor.white
		searchButton.setImage(image, forState: .Normal)
		searchButton.setImage(image, forState: .Highlighted)
		searchButton.addTarget(self, action: #selector(PartyViewController.openSearchBar(_:)), forControlEvents: .TouchUpInside)
		
		let toolbar: Toolbar = Toolbar()
		toolbar.statusBarStyle = .LightContent
		toolbar.backgroundColor = MaterialColor.deepOrange.base
		toolbar.titleLabel = titleLabel
		toolbar.leftControls = [menuButton]
		// TODO: Finish Search Bar Functionality
		// Tutorial: http://sweettutos.com/2015/04/24/swift-mapkit-tutorial-series-how-to-search-a-place-address-or-poi-in-the-map/
		//		toolbar.rightControls = [searchButton]
		
		view.addSubview(toolbar)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
/// MARK: Map Stuff
	/// Center User on Map
	func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
		mapView.centerCoordinate = (userLocation.location?.coordinate)!
	}
	
	func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
		let location = locations.last as! CLLocation
		
		let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
		let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
		
		mapView.setRegion(region, animated: true)
	}
	
	// MARK: SMS Texting
	func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
		switch result.rawValue {
		case MessageComposeResultCancelled.rawValue :
			print("message canceled")
		case MessageComposeResultFailed.rawValue :
			print("message failed")
		case MessageComposeResultSent.rawValue :
			print("message sent")
		default:
			break
		}
		// Dismiss the mail compose view controller
		controller.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
/// MARK: Calendar
	// Creates an event in the EKEventStore. The method assumes the eventStore is created and accessible
	private func addPartyEventToCalendar() {
		// Initializes EventStorage
		let eventStore = EKEventStore()
		
		// Checks for Permissions
		if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
			eventStore.requestAccessToEntityType(.Event, completion: {
				granted, error in
				self.addEvent(eventStore)
			})
		} else {
			addEvent(eventStore)
		}
	}
	
	private func addEvent(eventStore: EKEventStore) {
		let event = EKEvent(eventStore: eventStore)
		
		let saveData = NSUserDefaults.standardUserDefaults()
		let startDateString = saveData.stringForKey("startTime")
		print(startDateString)
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
		let startDate = dateFormatter.dateFromString(startDateString!)
		let endDate = NSDate()
		
		event.title = "Party Mode"
		event.startDate = startDate!
		event.endDate = endDate
		event.calendar = eventStore.defaultCalendarForNewEvents
		do {
			try eventStore.saveEvent(event, span: .ThisEvent)
		} catch {
			print("Failed to add event")
		}
	}

	
/// MARK: Buttons
	/**
	* Toggles Navigation Drawer
	**/
	func toggleNavigationDrawer() {
		sideNavigationController?.toggleLeftView()
	}
	
	/**
	* Search Bar Functionality
	* Material Search Bar
	**/
	func openSearchBar(sender: FlatButton) {
		print("Search")
	}
	
	/**
	* Dismisses Search Bar
	**/
	private func exitSearch() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	/**
	* MapKit Zoom Function
	* Zoom In on User's Location
	**/
	@IBAction func zoomIn(sender: FabButton) {
		// Get User Location
		let userLocation = mapView.userLocation
		
		let region = MKCoordinateRegionMakeWithDistance((userLocation.location?.coordinate)!, 2000, 2000)
		mapView.setRegion(region, animated: true)
	}
	
	/**
	* I Am Home Button Functinonlity
	*
	**/
	@IBAction func amHome(sender: AnyObject) {
		
		let amHome = UIAlertController(title: "Warning:", message: "Are you safe at home?", preferredStyle: .Alert)
		
		let defaultAction = UIAlertAction(title: "NO!", style: .Default) { (alert: UIAlertAction!) -> Void in NSLog("NO: Returning to party mode") }
		
		// Return to Home Page
		let secondaryAction = UIAlertAction(title: "YES...", style: .Default) {
			(alert: UIAlertAction!) -> Void in NSLog("You got home")
			
			self.addPartyEventToCalendar()
			
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let homeViewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
			self.sideNavigationController?.transitionFromRootViewController(homeViewController,duration: 1, options: .TransitionNone, animations: nil, completion: nil)
			return
		}
		
		// Adds Button to Alert
		amHome.addAction(defaultAction)
		amHome.addAction(secondaryAction)
		
		// Adds Alert to View
		presentViewController(amHome, animated: true, completion: nil)

	}
	
	/**
	* SOS SMS Message
	* Confirm that User want's to send SMS to Emergency Contacts
	**/
	@IBAction func sosText(sender: RaisedButton) {
		let sosAlert = UIAlertController(title: "Warning:", message: "You are about to send SMS messages to emergency contacts. Are you sure?", preferredStyle: .Alert)
		
		let defaultAction = UIAlertAction(title: "NO!", style: .Default) { (alert: UIAlertAction!) -> Void in NSLog("NO: Returning to party mode") }
		
		// Send SOS Message
		let secondaryAction = UIAlertAction(title: "YES!", style: .Default) {
			(alert: UIAlertAction!) -> Void in NSLog("You Sent SOS SMS")
			
			// Send SMS
			self.sendText()
		}
		
		// Adds Button to Alert
		sosAlert.addAction(defaultAction)
		sosAlert.addAction(secondaryAction)
		
		// Adds Alert to View
		presentViewController(sosAlert, animated: true, completion: nil)
	}
	
	func sendText() {
		if !MFMessageComposeViewController.canSendText() {
			print("SMS services are not available")
		} else {
			let composeVC = MFMessageComposeViewController()
			composeVC.messageComposeDelegate = self
			
			// Text Emergency Contacts
			let saveData = NSUserDefaults.standardUserDefaults()
			composeVC.recipients = [saveData.stringForKey("emergencyPhoneNumber")!]
			composeVC.body = "Help I Am Intoxicated!"
			
			// Present the view controller modally
			self.presentViewController(composeVC, animated: true, completion: nil)
		}
	}
}

