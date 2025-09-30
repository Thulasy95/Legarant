@RestResource(urlMapping='/Contacts/*')
global with sharing class ContactRestWS {
  //Get Query
  @HttpGet
  global static Contact getContactByEmail() {
    RestRequest request = RestContext.request;
    String contactEmail = request.requestURI.substring(
      request.requestURI.lastIndexOf('/') + 1
    );
    Contact result = [
      SELECT Id, Email, FirstName, LastName, isActive__c
      FROM Contact
      WHERE Email = :contactEmail
    ];

    return result;
  }

  //Post Create Contact
  @HttpPost
  global static ID createContact(
    String email,
    String firstName,
    String lastName
  ) {
    List<Contact> contacts = [
      SELECT Id, Email, FirstName, LastName
      FROM Contact
      WHERE Email = :email
    ];

    if (contacts.isEmpty()) {
      //Create Contact
      Contact newContact = new Contact(
        Email = email,
        FirstName = firstName,
        LastName = lastName
      );

      insert newContact;

      return newContact.Id;
    } else {
      //Update Contact
      Contact contactExist = contacts[0];
      contactExist.Email = email;
      contactExist.FirstName = firstName;
      contactExist.LastName = lastName;

      update contactExist;

      return contactExist.Id;
    }
  }

  //Patch Update Contact
  @HttpPatch
  global static ID updateContact() {
    RestRequest request = RestContext.request;
    String contactId = request.requestURI.substring(
      request.requestURI.lastIndexOf('/') + 1
    );

    Contact contact = [SELECT Id FROM Contact WHERE Id = :contactId];

    // Deserialize the JSON string into name-value pairs
    Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
      request.requestbody.tostring()
    );

    // Iterate through each parameter field and value
    for (String fieldName : params.keySet()) {
      // Set the field and value on the Contact sObject
      contact.put(fieldName, params.get(fieldName));
    }

    update contact;

    return contact.Id;
  }

  //Delete Disable Contact
  @HttpDelete
  global static void deleteContact() {
    RestRequest request = RestContext.request;
    String contactId = request.requestURI.substring(
      request.requestURI.lastIndexOf('/') + 1
    );

    Contact contact = [
      SELECT Id, isActive__c
      FROM Contact
      WHERE Id = :contactId
    ];

    contact.isActive__c = false;

    update contact;
  }
}
