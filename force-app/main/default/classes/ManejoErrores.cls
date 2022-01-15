public with sharing class ManejoErrores {
  
    public static void registrarError(Exception e) {

        Id idPerfil = userinfo.getProfileId();
        String nombrePerfil = [Select Id,Name from Profile where Id = :idPerfil].Name;

        Error_Log__c error = new Error_Log__c();

        error.Causante__c = e.getMessage();
        String stack_trace = e.getStackTraceString();
        error.Clase__c = stack_trace.substring(0, stack_trace.indexOf(':'));
        error.Critico__c = true;
        error.Error__c = e.getMessage();
        error.Numero_linea__c = e.getLineNumber();
        error.Perfil_usuario__c = nombrePerfil;
        error.Tipo_error__c = e.getTypeName();
        error.Usuario__c = userinfo.getName();


        insert error;
    }
}
