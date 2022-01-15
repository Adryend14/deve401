public with sharing class ManejoTareas {
    public static void actualizarTarea(ID idTarea, String telefono, ID accountId)
    {
            List<Contact> contactos = [SELECT ID FROM Contact WHERE (Phone = :telefono)];
            Group g = [SELECT ID FROM Group WHERE ((Type = 'Queue') AND (Name = 'Cola')) LIMIT 1];
            ID qID = g.ID;

            if (contactos.size() == 0)
            {
                Contact contacto = new Contact();
                contacto.LastName = 'Contacto nuevo numero ' + String.valueOf(Math.random());
                contacto.Phone = telefono;

                insert contact;

                String pasos = 'Bienvenida';
                String camposCambian = 'Contact: LastName, Phone';
                String oldValues = '';
                String newValues = contact.LastName + ', ' + phone;
                String origenCambio = 'Actualizar tarea';
                ManejoTrazabilidad.actualizarTrazabilidad('', camposCambian, false, newValues, oldValues, origenCambio, pasos, false);
            }

            Task t;
            try
            {
                List<Task> tareas = [SELECT ID FROM Task WHERE (ID = :idTarea) LIMIT 1];
                t = tareas[0];
            
            } catch (Exception e) {

                t = new Task();
                t.Subject = 'Call';
                t.Process_Type__c = 'Onboarding';
            }

            t.WhoId = [SELECT ID FROM Contact WHERE Phone = :telefono LIMIT 1][0].Id;
            t.OwnerId = qID;
            
            String oldValues2 = t.Subject + ', ' + t.Process_Type__c + ', ' + t.WhoId + ', ' + t.OwnerId;

            upsert t;

            String pasos2 = 'Bienvenida';
            String camposCambian2 = 'Task: Subject, WhoId, OwnerId, Process_Type__c';
            String newValues2 = t.Subject + ', ' + t.Process_Type__c + ', ' + t.WhoId + ', ' + t.OwnerId;
            String origenCambio2 = 'Actualizar tarea';
            ManejoTrazabilidad.actualizarTrazabilidad('', camposCambian2, false, newValues2, oldValues2, origenCambio2, pasos2, false);
        }
        
    }
}
