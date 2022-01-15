trigger TGR_ActualizarTarea on Account (after update) {
    
    Boolean callMeBack = Trigger.new[0].Call_me_back__c;

    if (callMeBack && (callMeBack != Trigger.old[0].Call_me_back__c)) {
        
        ManejoTareas.actualizarTarea('Onboarding', Trigger.New[0].Phone);
    }
}