# ContactManager_Swift
A manager class that can add a new contact to the contact list in iPhone.

#Importing

Just copy the ```ContactManager.swift``` file somewhere in your project.

#Usage

```
let contactToAdd = ContactManager.ContactItem(name: name,
                                              lastname: lastname!,
                                              phone: item.mobile,
                                              email: item.email,
                                              image: decodeBase64ToImage(item.picture))
ContactManager().addContact(contactToAdd)
```
