import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flashchat/components/rounded_button.dart';
import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {

  static const String id='welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation animation;
  @override
  void initState()
  {
    super.initState();
    controller=AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,

    );
    animation=ColorTween(begin: Colors.blueGrey,end: Colors.black).animate(controller);
    controller.forward();

    controller.addListener(() {
      setState(() {

      });
    });
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(

                  text:['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.yellow[800],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(title: 'Login',color:Colors.yellow[800],onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },),
            RoundedButton(title: 'Register',color: Colors.yellow[800],onPressed: () {
              Navigator.pushNamed(context, RegistrationScreen.id);
            },),
          ],
        ),
      ),
    );
  }
}

