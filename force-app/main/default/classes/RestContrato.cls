@RestResource(urlMapping='/ONB_contract__c/*')
global with sharing class RestContrato {
    
    @HttpPATCH

    global static String patchContract (String DNI, String tipoContrato, String civil_status) {

        Case onboarding = [SELECT Id, Cuenta_referencia__c, Seccion__c FROM Case WHERE DNI__c = :DNI];
        List<ONB_contract__c> contratos = 
            [SELECT Contract_downloaded__c, Contract_down_date__c, Iaccepttheinformationpriorofcontracting__c, 
            Civil_Status__c, Tipo_contrato__c FROM ONB_contract__c WHERE (Onboarding_relacionado__c = :onboarding.Id)];
         
        Date fecha = Date.today();
        String cuerpoPDF;
        String pasos;
        String camposCambian;
        String origenCambio;
        String oldValues = '';
        ONB_contract__c contrato = contratos[0];

        if (tipoContrato == 'GDPR') {
            cuerpoPDF = 'Contrato estandar';
            contrato.Contract_downloaded__c = cuerpoPDF;
            contrato.Contract_down_date__c = fecha;
            contrato.Iaccepttheinformationpriorofcontracting__c = true;
            contrato.Tipo_contrato__c = 'GPDR';
            pasos = 'Contrato';
            camposCambian = 'ONB_contract__c: Contract_downloaded__c, Contract_down_date__c, ' +
                'Iaccepttheinformationpriorofcontracting__c, Tipo_contrato__c';
            oldValues = contrato.Contract_downloaded__c + ', ' + contrato.Contract_down_date__c + ', ' +
            contrato.Iaccepttheinformationpriorofcontracting__c + ', ' + contrato.Tipo_contrato__c;           
            
            origenCambio = 'PATCH ONB_contract__c REST';
        
        } else if (tipoContrato == 'KYC') {
            contrato.Civil_Status__c = civil_status;
            contrato.Tipo_contrato__c = 'KYC';
            pasos = 'KYC';
            camposCambian = 'ONB_contract__c: Civil_Status__c, Tipo_contrato__c';
            oldValues = contrato.Civil_Status__c + ', ' + contrato.Tipo_contrato__c;            
            origenCambio = 'PATCH ONB_contract__c';
        }

        String respuesta = '';

        try {
                update contrato;

                respuesta = 'Contrato actualizado. Codigo 200';

                String newValues;
                if (tipoContrato == 'GDPR') {
                    newValues = contrato.Contract_downloaded__c + ', ' + contrato.Contract_down_date__c + ', ' +
                        contrato.Iaccepttheinformationpriorofcontracting__c + ', ' + contrato.Tipo_contrato__c;
                } else {
                    newValues = '' + contrato.Civil_Status__c + ', ' + contrato.Tipo_contrato__c;
                }

                ManejoTrazabilidad.actualizarTrazabilidad('', camposCambian, false, newValues, oldValues, origenCambio, pasos, false);
                
                oldValues = onboarding.Seccion__c;

                if (tipoContrato == 'GPDR'){
                    onboarding.Seccion__c = '2';
                }
                else{
                    onboarding.Seccion__c = '3';
                }                

                update onboarding;

                camposCambian = 'Case: Seccion__c';
                newValues = onboarding.Seccion__c;
                origenCambio = 'Update Case';
                ManejoTrazabilidad.actualizarTrazabilidad('', camposCambian, false, newValues, oldValues, origenCambio, pasos, false);
        } catch(Exception e) {  
            
            ManejoErrores.registrarError(e);
        }

        return respuesta;

    }
}
