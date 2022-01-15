@RestResource(urlMapping='/Onboarding/*')
global with sharing class RestOnboarding 
{
    @HttpPATCH

    global static string patchDatosPersonales(String email, String telefono, String DNI, boolean advertisingShipping, boolean privacyPolicy) {

        Date fecha = Date.Today();
        String respuesta = '';

        try
        {
            List<Case> onboardings = [SELECT DNI__c, Pasos__c, Landing_Version__c,
            Legal_Documents_Version__c, ID__c, PersonEmail__c, I_Accept_the_Privacy_Policy__c, Privacy_Policy_Date__c,
            Transfer_of_data__c, Transfer_of_data_date__c, I_do_not_accept_advertising_shipping__c, Advertising_shipping_date__c,
            New_Conditions_Data_Use__c, New_Conditions_Data_Use_date__c, DNI_Validation__c, No_Entity_Information_Sources_date__c,
            DNI_Validation_date__c, Email_Validation__c, Cuenta_referencia__c FROM Case WHERE (DNI__c = :DNI)];

            Case objOnb = onboardings[0];
            
            String oldValues = '' + objOnb.Pasos__c + ', ' + objOnb.Landing_Version__c + ', ' +
            objOnb.Legal_Documents_Version__c + ', ' + objOnb.ID__c + ', ' + objOnb.PersonEmail__c + ', ' +
            objOnb.I_Accept_the_Privacy_Policy__c + ', ' + objOnb.Privacy_Policy_Date__c + ', ' +
            objOnb.Transfer_of_data__c + ', ' + objOnb.Transfer_of_data_date__c + ', ' +
            objOnb.I_do_not_accept_advertising_shipping__c + ', ' + objOnb.Advertising_shipping_date__c + ', ' +
            objOnb.New_Conditions_Data_Use__c + ', ' + objOnb.New_Conditions_Data_Use_date__c + ', ' +
            objOnb.DNI_Validation__c + ', ' + objOnb.No_Entity_Information_Sources_date__c + ', ' +
            objOnb.DNI_Validation_date__c + ', ' + objOnb.Email_Validation__c;

            String requestBody = '"PersonEmail__c" : "' + email + '", ' + '"I_Accept_the_Privacy_Policy__c" : ' + privacyPolicy + ', ' +
                '"Privacy_Policy_Date__c" : "' + fecha + '", ' + '"Transfer_of_data__c" : false, "Transfer_of_data_date__c" : "' + fecha + '", ' +
                '"I_do_not_accept_advertising_shipping__c" : ' + advertisingShipping + ', "Advertising_shipping_date__c" : "' + fecha + '", ' +
                '"New_Conditions_Data_Use__c" : false, "New_Conditions_Data_Use_date__c" : "' + fecha + '", ' +
                '"No_Entity_Information_Sources__c" : false, "No_Entity_Information_Sources_date__c" : "' + fecha + '", "DNI_Validation__c" : false, ' +
                '"DNI_Validation_date__c" : "' + fecha + '", "Email_Validation__c" : false}';
            
            objOnb.Pasos__c = 'Datos personales';
            objOnb.Landing_Version__c = '1.0';
            objOnb.Legal_Documents_Version__c = '1.0';
            objOnb.ID__c = '';
            objOnb.PersonEmail__c = email;
            objOnb.I_Accept_the_Privacy_Policy__c = privacyPolicy;
            objOnb.Privacy_Policy_Date__c = fecha;
            objOnb.Transfer_of_data__c = false;
            objOnb.Transfer_of_data_date__c = fecha;
            objOnb.I_do_not_accept_advertising_shipping__c = advertisingShipping;
            objOnb.Advertising_shipping_date__c = fecha;
            objOnb.New_Conditions_Data_Use__c = false;
            objOnb.New_Conditions_Data_Use_date__c = fecha;
            objOnb.DNI_Validation__c = false;
            objOnb.DNI_Validation_date__c = fecha;
            objOnb.No_Entity_Information_Sources__c = false;
            objOnb.No_Entity_Information_Sources_date__c = fecha;
            objOnb.Email_Validation__c = false;

            update objOnb;

            String pasos = objOnb.Pasos__c;
            String camposCambian = 'Case: Pasos__c, Landing_Version__c, ' + 'Legal_Documents_Version__c, ID__c, PersonEmail__c, ' + 
            'I_Accept_the_Privacy_Policy__c, Privacy_Policy_Date__c, ' + 'Transfer_of_data__c, Transfer_of_data_date__c, ' +
            'I_do_not_accept_advertising_shipping__c, Advertising_shipping_date__c, ' +'New_Conditions_Data_Use__c, New_Conditions_Data_Use_date__c, ' +
            'DNI_Validation__c, No_Entity_Information_Sources_date__c, ' + 'DNI_Validation_date__c, Email_Validation__c';
            String newValues = objOnb.pasos__c + ', ' + objOnb.Landing_Version__c + ', ' +
            objOnb.Legal_Documents_Version__c + ', ' + objOnb.ID__c + ', ' + objOnb.PersonEmail__c + ', ' +
            objOnb.I_Accept_the_Privacy_Policy__c + ', ' + objOnb.Privacy_Policy_Date__c + ', ' +
            objOnb.Transfer_of_data__c + ', ' + objOnb.Transfer_of_data_date__c + ', ' +
            objOnb.I_do_not_accept_advertising_shipping__c + ', ' + objOnb.Advertising_shipping_date__c + ', ' +
            objOnb.New_Conditions_Data_Use__c + ', ' + objOnb.New_Conditions_Data_Use_date__c + ', ' +
            objOnb.DNI_Validation__c + ', ' + objOnb.No_Entity_Information_Sources_date__c + ', ' +
            objOnb.DNI_Validation_date__c + ', ' + objOnb.Email_Validation__c;
            String origenCambio = 'PATCH Case';
            ManejoTrazabilidad.actualizarTrazabilidad('', camposCambian, false, newValues, oldValues, origenCambio, pasos, false);

            ONB_phone__c tlfno = new ONB_phone__c();
            tlfno.PersonMobilePhone__c = telefono;
            tlfno.Account__c = objOnb.Cuenta_referencia__c;

            insert tlfno;

            pasos = 'Datos Personales';
            camposCambian = 'ONB_phone__c: PersonMobilePhone__c, Account__c';
            oldValues = '';
            newValues = tlfno.PersonMobilePhone__c + ', ' + tlfno.Account__c;
            origenCambio = 'insert ONB_phone__c';
            
            ManejoTrazabilidad.actualizarTrazabilidad('', camposCambian, false, newValues, oldValues, origenCambio, pasos, false);

            respuesta = 'Actualizacion realizada correctamente. Codigo 200';
        } 
        catch(Exception e) {  
            System.debug(e.getMessage());
            ManejoErrores.registrarError(e);
        }
    
        return respuesta;
    }

}
