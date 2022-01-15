@RestResource(urlMapping='/Account/*')
global with sharing class restAccount {
   @HttpGET
   global static list<Account> getAccount()
   {
       return [Select Id, Name, DNI__c, AccountNUmber From Account];
   }

   @HttpPost
   global static string postAccount(String DNI, String nombre) {

    String respuesta = null;

    try{
        Account cuenta = new Account();
        cuenta.Name = nombre;
        cuenta.DNI__c = DNI;
              
        insert cuenta;

        respuesta = 'Cliente creado correctamente. Codigo 200';
    }
    catch (Exception e){
        ManejoErrores.registrarError(e);
    }

    String pasos = 'Pre Alta Datos';
    String camposCambian = 'Account: Name, DNI__c';
    String oldValues = '';
    String newValues = nombre + ', ' + DNI;
    String origenCambio = 'POST Account';
    ManejoTrazabilidad.actualizarTrazabilidad('', camposCambian, false, newValues, oldValues, origenCambio, pasos, false);

    try{
        String idCliente = [SELECT ID FROM Account WHERE DNI__c = :DNI].Id;

        Case objOnb = new Case();
        objOnb.Pasos__c = 'Pre Alta Datos';
        objOnb.DNI__c = DNI;
        objOnb.Activo__c = true;
        objOnb.Process_Type__c = 'Onboarding';
        objOnb.Landing_Version__c = '1.0';
        objOnb.Legal_Documents_Version__c = '1.0';
        objOnb.ONB_utm_content__c = '';
        objOnb.ONB_utm_source__c = '';
        objOnb.ONB_utm_medium__c = '';
        objOnb.ONB_utm_term__c = '';
        objOnb.ONB_utm_campaign__c = ''; 
        objOnb.ONB_Analytics_ID__c = '';
        objOnb.ONB_ID_Session__c = idCliente;
        objOnb.ONB_Google_Analytics_Link__c = '';
        objOnb.Cuenta_referencia__c = idCliente;

        insert objOnb;

        camposCambian = 'Case: Pasos__c, DNI__c, Activo__c' +
            'Landing_Version__c, Legal_Documents_Version__c, ONB_utm_content__c, ONB_utm_source__c' +
            'ONB_utm_medium__c, ONB_utm_term__c, ONB_utm_campaign__c, ONB_Analytics_ID__c, ' + 
            'ONB_ID_Session__c, ONB_Google_Analytics_Link__c, Cuenta_referencia__c';
        oldValues = '';
        newValues = objOnb.Pasos__c + ', ' + objOnb.DNI__c + ', ' + objOnb.Activo__c + ', ' +
        objOnb.Landing_Version__c + ', ' + objOnb.Legal_Documents_Version__c + ', ' +
        objOnb.ONB_utm_content__c + ', ' + objOnb.ONB_utm_source__c + ', ' +
        objOnb.ONB_utm_medium__c + ', ' + objOnb.ONB_utm_term__c + ', ' +
        objOnb.ONB_utm_campaign__c + ', ' + objOnb.ONB_Analytics_ID__c + ', ' +
        objOnb.ONB_ID_Session__c + ', ' + objOnb.ONB_Google_Analytics_Link__c + ', ' +
        objOnb.Cuenta_referencia__c;
        origenCambio = 'insert Case';
        ManejoTrazabilidad.actualizarTrazabilidad('', camposCambian, false, newValues, oldValues, origenCambio, pasos, false);
    }
    catch(Exception e) {  
        System.debug(e.getMessage());
        ManejoErrores.registrarError(e);
    }

    return respuesta;
    }

   @HttpPut
   global static string putAccount(String Nombre, String DNI )
   {
        Account cliente = new Account();
        try{
            cliente = [Select Name, id, DNI__c FROM Account Where DNI__c = :DNI];
            cliente.Name = Nombre;
            update cliente;
            return JSON.serializePretty(cliente);
        }catch(Exception e)
        {
            RestContext.response.statusCode = 400;
            SalesforceError[] errs = new SalesforceError[]{ 
                new SalesforceError('BAD_REQUEST', 'Param: DNI NO EXISTE EN LA BASE DE DATOS')
                };
            RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(errs));
            return JSON.serializePretty(errs);
        }   
   }

}
