import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './bloc/accountBloc/export_account_bloc.dart';
import './bloc/cartBloc/cart_bloc.dart';
import './bloc/dashboardBloc/export_dashboard_bloc.dart';
import './bloc/homeBloc/home_bloc.dart';
import './model/user.dart';
import './screens/customer/home_screen.dart';
import './screens/seller/dashboard.dart';
import './screens/splash_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/loginScreen/login_screen.dart';
import './services/auth_service.dart';




void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final AuthService authService = AuthService(firebaseAuth: firebaseAuth);

  runApp(
    MyApp(
      authService: authService,
    ),
  );
}

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}


class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  
  final AuthService _authService;

  MyApp({@required AuthService authService})
      : assert(authService!=null),
        _authService = authService;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();



  @override
  void initState() {
    super.initState();
  }

 

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context)=>HomeBloc(),
        ),
          BlocProvider<CartBloc>(
          create: (context)=>CartBloc(),
        ),
        BlocProvider<DashboardBloc>(
          create: (context)=>DashboardBloc(),
        ),
          BlocProvider<AccountBloc>(
          create: (context)=>AccountBloc(),
        ),
      ],
          child: MaterialApp(
            
         routes: {
           '/auth':(context)=>MyApp(authService: widget._authService),
         },
        debugShowCheckedModeBanner: false,
        title: 'Native Hands',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          
        ),
        home: StreamBuilder(
          stream: widget._authService.onAuthChange(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            } else if (snapshot.hasData) {
              return FutureBuilder(
                  future: widget._authService.getFirestoreUser(snapshot.data),
                  builder: (context, documentSnapshot) {
                    if (documentSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SplashScreen();
                    } else if (documentSnapshot.hasData) {
                      User currentUser = User.fromJson(documentSnapshot.data);
                      
                      if (documentSnapshot.data['role'] == 'customer') {
                        return CustomerHomeScreen(user: currentUser);
                      } else  if (documentSnapshot.data['role'] == 'admin') {
                        return AdminDashboard(user: currentUser);
                      } else  if (documentSnapshot.data['role'] == 'seller' && documentSnapshot.data['verified'] == true) {
                        return DashBoard(
                          user:currentUser
                        );
                      }else{
                        return CustomerHomeScreen(user: currentUser);
                      }
                    }
                  });
            } else {
              return LoginScreen(authService: widget._authService);
            }
          },
        ),
      ),
    );
  }
}
