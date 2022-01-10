trigger TGR_Onboarding on Case (after update) 
{
    string respuesta = RestOnboarding.postTareaLlamada(trigger.new);
    System.debug(respuesta);
}