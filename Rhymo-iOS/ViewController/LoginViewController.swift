//
//  LoginViewController.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 12/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

let LoginContentNibName = "LoginContent"
let LoginEmailTag = 21
let LoginPasswordTag = 22
let loginButtonTag = 40

class LoginViewController: UIViewController, UITextFieldDelegate {
  
  var eventHandler: LoginPresenter?
  
  var emailField: UITextField?
  var passwordField: UITextField?

  @IBOutlet weak var contentView: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Get the content of Login screen from a nib file
    let loginContent = NSBundle.mainBundle().loadNibNamed(LoginContentNibName, owner: self, options: nil)[0] as UIView
    
    // Find email and passwords fields in it
    emailField = loginContent.viewWithTag(LoginEmailTag) as? UITextField
    passwordField = loginContent.viewWithTag(LoginPasswordTag) as? UITextField
    
    let loginButton = loginContent.viewWithTag(loginButtonTag) as? UIButton
    loginButton?.addTarget(self, action: "loginButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    
    // set this VC as delegate
    emailField?.delegate = self
    passwordField?.delegate = self
    
    contentView.addSubview(loginContent)
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  }
    

  @IBAction func cancelButtonPressed(sender: AnyObject) {
    emailField?.resignFirstResponder()
    passwordField?.resignFirstResponder()
    eventHandler?.cancel()
  }
  
  func loginButtonPressed(sender: UIButton!) {
    eventHandler?.login(email: emailField!.text, password: passwordField!.text)
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  // MARK: - UITextView management
  
  func textFieldDidBeginEditing(textField: UITextField) {

  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    // switch to the next field or submit the form when the user taps return
    if(textField.tag == LoginEmailTag) {
      passwordField?.becomeFirstResponder()
    }
    else {
      textField.resignFirstResponder()
      eventHandler?.login(email: emailField!.text, password: passwordField!.text)
    }
    return true
  }
  
  
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
  }


}
