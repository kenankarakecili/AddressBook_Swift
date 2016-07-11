//
//  ContactManager.swift
//
//  Created by Kenan Karakecili on 06/05/16.
//  Copyright © 2016 Kenan Karakecili. All rights reserved.
//

import UIKit
import AddressBook

class ContactManager {
  
  enum Message: String {
    case Success = "Contact added successfully."
    case Error = "You need to enable access to the contacts in settings."
    case AlreadyHave = "is already in your contacts."
  }
  
  private var item = (name: "", lastname: "", phone: "", email: "", image: UIImage(named: ""))
  private var addressBookRef: ABAddressBook?
  
  func addContact(name: String, lastname: String, phone: String, email: String, image: UIImage?) {
    item.name = name
    item.lastname = lastname
    item.phone = phone
    item.email = email
    item.image = image
    let authorizationStatus = ABAddressBookGetAuthorizationStatus()
    switch authorizationStatus {
    case .Denied:
      showMessageOnly(Message.Error.rawValue)
    case .Authorized:
      addressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
      addItemToContacts()
    case .NotDetermined:
      promptForAddressBookAccess()
    default:
      break
    }
  }
  
  private func addItemToContacts() {
    if let existingContact = checkIfExist() {
      showContactExistsAlert(existingContact)
      return
    }
    let processSuccessful = performAddingContact()
    if processSuccessful {
      showMessageOnly(Message.Success.rawValue)
    } else {
      showMessageOnly(Message.Error.rawValue)
    }
  }
  
  private func checkIfExist() -> ABRecordRef? {
    let allContacts = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue() as [ABRecordRef]
    for contact in allContacts {
      let contactName = ABRecordCopyCompositeName(contact).takeRetainedValue() as String
      if contactName == "\(item.name) \(item.lastname)" {
        return contact
      }
    }
    return nil
  }
  
  private func showContactExistsAlert(contact: ABRecordRef) {
    let contactName = ABRecordCopyValue(contact, kABPersonFirstNameProperty).takeRetainedValue() as? String ?? item.name
    showMessageOnly("\(contactName) \(Message.AlreadyHave.rawValue)")
  }
  
  private func performAddingContact() -> Bool {
    let contactToAdd = ABPersonCreate().takeRetainedValue()
    ABRecordSetValue(contactToAdd, kABPersonFirstNameProperty, item.name, nil)
    ABRecordSetValue(contactToAdd, kABPersonLastNameProperty, item.lastname, nil)
    if let myImage = item.image {
      ABPersonSetImageData(contactToAdd, UIImagePNGRepresentation(myImage), nil)
    }
    let phoneNumbers = ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
    ABMultiValueAddValueAndLabel(phoneNumbers, item.phone, kABPersonPhoneMainLabel, nil)
    ABRecordSetValue(contactToAdd, kABPersonPhoneProperty, phoneNumbers, nil)
    let emails = ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
    ABMultiValueAddValueAndLabel(emails, item.email, kABWorkLabel, nil)
    ABRecordSetValue(contactToAdd, kABPersonEmailProperty, emails, nil)
    ABAddressBookAddRecord(addressBookRef, contactToAdd, nil)
    if ABAddressBookHasUnsavedChanges(addressBookRef) {
      let savedToAddressBook = ABAddressBookSave(addressBookRef, nil)
      if savedToAddressBook {
        return true
      }
      return false
    }
    return true
  }
  
  private func promptForAddressBookAccess() {
    ABAddressBookRequestAccessWithCompletion(addressBookRef) { (granted, error) in
      dispatch_async(dispatch_get_main_queue()) {
        if granted == false {
          showMessageOnly(Message.Error.rawValue)
        } else {
          self.addContact(self.item.name,
                          lastname: self.item.lastname,
                          phone: self.item.phone,
                          email: self.item.email,
                          image: self.item.image)
        }
      }
    }
  }
  
}
