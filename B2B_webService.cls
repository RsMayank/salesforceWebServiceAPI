@RestResource(urlMapping='/Inventory__c/*')
global without Sharing class B2B_webService {
        @HttpGet
        global static Inventory__c getInventory(){
            
            RestRequest request = RestContext.request;
            RestResponse response = RestContext.response;
            String InventoryId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);                
            Inventory__c result = [SELECT Id, status__c,Available_for_Purchase__c,
                                    Reserved__c FROM Inventory__c WHERE ProductItem__c =:InventoryId];
            return result;  
        } 
        @HttpPatch
        global static Inventory__c updateInventory()
        {
            RestRequest req = RestContext.request;
            String inventoryId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            Inventory__c inventory = [SELECT Id,Reserved__c FROM Inventory__c 
                                          WHERE ProductItem__r.StockKeepingUnit = :inventoryId];
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(req.requestBody.toString());
            for(String fieldName : params.KeySet())
            {
                Inventory.put(fieldName, params.get(fieldName));
            }
            update inventory;
            return inventory;
        }
    
}
