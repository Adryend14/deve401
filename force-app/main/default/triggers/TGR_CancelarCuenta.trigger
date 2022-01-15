trigger TGR_CancelarCuenta on Account (before update) 
{
    String estadoCuenta = Trigger.new[0].Estado__c;

    if (estadoCuenta == 'Motivos comerciales') {
        
        Trigger.new[0].Active__c = 'No';
    }
}