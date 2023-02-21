import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_animated_omar_ahmed/enum_animation.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Artboard? riveArtboard;

  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  late RiveAnimationController controllerLookDownRight;
  late RiveAnimationController controllerLookDownLeft;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final passwordFocusNode = FocusNode();
  final String testEmail = "moataz@gmail.com";
  final String testPassword = "123456";

  bool isLookingLeft = false;
  bool isLookingRight = false;

  void removeAllController() {
    riveArtboard!.artboard.removeController(controllerIdle);
    riveArtboard!.artboard.removeController(controllerHandsUp);
    riveArtboard!.artboard.removeController(controllerHandsDown);
    riveArtboard!.artboard.removeController(controllerLookDownRight);
    riveArtboard!.artboard.removeController(controllerSuccess);
    riveArtboard!.artboard.removeController(controllerFail);
    riveArtboard!.artboard.removeController(controllerLookDownLeft);
    isLookingLeft = false;
    isLookingRight = false;
  }

  void addIdleController() {
    removeAllController();
    riveArtboard!.artboard.addController(controllerIdle);
    debugPrint("Idle");
  }

  void addHandUpController() {
    removeAllController();
    riveArtboard!.artboard.addController(controllerHandsUp);
    debugPrint("Hands Up");
  }

  void addHandDownController() {
    removeAllController();
    riveArtboard!.artboard.addController(controllerHandsDown);
    debugPrint("Hands Down");
  }

  void addSuccessController() {
    removeAllController();
    riveArtboard!.artboard.addController(controllerSuccess);
    debugPrint("Success");
  }

  void addFailController() {
    removeAllController();
    riveArtboard!.artboard.addController(controllerFail);
    debugPrint("Fail");
  }

  void addLookDownLeftController() {
    removeAllController();
    isLookingLeft = true;
    riveArtboard!.artboard.addController(controllerLookDownLeft);
    debugPrint("LookDownLeft");
  }

  void addLookDownRightController() {
    removeAllController();
    isLookingRight = true;
    riveArtboard!.artboard.addController(controllerLookDownRight);
    debugPrint("LookDownRight");
  }

  void checkPasswordFocusNode() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        addHandUpController();
      } else if (!passwordFocusNode.hasFocus) {
        addHandDownController();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);
    controllerLookDownRight =
        SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerLookDownLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);

    rootBundle.load('assets/login_animation.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      artboard.addController(controllerIdle);
      setState(() {
        riveArtboard = artboard;
      });
    });

    checkPasswordFocusNode();
  }

  void validateEmailAndPassword() {
    Future.delayed(const Duration(seconds: 1), () {
      if (formKey.currentState!.validate()) {
        addSuccessController();
      } else {
        addFailController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated Login'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: riveArtboard == null
                    ? const SizedBox.shrink()
                    : Rive(artboard: riveArtboard!),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                      ),
                      validator: (value) =>
                          value != testEmail ? "Wrong Email" : null,
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            value.length < 12 &&
                            !isLookingLeft) {
                          addLookDownLeftController();
                        } else if (value.isNotEmpty &&
                            value.length > 12 &&
                            !isLookingRight) {
                          addLookDownRightController();
                        }
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 25,
                    ),
                    TextFormField(
                      obscureText: true,
                      focusNode: passwordFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                      ),
                      validator: (value) =>
                          value != testPassword ? "Wrong Password" : null,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 15,
                    ),
                    TextButton(
                      onPressed: () {
                        passwordFocusNode.unfocus();
                        validateEmailAndPassword();
                      },
                      child: Text(
                        'LOGIN',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
