import 'package:customerapp/components/text_link.dart';
import 'package:customerapp/dto/user.dart';
import 'package:customerapp/models/location.dart';
import 'package:customerapp/models/logged.dart';
import 'package:customerapp/models/signin.dart';
import 'package:customerapp/screens/anon_bar.dart';
import 'package:customerapp/screens/commonComponents/single_message_dialog.dart';
import 'package:customerapp/screens/forgotPassword/forgotPassword_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:customerapp/styles/signup.dart';
import 'package:provider/provider.dart';
import 'package:customerapp/endpoints/user.dart';
import 'package:customerapp/infrastructure/persistence/repository/user_credentials_repository.dart';
import 'package:customerapp/models/user_credentials/user_credentials.dart';

class SignInFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height - 150),
            child: ListView(shrinkWrap: true, children: [
              Center(
                  child: Container(
                child: Text(
                  'Login to Komet',
                  style: registerToKometTextStyle,
                ),
              )),
              SignInForm(),
              Container(
                  margin: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                        "New to Komet? ",
                        style: signUpText,
                      ),
                      TextLink('Sign up', (context) {
                        Navigator.pop(context);
                        showSignUp(context);
                      }, signUpTextLinks, signUpTextLinksHover, context)
                    ],
                  )),
            ])));
  }
}

class SignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var signInModel = context.watch<SignInModel>();
    return Form(
      onChanged: () =>
          signInModel.formValid = signInModel.formKey.currentState.validate(),
      key: signInModel.formKey,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              constraints: BoxConstraints(maxWidth: 600),
              child: TextFormField(
                key: Key('login-email-text-field'),
                onSaved: (value) => signInModel.email = value,
                validator: (email) {
                  bool validEmail = EmailValidator.validate(email);
                  return validEmail ? null : "Invalid email address";
                },
                decoration: InputDecoration(
                  border: signUpInputTextBorder,
                  focusedBorder: signUpFocusedInputTextBorder,
                  icon: Icon(
                    Icons.mail_outline_outlined,
                    color: Color(0xFF9B9B9B),
                    size: 40,
                  ),
                  labelText: 'E-mail',
                  labelStyle: labelTextInputStyle,
                ),
                onFieldSubmitted: (value) {
                  trySendSignInForm(context, signInModel);
                },
                autofocus: true,
              )),
          Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              constraints: BoxConstraints(maxWidth: 600),
              child: TextFormField(
                key: Key('login-password-text-field'),
                onSaved: (value) => signInModel.password = value,
                obscureText: signInModel.passwordObfuscated,
                validator: (password) {
                  bool passwordValid = password.isNotEmpty;
                  return passwordValid ? null : "Password is required";
                },
                decoration: InputDecoration(
                  border: signUpInputTextBorder,
                  focusedBorder: signUpFocusedInputTextBorder,
                  suffixIcon: IconButton(
                      onPressed: signInModel.switchPasswordObfuscation,
                      icon: signInModel.passwordObfuscated
                          ? Icon(
                              Icons.visibility_off_outlined,
                              color: Color(0xFF9B9B9B),
                            )
                          : Icon(
                              Icons.visibility,
                              color: Color(0xFF9B9B9B),
                            )),
                  icon: Icon(
                    Icons.lock_outlined,
                    color: Color(0xFF9B9B9B),
                    size: 40,
                  ),
                  labelText: 'Password',
                  labelStyle: labelTextInputStyle,
                ),
                onFieldSubmitted: (value) {
                  trySendSignInForm(context, signInModel);
                },
              )),
          Align(
            child: Container(
                margin: EdgeInsets.all(20.0),
                alignment: Alignment.centerRight,
                child: TextLink('Forgot your password?', (context) {
                  Navigator.pop(context);
                  showForgotPassword(context);
                }, signUpTextLinks, signUpTextLinksHover, context)),
            alignment: Alignment.bottomCenter,
          ),
          SignInButton(),
        ],
      ),
    );
  }
}

/*
  It may be better to pass only formKey as parameter (or the model)
*/
class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var signInModel = context.watch<SignInModel>();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Wrap(
        children: [
          ElevatedButton(
            onLongPress: null,
            onPressed: signInModel.formValid
                ? () {
                    trySendSignInForm(context, signInModel);
                  }
                : null,
            key: Key('submit-login-button'),
            child: Text('Log in with email'),
            style: signInModel.formValid
                ? signUpButtonStyleEnabled
                : signUpButtonStyleDisabled,
          )
        ],
      ),
    );
  }
}

void trySendSignInForm(BuildContext context, SignInModel signInModel) {
  if (signInModel.formValid) {
    if (signInModel.formKey.currentState.validate()) {
      showLoaderDialog(context);
      signInModel.formValid = false;
      signInModel.formKey.currentState.save();
      UserDTO formUser = new UserDTO();
      formUser.email = signInModel.email;
      formUser.password = signInModel.password;
      loginUser(formUser).then((loggedUser) async {
        UserCredentialsRepository()
            .update(new UserCredentials(
                loggedUser.email, loggedUser.token, loggedUser.id))
            .then((value) {
          LoggedModel.user.id = loggedUser.id;
          LoggedModel.user.name = loggedUser.name;
          LoggedModel.user.email = loggedUser.email;
          LoggedModel.user.location = new Location(41.396356, 2.171934);
          LoggedModel.user.direction = 'Unknown direction';
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/initial-logged-in', (route) => false);
        });
      }).catchError((error) {
        print(error);
        Navigator.pop(context);
        showLogInFailedDialog(context);
      });
    }
  }
}

showLogInFailedDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => SingleMessageDialog("Log in failed"));
}

void showForgotPassword(BuildContext context) {
  if (MediaQuery.of(context).size.width > 600) {
    showDialog(context: context, builder: (_) => ForgotPasswordDialog());
  } else {
    Navigator.pushNamed(context, '/forgot-password');
  }
}
