@RestResource(urlMapping='/Contracts/*')
global with sharing class ContractRestWS {
  //Post Create Contract
  @HttpPost
  global static ID createCrontact(
    String accountId,
    Date startDate,
    Integer contractTerm,
    String status
  ) {
    Contract newContract = new Contract(
      AccountId = accountId,
      StartDate = startDate,
      ContractTerm = contractTerm,
      Status = status
    );

    insert newContract;

    return newContract.Id;
  }

  //Patch Update Contract
  @HttpPatch
  global static ID updateContract() {
    RestRequest request = RestContext.request;
    String contractId = request.requestURI.substring(
      request.requestURI.lastIndexOf('/') + 1
    );

    Contract contract = [SELECT Id FROM Contract WHERE Id = :contractId];

    // Deserialize the JSON string into name-value pairs
    Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
      request.requestbody.tostring()
    );

    // Iterate through each parameter field and value
    for (String fieldName : params.keySet()) {
      // Set the field and value on the Contract sObject
      contract.put(fieldName, params.get(fieldName));
    }

    update contract;

    return contract.Id;
  }
}
