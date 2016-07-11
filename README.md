# ContactManager_Swift
A manager class that can add a new contact to the contact list in iPhone.

#Importing

Just copy the ```ContactManager.swift``` file somewhere in your project.

#Usage

```
let contactToAdd = ContactManager.ContactItem(name: "Kenan",
                                              lastname: "Karakecili",
                                              phone: "+90 555 290 53 94",
                                              email: "kenankarakecili@icloud.com",
                                              image: myPicture)
ContactManager().addContact(contactToAdd)
```
