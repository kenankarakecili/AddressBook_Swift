# KKContactManager_Swift
A manager class that can add a new contact to the contact list in iPhone.

#Importing

Just copy the ```KKContactManager.swift``` file somewhere in your project.

#Usage

```
let contactToAdd = KKContactManager.ContactItem(name: "Kenan",
                                                lastname: "Karakecili",
                                                phone: "+90 555 290 53 94",
                                                email: "kenankarakecili@icloud.com",
                                                image: myPicture)
KKContactManager().addContact(contactToAdd)
```
