public with sharing class ManejoTrazabilidad {
    
    public static void actualizarTrazabilidad(String alertas, String campos, Boolean envioEmail, String newValue, String oldValue, String origenCambio, String pasos, Boolean envioSMS) {

        Trazabilidad_Onboarding__c traza = new Trazabilidad_Onboarding__c();

        traza.Alertas_internas__c = alertas;
        traza.Campo_cambio__c = campos;
        traza.Envio_email__c = envioEmail;
        traza.Fecha_cambio__c = Date.today();
        traza.NewValue__c = newValue;
        traza.OldValue__c = oldValue;
        traza.Origen_cambio__c = origenCambio;
        traza.Paso_Onboarding__c = pasos;
        traza.SMS__c = envioSMS;

        insert traza;
    }
}

