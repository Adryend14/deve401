@RestResource(urlMapping='/Onboarding/*')
global with sharing class RestOnboarding 
{
    @HttpPOST

    global static string postTareaLlamada(List<Case> lstCases)
    {
        string respuesta = '';
        List<Account> cliente = new List<Account>();
        try{
            Task t = new Task(); 
            cliente = [SELECT Name, Id FROM Account WHERE Phone = :lstCases[0].ContactPhone];
            t.Subject = 'Call'; 
            //t.WhoId = cliente[0].Id; 
            //t.WhatId = proceso; 
            t.Type = 'Call'; 
            t.Description = 'Devolver llamada al cliente ' + cliente[0].Name + ' al telefono ' + lstCases[0].ContactPhone;
            
            insert t;
            RestContext.response.statusCode = 201;
            respuesta = 'Tarea creada. Codigo ' +  RestContext.response.statusCode;
        }catch(Exception e)
        {
            RestContext.response.statusCode = 400;
            Error_Log__c err = new Error_Log__c();
            err.Error__c = '400';
            respuesta = 'Codigo ' + RestContext.response.statusCode + '. Error: ' + e.getMessage();
        }   

        return respuesta;
    }

}