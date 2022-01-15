@RestResource(urlMapping='/Task/*')
global with sharing class RestTarea {
    
    @HttpPOST

    global static string postTask(String proceso, String telefono) {

        String respuesta = null;

        try {  
                String pasos = 'Bienvenida';
                String camposCambian = 'Task: Subject, Type, Phone';
                String oldValues = '';
                String newValues = 'Call, Onboarding, ' + telefono;
                String origenCambio = 'POST Tarea';
                ManejoTrazabilidad.actualizarTrazabilidad('', camposCambian, false, newValues, oldValues, origenCambio, pasos, false);

                ManejoTareas.actualizarTarea(proceso, telefono);

                respuesta = 'Tarea creada. ';
            }
        catch(Exception e) {  
            ManejoErrores.registrarError(e);
        }

        return respuesta;

    }
}
