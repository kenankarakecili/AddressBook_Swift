# KKAddressBook-Swift
A manager class that can add a new contact to the contact list in iPhone.

![alt tag](https://raw.githubusercontent.com/KenanKarakecili/KKAddressBook-Swift/master/Untitled.mov)

#Importing

Just copy the ```KKAddressBook.swift``` file somewhere in your project.

#Usage

```
let contactToAdd = KKAddressBook.ContactItem(name: "Kenan",
                                            lastname: "Karakecili",
                                            phone: "+90 555 290 53 94",
                                            email: "kenankarakecili@icloud.com",
                                            image: myPicture)
KKAddressBook().addContact(contactToAdd)
```
