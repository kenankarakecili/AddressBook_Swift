//
//  KKAddressBook.swift
//
//  Created by Kenan Karakecili on 06/05/16.
//  Copyright © 2016 Kenan Karakecili. All rights reserved.
//

import UIKit
import AddressBook

class KKAddressBook {
  
  struct ContactItem {
    let name: String
    let lastname: String
    let phone: String?
    let email: String?
    let image: UIImage?
  }
  
  fileprivate enum Message: String {
    case Success = "Contact added successfully."
    case Error = "You need to enable access to the contacts in settings."
    case AlreadyHave = "is already in your contacts."
  }
  
  fileprivate var contactItem: ContactItem?
  fileprivate var addressBookRef: ABAddressBook?
  
  func addContact(_ contactItem: ContactItem) {
    self.contactItem = contactItem
    let authorizationStatus = ABAddressBookGetAuthorizationStatus()
    switch authorizationStatus {
    case .denied:
      ViewController().showMessageOnly(Message.Error.rawValue)
    case .authorized:
      addressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
      addItemToContacts()
    case .notDetermined:
      promptForAddressBookAccess()
    default:
      break
    }
  }
  
  fileprivate func addItemToContacts() {
    if let existingContact = checkIfExist() {
      showContactExistsAlert(existingContact)
      return
    }
    let success = performAddingContact()
    let message = success ? Message.Success.rawValue : Message.Error.rawValue
    ViewController().showMessageOnly(message)
  }
  
  fileprivate func checkIfExist() -> ABRecord? {
    let allContacts = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue() as [ABRecord]
    for contact in allContacts {
      guard let compositeName = ABRecordCopyCompositeName(contact) else { continue }
      let contactName = compositeName.takeRetainedValue() as String
      guard let myContactItem = contactItem else { return .none }
      if contactName == "\(myContactItem.name) \(myContactItem.lastname)" {
        return contact
      }
    }
    return .none
  }
  
  fileprivate func showContactExistsAlert(_ contact: ABRecord) {
    guard let myContactItem = contactItem else { return }
    ViewController().showMessageOnly("\(myContactItem.name) \(myContactItem.lastname) \(Message.AlreadyHave.rawValue)")
  }
  
  fileprivate func performAddingContact() -> Bool {
    guard let myContactItem = contactItem else { return false }
    let contactToAdd = ABPersonCreate().takeRetainedValue()
    ABRecordSetValue(contactToAdd, kABPersonFirstNameProperty, myContactItem.name as CFTypeRef!, nil)
    ABRecordSetValue(contactToAdd, kABPersonLastNameProperty, myContactItem.lastname as CFTypeRef!, nil)
    if let myImage = myContactItem.image {
      ABPersonSetImageData(contactToAdd, UIImagePNGRepresentation(myImage) as CFData!, nil)
    }
    let phoneNumbers = ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
    ABMultiValueAddValueAndLabel(phoneNumbers, myContactItem.phone as CFTypeRef!, kABPersonPhoneMainLabel, nil)
    ABRecordSetValue(contactToAdd, kABPersonPhoneProperty, phoneNumbers, nil)
    let emails = ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
    ABMultiValueAddValueAndLabel(emails, myContactItem.email as CFTypeRef!, kABWorkLabel, nil)
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
  
  fileprivate func promptForAddressBookAccess() {
    guard let myContactItem = contactItem else { return }
    ABAddressBookRequestAccessWithCompletion(addressBookRef) { (granted, error) in
      DispatchQueue.main.async {
        if granted == false {
          ViewController().showMessageOnly(Message.Error.rawValue)
        } else {
          self.addContact(myContactItem)
        }
      }
    }
  }
  
}

