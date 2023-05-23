import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:whatsapp_clone/screens/landing_screen.dart";
import "package:whatsapp_clone/screens/mobile_screen.dart";
import "package:whatsapp_clone/utils/route.dart";
import "constants/colours.dart";
import "controller/auth_controller.dart";
import "firebase_options.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyA4e-QRyx7AAqXaD86vmKp3xpBJH6OfNKg',
      appId: '1:509102065983:web:73b79a9326b4df2ab36b8a',
      messagingSenderId: '509102065983',
      projectId: 'whatsapp-clone-173cc',
      storageBucket: 'whatsapp-clone-173cc.appspot.com',
    ));
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // FlutterError.demangleStackTrace = (StackTrace stack) {
  //   if (stack is stack_trace.Trace) return stack.vmTrace;
  //   if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
  //   return stack;
  // };

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
//https://th.bing.com/th/id/OIP.2ZXXKN7zakCiYeNrq5-b_gHaHa?w=217&h=217&c=7&r=0&o=5&pid=1.7
//https://th.bing.com/th/id/R.83ab137467dbc8dd837df78506cceaa9?rik=lzJhBTLH5sZDJQ&pid=ImgRaw&r=0
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: ref.watch(userDataProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const MobileScreen();
            },
            error: (err, stacktrace) => const Scaffold(
              body: Center(
                child: Text('An error occured'),
              ),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
      // const LandingScreen(),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
