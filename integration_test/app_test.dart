import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:polizas/viewmodels/login_viewmodel.dart';
import 'package:polizas/viewmodels/poliza_viewmodel.dart';
import 'package:polizas/screens/login_screen.dart';
import 'package:polizas/screens/home_screen.dart';
import 'package:polizas/screens/poliza_form_screen.dart';
import 'package:polizas/screens/poliza_search_screen.dart';
import 'package:polizas/screens/propietarios_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Pruebas de Integración - Sistema de Pólizas', () {

    // GRUPO 1: PRUEBAS DE LOGIN
    group('1. Pruebas de Login', () {

      testWidgets('1.1 Login correcto con credenciales válidas', (WidgetTester tester) async {
        // Objetivo: Verificar que el usuario puede iniciar sesión con credenciales correctas

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => LoginViewModel()),
              ChangeNotifierProvider(create: (context) => PolizaViewModel()),
            ],
            child: const MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

        // Pasos ejecutados:
        // 1. Verificar que estamos en la pantalla de login (buscar en AppBar)
        expect(find.text('Sistema de Pólizas de Seguros'), findsOneWidget);
        expect(find.byKey(const ValueKey('username_field')), findsOneWidget);
        expect(find.byKey(const ValueKey('password_field')), findsOneWidget);

        // 2. Ingresar credenciales válidas
        await tester.enterText(find.byKey(const ValueKey('username_field')), 'admin');
        await tester.enterText(find.byKey(const ValueKey('password_field')), 'admin123');
        await tester.pumpAndSettle();

        // 3. Presionar botón de login
        await tester.tap(find.byKey(const ValueKey('login_button')));
        await tester.pumpAndSettle();

        // 4. Esperar a que termine la carga
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Resultado esperado: No debe mostrar mensaje de error
        expect(find.text('Credenciales incorrectas'), findsNothing);

        print('✅ PRUEBA 1.1: Login correcto - EXITOSA');
      });

      testWidgets('1.2 Login incorrecto con credenciales inválidas', (WidgetTester tester) async {
        // Objetivo: Verificar que el sistema rechaza credenciales incorrectas

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => LoginViewModel()),
              ChangeNotifierProvider(create: (context) => PolizaViewModel()),
            ],
            child: const MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

        // Pasos ejecutados:
        // 1. Ingresar credenciales inválidas
        await tester.enterText(find.byKey(const ValueKey('username_field')), 'usuario_invalido');
        await tester.enterText(find.byKey(const ValueKey('password_field')), 'contraseña_incorrecta');
        await tester.pumpAndSettle();

        // 2. Presionar botón de login
        await tester.tap(find.byKey(const ValueKey('login_button')));
        await tester.pumpAndSettle();

        // 3. Esperar a que termine la carga
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Resultado esperado: Debe mostrar mensaje de error
        expect(find.text('Credenciales incorrectas'), findsOneWidget);
        expect(find.text('Sistema de Pólizas de Seguros'), findsOneWidget);

        print('✅ PRUEBA 1.2: Login incorrecto - EXITOSA');
      });

      testWidgets('1.3 Validación de campos vacíos', (WidgetTester tester) async {
        // Objetivo: Verificar que el sistema valida campos obligatorios

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => LoginViewModel()),
              ChangeNotifierProvider(create: (context) => PolizaViewModel()),
            ],
            child: const MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

        // Pasos ejecutados:
        // 1. Intentar login sin llenar campos
        await tester.tap(find.byKey(const ValueKey('login_button')));
        await tester.pumpAndSettle();

        // Resultado esperado: Debe mostrar mensaje de validación
        expect(find.text('Usuario y contraseña son obligatorios'), findsOneWidget);

        print('✅ PRUEBA 1.3: Validación campos vacíos - EXITOSA');
      });
    });

    // GRUPO 2: PRUEBAS DE FORMULARIOS
    group('2. Pruebas de Formularios', () {

      testWidgets('2.1 Formulario de póliza se carga correctamente', (WidgetTester tester) async {
        // Objetivo: Verificar que el formulario de póliza carga sin errores

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => LoginViewModel()),
              ChangeNotifierProvider(create: (context) => PolizaViewModel()),
            ],
            child: const MaterialApp(
              home: PolizaFormScreen(),
            ),
          ),
        );

        // Verificar que todos los campos están presentes
        expect(find.text('Crear Nueva Póliza'), findsOneWidget);
        expect(find.byKey(const ValueKey('propietario_field')), findsOneWidget);
        expect(find.byKey(const ValueKey('edad_field')), findsOneWidget);
        expect(find.byKey(const ValueKey('modelo_field')), findsOneWidget);
        expect(find.byKey(const ValueKey('valor_field')), findsOneWidget);
        expect(find.byKey(const ValueKey('accidentes_field')), findsOneWidget);
        expect(find.byKey(const ValueKey('create_poliza_submit_button')), findsOneWidget);

        print('✅ PRUEBA 2.1: Formulario póliza carga - EXITOSA');
      });

      testWidgets('2.2 Validar campos obligatorios en formulario', (WidgetTester tester) async {
        // Objetivo: Verificar que el formulario valida campos obligatorios

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => LoginViewModel()),
              ChangeNotifierProvider(create: (context) => PolizaViewModel()),
            ],
            child: const MaterialApp(
              home: PolizaFormScreen(),
            ),
          ),
        );

        // Scroll para asegurar que el botón es visible
        await tester.scrollUntilVisible(
          find.byKey(const ValueKey('create_poliza_submit_button')),
          500.0,
        );

        // Intentar enviar formulario vacío
        await tester.tap(find.byKey(const ValueKey('create_poliza_submit_button')));
        await tester.pumpAndSettle();

        // Debe mostrar validación de Flutter Forms
        expect(find.text('El nombre del propietario es obligatorio'), findsOneWidget);

        print('✅ PRUEBA 2.2: Validación campos obligatorios - EXITOSA');
      });

      testWidgets('2.3 Llenar formulario con datos válidos', (WidgetTester tester) async {
        // Objetivo: Verificar que se pueden llenar todos los campos

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => LoginViewModel()),
              ChangeNotifierProvider(create: (context) => PolizaViewModel()),
            ],
            child: const MaterialApp(
              home: PolizaFormScreen(),
            ),
          ),
        );

        // Llenar todos los campos con datos válidos
        await tester.enterText(find.byKey(const ValueKey('propietario_field')), 'Juan Pérez');
        await tester.enterText(find.byKey(const ValueKey('edad_field')), '30');
        await tester.enterText(find.byKey(const ValueKey('modelo_field')), 'A');
        await tester.enterText(find.byKey(const ValueKey('valor_field')), '25000');
        await tester.enterText(find.byKey(const ValueKey('accidentes_field')), '0');
        await tester.pumpAndSettle();

        // Verificar que los campos se llenaron
        expect(find.text('Juan Pérez'), findsOneWidget);
        expect(find.text('30'), findsWidgets);
        expect(find.text('A'), findsOneWidget);

        print('✅ PRUEBA 2.3: Llenar formulario - EXITOSA');
      });
    });

    // GRUPO 3: PRUEBAS DE NAVEGACIÓN
    group('3. Pruebas de Navegación', () {

      testWidgets('3.1 Pantalla de búsqueda se carga', (WidgetTester tester) async {
        // Objetivo: Verificar que la pantalla de búsqueda carga correctamente

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => LoginViewModel()),
              ChangeNotifierProvider(create: (context) => PolizaViewModel()),
            ],
            child: const MaterialApp(
              home: PolizaSearchScreen(),
            ),
          ),
        );

        // Verificar elementos de la pantalla
        expect(find.byKey(const ValueKey('search_nombre_field')), findsOneWidget);
        expect(find.byKey(const ValueKey('search_poliza_button')), findsOneWidget);

        // Intentar búsqueda con campo vacío
        await tester.tap(find.byKey(const ValueKey('search_poliza_button')));
        await tester.pumpAndSettle();

        // Debe mostrar validación
        expect(find.text('El nombre es obligatorio para la búsqueda'), findsOneWidget);

        print('✅ PRUEBA 3.1: Pantalla búsqueda - EXITOSA');
      });

      testWidgets('3.2 Pantalla de propietarios se carga', (WidgetTester tester) async {
        // Objetivo: Verificar que la pantalla de propietarios se carga

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => LoginViewModel()),
              ChangeNotifierProvider(create: (context) => PolizaViewModel()),
            ],
            child: const MaterialApp(
              home: PropietariosScreen(),
            ),
          ),
        );

        // Verificar que la pantalla se carga
        expect(find.byKey(const ValueKey('refresh_propietarios_button')), findsOneWidget);

        // Esperar a que termine la carga inicial
        await tester.pumpAndSettle(const Duration(seconds: 3));

        print('✅ PRUEBA 3.2: Pantalla propietarios - EXITOSA');
      });
    });

    // GRUPO 4: PRUEBAS DE VALIDACIÓN
    group('4. Pruebas de Validación', () {

      testWidgets('4.1 Validación de edad mínima', (WidgetTester tester) async {
        // Objetivo: Verificar validación de edad mínima

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => LoginViewModel()),
              ChangeNotifierProvider(create: (context) => PolizaViewModel()),
            ],
            child: const MaterialApp(
              home: PolizaFormScreen(),
            ),
          ),
        );

        // Ingresar edad menor a 18
        await tester.enterText(find.byKey(const ValueKey('edad_field')), '17');
        await tester.pumpAndSettle();

        // Scroll para hacer visible el botón
        await tester.scrollUntilVisible(
          find.byKey(const ValueKey('create_poliza_submit_button')),
          500.0,
        );

        // Intentar enviar
        await tester.tap(find.byKey(const ValueKey('create_poliza_submit_button')));
        await tester.pumpAndSettle();

        // Debe mostrar error de edad
        expect(find.text('La edad debe ser mayor a 18 años'), findsOneWidget);

        print('✅ PRUEBA 4.1: Validación edad mínima - EXITOSA');
      });

      testWidgets('4.2 Campos de formulario funcionan', (WidgetTester tester) async {
        // Objetivo: Verificar que todos los campos del formulario funcionan

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => LoginViewModel()),
              ChangeNotifierProvider(create: (context) => PolizaViewModel()),
            ],
            child: const MaterialApp(
              home: PolizaFormScreen(),
            ),
          ),
        );

        // Probar cada campo individualmente
        await tester.enterText(find.byKey(const ValueKey('propietario_field')), 'Test User');
        await tester.enterText(find.byKey(const ValueKey('edad_field')), '25');
        await tester.enterText(find.byKey(const ValueKey('modelo_field')), 'C');
        await tester.enterText(find.byKey(const ValueKey('valor_field')), '15000');
        await tester.enterText(find.byKey(const ValueKey('accidentes_field')), '1');
        await tester.pumpAndSettle();

        // Verificar que los valores se ingresaron
        expect(find.text('Test User'), findsOneWidget);
        expect(find.text('25'), findsWidgets);
        expect(find.text('C'), findsOneWidget);

        print('✅ PRUEBA 4.2: Campos formulario funcionan - EXITOSA');
      });
    });
  });
}
