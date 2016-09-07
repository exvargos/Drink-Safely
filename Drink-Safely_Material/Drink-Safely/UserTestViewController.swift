//
//  UserTestViewController.swift
//  Drink-Safely
//
//  Created by Matthew Liu on 5/2/16.
//  Copyright © 2016 Matthew Liu. All rights reserved.
//

import UIKit
import Material

class UserTestViewController: UIViewController {

	@IBOutlet weak var userAnswer: TextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		view.backgroundColor = MaterialColor.deepOrange.darken1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	@IBAction func checkAnswer(sender: RaisedButton) {
		// Convert String to text
		let answer:Int? = Int(userAnswer.text!)
		// Check Correct Answer, currently just placeholder
		if answer == 56 {
			// Go Back to Party View
			self.dismissViewControllerAnimated(true, completion: nil)
			NSNotificationCenter.defaultCenter().postNotificationName("startTimer", object: nil)
		} else {
			let checkUser = UIAlertController(title: "Warning:", message: "You got the answer wrong. The App will now contact emergency contacts", preferredStyle: .Alert)
			let defaultAction = UIAlertAction(title: "Ok", style: .Default) {
				(alert: UIAlertAction!) -> Void in NSLog("Message Emergency Contacts")
				
				self.dismissViewControllerAnimated(true, completion: nil)
				NSNotificationCenter.defaultCenter().postNotificationName("sos", object: nil)
				return
			}
			
			// Adds Button to Alert
			checkUser.addAction(defaultAction)
			// Adds Alert to View
			presentViewController(checkUser, animated: true, completion: nil)
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
