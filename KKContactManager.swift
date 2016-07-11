//
//  KKContactManager.swift
//
//  Created by Kenan Karakecili on 06/05/16.
//  Copyright © 2016 Kenan Karakecili. All rights reserved.
//

import UIKit
import AddressBook

class KKContactManager {
  
  struct ContactItem {
    let name: String
    let lastname: String
    let phone: String?
    let email: String?
    let image: UIImage?
  }
  
  enum Message: String {
    case Success = "Contact added successfully."
    case Error = "You need to enable access to the contacts in settings."
    case AlreadyHave = "is already in your contacts."
  }
  
  private var contactItem: ContactItem?
  private var addressBookRef: ABAddressBook?
  
  func addContact(contactItem: ContactItem) {
    self.contactItem = contactItem
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
    let success = performAddingContact()
    let message = success ? Message.Success.rawValue : Message.Error.rawValue
    showMessageOnly(message)
  }
  
  private func checkIfExist() -> ABRecordRef? {
    let allContacts = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue() as [ABRecordRef]
    for contact in allContacts {
      let contactName = ABRecordCopyCompositeName(contact).takeRetainedValue() as String
      guard let myContactItem = contactItem else { return .None }
      if contactName == "\(myContactItem.name) \(myContactItem.lastname)" {
        return contact
      }
    }
    return .None
  }
  
  private func showContactExistsAlert(contact: ABRecordRef) {
    guard let myContactItem = contactItem else { return }
    showMessageOnly("\(myContactItem.name) \(myContactItem.lastname) \(Message.AlreadyHave.rawValue)")
  }
  
  private func performAddingContact() -> Bool {
    guard let myContactItem = contactItem else { return false }
    let contactToAdd = ABPersonCreate().takeRetainedValue()
    ABRecordSetValue(contactToAdd, kABPersonFirstNameProperty, myContactItem.name, nil)
    ABRecordSetValue(contactToAdd, kABPersonLastNameProperty, myContactItem.lastname, nil)
    if let myImage = myContactItem.image {
      ABPersonSetImageData(contactToAdd, UIImagePNGRepresentation(myImage), nil)
    }
    let phoneNumbers = ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
    ABMultiValueAddValueAndLabel(phoneNumbers, myContactItem.phone, kABPersonPhoneMainLabel, nil)
    ABRecordSetValue(contactToAdd, kABPersonPhoneProperty, phoneNumbers, nil)
    let emails = ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
    ABMultiValueAddValueAndLabel(emails, myContactItem.email, kABWorkLabel, nil)
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
    guard let myContactItem = contactItem else { return }
    ABAddressBookRequestAccessWithCompletion(addressBookRef) { (granted, error) in
      dispatch_async(dispatch_get_main_queue()) {
        if granted == false {
          showMessageOnly(Message.Error.rawValue)
        } else {
          self.addContact(myContactItem)
        }
      }
    }
  }
  
}
