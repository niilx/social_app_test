import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:social_test/controllers/authentication/loginController.dart';
import 'package:social_test/helpers/projectResources.dart';
import 'package:social_test/styles/colors.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final signInText = "Sign In";
  final emailText = "Email";
  final emailHintText = "Enter your email";
  final passwordText = "Password";
  final passwordHintText = "Enter your Password";
  final rememberText = "Remember me";
  final loginText = "Login";

  final _formKey = GlobalKey<FormState>();
  late LoginController loginController;
  late LoginController loginControllerVar;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loginController.clear();
    });
  }

  @override
  void didChangeDependencies() {
    loginController = Provider.of<LoginController>(context, listen: false);
    loginControllerVar = Provider.of<LoginController>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    loginController.clear();
    super.dispose();
  }

  getLoginView(){
    getInputDecoration({String? hintText}){
      return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.greyColor),
        focusColor: AppColors.themeColor,
        iconColor: AppColors.themeColor,
        fillColor: AppColors.greyColor.withOpacity(.1),
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: AppColors.backgroundColor.withOpacity(.5))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: AppColors.backgroundColor.withOpacity(.5))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: AppColors.backgroundColor.withOpacity(.5))),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: AppColors.backgroundColor.withOpacity(.5))),
        prefixStyle: TextStyle(color: Colors.black),
        labelStyle: TextStyle(color: Colors.black),
      );
    }

    getEmailInput() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emailText, style: TextStyle(color: AppColors.greyColor, fontSize: ProjectResource.fontSizeFactor * 1.2),),
          SizedBox(height: ProjectResource.fontSizeFactor*.5,),
          TextFormField(
            controller: loginControllerVar.emailController,
            focusNode: loginControllerVar.emailControllerNode,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            cursorColor: AppColors.greyColor,
            onEditingComplete: () {
              FocusScope.of(context)
                  .requestFocus(loginControllerVar.passwordControllerNode);
            },
            decoration: getInputDecoration(hintText: emailHintText),
            onSaved: (String? value) {
              // This optional block of code can be used to run
              // code when the user saves the form.
            },
            validator: (String? value) {
              return value!.isNotEmpty
                  ? null
                  : 'Invalid';
            },
          ),
        ],
      );
    }
    getPasswordInput() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(passwordText, style: TextStyle(color: AppColors.greyColor, fontSize: ProjectResource.fontSizeFactor * 1.2),),
          SizedBox(height: ProjectResource.fontSizeFactor*.5,),
          TextFormField(
            controller: loginControllerVar.passwordController,
            focusNode: loginControllerVar.passwordControllerNode,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            obscureText: loginControllerVar
                .passwordVisible,
            cursorColor: AppColors.greyColor,
            decoration: getInputDecoration(hintText: passwordHintText),
            onSaved: (String? value) {
              // This optional block of code can be used to run
              // code when the user saves the form.
            },
            validator: (String? value) {
              return value!.isEmpty || value.length < 6
                  ? "Invalid"
                  : null;
            },
          ),
        ],
      );
    }
    getRememberMe() {
      return Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
            onTap: () {
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  0,
                  ProjectResource.screenHeight * .02,
                  0,
                  ProjectResource.screenHeight * .02),
              child: Row(
                children: [
                  Icon(Icons.square_outlined,
                  color: AppColors.whiteColor,
                    size: ProjectResource.fontSizeFactor,
                  ),
                  SizedBox(width: ProjectResource.fontSizeFactor * .5,),
                  Text(
                    'Remember me',
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ProjectResource.fontSizeFactor * .85,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )),
      );
    }
    getLoginButton() {
      return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) => AppColors.loginButtonColor),
            minimumSize: WidgetStateProperty.resolveWith((states) =>
                Size(ProjectResource.screenWidth * .9,52)),
            shape:  WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)))),
          ),
          onPressed: () {
            print("press");
            if (_formKey.currentState!.validate()) {
              FocusScope.of(context).requestFocus(FocusNode());
              loginController.performLogin(context: context);
            }
          },
          child: loginControllerVar.loading
              ? CircularProgressIndicator(
            valueColor:
            AlwaysStoppedAnimation(AppColors.whiteColor),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                loginText,
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: ProjectResource.fontSizeFactor * 1.2),
                textAlign: TextAlign.center,
              ),
              ],
          ));
    }

    return
      Positioned(
        top: ProjectResource.screenHeight * .48,
        child: Container(
            width: ProjectResource.screenWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border(
                  top: BorderSide( //                   <--- right side
                    color: AppColors.loginBg,
                    width: 4.0,
                  ),
                )
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, ProjectResource.screenHeight * .02, 20,0),
                child: Column(
                  children: [
                    Text(signInText, style: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                        fontSize: ProjectResource.fontSizeFactor * 2),),
                    SizedBox(height: ProjectResource.screenHeight * .02,),
                    getEmailInput(),
                    ProjectResource.getGapVertical(
                        value: ProjectResource.screenHeight * .03),
                    getPasswordInput(),

                    ProjectResource.getGapVertical(
                        value: ProjectResource.screenHeight * .005),
                    getRememberMe(),
                    ProjectResource.getGapVertical(
                        value: ProjectResource.screenHeight * .02),
                    getLoginButton(),
                    ProjectResource.getGapVertical(
                        value: ProjectResource.screenHeight * .2),
                  ],
                ),
              ),
            )
        ),
      );

  }

  getBgElements1(){
    return Positioned(
      top: -ProjectResource.screenHeight * .06,
      child: Container(
          alignment: Alignment.topCenter,
          child: Opacity(
            opacity: 0.4,
            child: SvgPicture.asset(
                "assets/images/bg_elements1.svg",
                width: ProjectResource.screenWidth,

                colorBlendMode: BlendMode.screen

            ),
          )),
    );
  }

  getBgElements2(){
    return Positioned(
      top: ProjectResource.screenHeight * .22,
      child: Container(
          alignment: Alignment.topCenter,
          child: Opacity(
            opacity: 0.4,
            child: SvgPicture.asset(
              "assets/images/bg_elements1.svg",
              width: ProjectResource.screenWidth,
              height: ProjectResource.screenHeight * .35,


            ),
          )),
    );
  }

  getLogo(){
    return               Positioned(
      top: ProjectResource.screenHeight * .15,
      child: SvgPicture.asset(
          "assets/images/logo.svg",
          width: ProjectResource.screenWidth * .78,
          colorBlendMode: BlendMode.screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ProjectResource.setScreenSize(context);
    return  Scaffold(

      backgroundColor: AppColors.themeColor,
      body: SingleChildScrollView(
        child: Container(
          height: ProjectResource.screenHeight,

          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              getBgElements1(),
              getBgElements2(),
              getLogo(),
              getLoginView(),
            ],
          ),
        ),
      ),
    );
  }
}
