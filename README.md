# form



A new Flutter project.


> Importante: En flutter solo debe haber un MaterialApp en toda la App para que no ocurra error con el gorouter


> agregar Uri.encodeComponent cuando se envia parametro con caracteres especiales para garantizar que tenga el encoding correcto

> llamadas al provider no se puede hacer directamente en el build por lo que se necesita que este dentro de un:
 WidgetsBinding.instance.addPostFrameCallback((_) {}


### GO_ROUTE
**pushReplacement** mantiene el stack.

**go** resetea la pila.

**push** agrega una nueva ruta encima de la pila.
 