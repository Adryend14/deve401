public with sharing class ManejoTareas {
    
    public static void actualizarTarea(String proceso, String telefono)
    {
            List<Contact> contactos = [SELECT ID FROM Contact WHERE (Phone = :telefono)];
            Group g = [SELECT ID FROM Group WHERE ((Type = 'Queue') AND (Name = 'Cola')) LIMIT 1];
            ID qID = g.ID;

            if (contactos.size() == 0)
            {
                Contact contacto = new Contact();
                Integer randomNumber = Integer.valueof((Math.random() * 10000));
                contacto.LastName = 'Contacto numero ' + String.valueOf(randomNumber);
                contacto.Phone = telefono;

                insert contacto;

                String pasos = 'Bienvenida';
                String camposCambian = 'Contact: LastName, Phone';
                String oldValues = '';
                String newValues = contact.LastName + ', ' + telefono;
                String origenCambio = 'Actualizar tarea';
                ManejoTrazabilidad.actualizarTrazabilidad('', camposCambian, false, newValues, oldValues, origenCambio, pasos, false);
            }

            Task t = new Task();
            t.Subject = 'Call';
            t.Type = proceso;

            t.WhoId = [SELECT ID FROM Contact WHERE Phone = :telefono LIMIT 1][0].Id;
            t.OwnerId = qID;
            t.ActivityDate = Date.today();
            t.Description = 'Llamar al telefono ' + telefono;
            
            String oldValues2 = t.Subject + ', ' + t.Type + ', ' + t.WhoId + ', ' + t.OwnerId;

            upsert t;

            String pasos2 = 'Bienvenida';
            String camposCambian2 = 'Task: Subject, WhoId, OwnerId, Process_Type__c';
            String newValues2 = t.Subject + ', ' + t.Type + ', ' + t.WhoId + ', ' + t.OwnerId;
            String origenCambio2 = 'Actualizar tarea';
            ManejoTrazabilidad.actualizarTrazabilidad('', camposCambian2, false, newValues2, oldValues2, origenCambio2, pasos2, false);
    }
}
