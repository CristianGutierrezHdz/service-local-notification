import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_local_notification/presentation/viewmodels/home_vm.dart';

class ProviderSetup {
  static Widget init({required Widget child}) {
    return MultiProvider(
      providers: [
        // Inyección de dependencias
        ChangeNotifierProvider(create: (context) => HomeVM()),
      ],
      child: child,
    );
  }
}

/*
Esto  se conoce como "inyección de dependencias" y específicamente "desacoplamiento de la configuración de 
dependencias".

En términos de arquitectura, este enfoque sigue principios como:

Inversión de Dependencias (D en SOLID) → En lugar de instanciar dependencias directamente en el widget, las obtienes 
de un proveedor externo.

Separación de Preocupaciones → Separa la configuración de los proveedores de la UI.

Modularidad y Mantenibilidad → Hace que la configuración de dependencias sea más limpia y fácil de modificar.

En Flutter, este patrón es comúnmente llamado "Dependency Injection (DI)", y el acto de mover la configuración de los 
Provider a una clase separada (como ProviderSetup.init()) se conoce como "Configuración Centralizada de Dependencias".
*/
