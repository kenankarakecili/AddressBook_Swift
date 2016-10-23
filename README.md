# KKAddressBook-Swift
A manager class that can add a new contact to the contact list in iPhone.

<kbd>
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg)](https://www.youtube.com/watch?v=YOUTUBE_VIDEO_ID_HERE)
</kbd>

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
