trigger TGR_ActualizarEstado on Case (before update) 
{
    RestOnboarding.actualizarEstado(trigger.new[0]);
}