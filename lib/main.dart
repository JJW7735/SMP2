import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
<<<<<<< HEAD
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smp_chat/screens/chatting_screen.dart';
import 'package:smp_chat/screens/login_screen.dart';
=======
import 'package:chatting_1/screen/chatting_screen.dart';  // 채팅 화면
>>>>>>> 6f653a1dbc1a6fa0903d095bb8f923b67afcda73

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Firebase 초기화
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
<<<<<<< HEAD
      home: AuthWrapper(),  // 초기 화면 설정
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        // 사용자 인증 상태에 따라 화면 결정
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (userSnapshot.hasData) {
          return ChattingScreen(); // 사용자가 로그인한 상태면 채팅 화면으로 이동
        }
        return LoginScreen(); // 로그인하지 않은 상태면 로그인 화면으로 이동
      },
    );
  }
}
=======
      home: ChattingScreen(),  // 채팅 화면으로 이동
    );
  }
}
>>>>>>> 6f653a1dbc1a6fa0903d095bb8f923b67afcda73
