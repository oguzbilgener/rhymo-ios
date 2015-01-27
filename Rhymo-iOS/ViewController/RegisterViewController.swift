//
//  RegisterViewController.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 12/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

let RegisterContentNibName = "RegisterContent"
let RegisterEmailTag = 21
let RegisterPasswordTag = 22
let RegisterButtonTag = 40

class RegisterViewController: BaseViewController, UITextFieldDelegate {
  
  var eventHandler: RegisterPresenter?
  
  var emailField: UITextField?
  var passwordField: UITextField?
  var modalDelegate: LandingModalDelegate?
  @IBOutlet weak var navigationBar: UINavigationBar!

  @IBOutlet weak var contentView: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    navigationBar.shadowImage = UIImage()
    navigationBar.translucent = true
    
    // Get the content of Login screen from a nib file
    let registerContent = NSBundle.mainBundle().loadNibNamed(RegisterContentNibName, owner: self, options: nil)[0] as UIView
    
    
    // Find email and passwords fields in it
    emailField = registerContent.viewWithTag(RegisterEmailTag) as? UITextField
    passwordField = registerContent.viewWithTag(RegisterPasswordTag) as? UITextField
    
    let registerButton = registerContent.viewWithTag(RegisterButtonTag) as? UIButton
    registerButton?.addTarget(self, action: "registerButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    
    
    // set this VC as delegate
    emailField?.delegate = self
    passwordField?.delegate = self
    
    contentView.addSubview(registerContent)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  @IBAction func cancelButtonPressed(sender: AnyObject) {
    emailField?.resignFirstResponder()
    passwordField?.resignFirstResponder()
    if let delegate = modalDelegate {
      delegate.didDismissModal(sender)
    }
    eventHandler?.cancel()
  }
  
  func registerButtonPressed(sender: UIButton!) {
    emailField?.resignFirstResponder()
    passwordField?.resignFirstResponder()
    eventHandler?.register(email: emailField!.text, password: passwordField!.text)
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
      eventHandler?.register(email: emailField!.text, password: passwordField!.text)
    }
    return true
  }
  
  func textFieldShouldClear(textField: UITextField) -> Bool {
    if(textField.tag == LoginEmailTag) {
      passwordField?.text = ""
    }
    return true
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
