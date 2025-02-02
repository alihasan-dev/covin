import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:covin/constant/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../service/connectivity_service.dart';
import '../ui/dashboard_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ConnectivityResult>>(
      initialData: [],
      create: (_) => ConnectivityService().connectionStream,
      builder: (context, child) {
        return const MainScreen();
      }
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  var provider;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Color(0xff0B3054),statusBarIconBrightness: Brightness.light));
  }

  @override
  Widget build(BuildContext context) {
    //provider = Provider.of<ConnectivityResult>(context);
    startTimer(context);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppImage.appLogo,height: MediaQuery.of(context).size.height * 0.12, width: MediaQuery.of(context).size.height * 0.12),
                  const Text(
                    'Covid Info',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,fontFamily: '')
                  )
                ]
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Design & Developed by : Traversal',
                      style: TextStyle(color: Colors.grey[200],fontSize: 11)
                    )
                  ]
                )
              )
            )
          ]
        )
      )
    );
  }

  startTimer(BuildContext mContext) {
    Timer(const Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Dashboard()));
        // if(provider != null){
        //   if(provider == ConnectivityResult.wifi || provider == ConnectivityResult.mobile || provider == ConnectivityResult.ethernet){
        //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Dashboard()));
        //   }else{
        //     var snackBar = const SnackBar(
        //       elevation: 0.0,
        //       backgroundColor: Colors.red,
        //       behavior: SnackBarBehavior.floating,
        //       content: Text('No Internet Connection',style: TextStyle(color: Colors.white)),
        //       margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
        //     );
        //     ScaffoldMessenger.of(mContext).showSnackBar(snackBar);
        //   }
        // }
      }
    );
  }
}