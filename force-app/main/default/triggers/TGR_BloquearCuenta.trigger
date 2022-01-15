trigger TGR_BloquearCuenta on Account (before update) 
{
    
    String estadoCuenta = Trigger.new[0].Estado__c;
    
    if (estadoCuenta == 'DNI no coincidente') {

        Trigger.new[0].Active__c = 'No';
    }
}