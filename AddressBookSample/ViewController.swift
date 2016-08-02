//
//  ViewController.swift
//  AddressBookSample
//
//  Created by Kenan Karakecili on 01/08/16.
//  Copyright © 2016 Kenan Karakecili. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var lastnameField: UITextField!
  @IBOutlet weak var phoneField: UITextField!
  @IBOutlet weak var emailField: UITextField!

  @IBAction func addContactButtonAction(sender: UIButton) {
    if !checkFields() { return }
    let contactToAdd = KKAddressBook.ContactItem(name: nameField.text!,
                                                 lastname: lastnameField.text!,
                                                 phone: phoneField.text,
                                                 email: emailField.text,
                                                 image: profileImageView.image)
    KKAddressBook().addContact(contactToAdd)
  }
  
  func checkFields() -> Bool {
    if nameField.text!.isEmpty {
      showMessageOnly("Please enter your name.")
      return false
    } else if lastnameField.text!.isEmpty {
      showMessageOnly("Please enter your lastname.")
      return false
    }
    return true
  }
  
  func showMessageOnly(message: String) {
    let alert = UIAlertController(title: "",
                                  message: message,
                                  preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
    presentViewController(alert, animated: true, completion: nil)
  }
  
}

