import 'package:customerapp/components/text_link.dart';
import 'package:customerapp/models/signup.dart';
import 'package:customerapp/styles/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {},
          )
        ],
      ),
      body: SignUpDialog(),
    );
  }
}

class SignUpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Center(
              child: Container(
            child: Text(
              'Register to Glovo',
              style: registerToGlovoTextStyle,
            ),
          )),
          Center(
              child: Container(
            child: SignUpForm(),
          )),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Wrap(
                children: [
                  Container(
                      child: Text('Have an account? ',
                          style: Theme.of(context).textTheme.bodyText1)),
                  TextLink('Login', () {}, signUpTextLinksBold,
                      signUpTextLinksHoverBold),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Wrap(
                children: [
                  Expanded(
                    child: Container(
                        child: Text('By registering, you agree to our ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 10))),
                  ),
                  TextLink(
                      'Terms of Service',
                      () {},
                      signUpTextLinks.copyWith(fontSize: 10),
                      signUpTextLinksHover.copyWith(fontSize: 10)),
                  Container(
                      child: Text(' and ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 10))),
                  TextLink(
                      'Privacy Policy',
                      () {},
                      signUpTextLinks.copyWith(fontSize: 10),
                      signUpTextLinksHover.copyWith(fontSize: 10)),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var signUpModel = context.watch<SignUpModel>();
    return Form(
      onChanged: () =>
          signUpModel.formValid = signUpModel.formKey.currentState.validate(),
      key: signUpModel.formKey,
      child: Column(
        children: [
          Container(
              constraints: BoxConstraints(maxWidth: 600),
              child: TextFormField(
                onSaved: (value) => signUpModel.firstName = value,
                validator: (firstName) {
                  bool validFirstName = firstName.isNotEmpty;
                  return validFirstName ? null : "Name is required";
                },
                decoration: InputDecoration(
                  border: signUpInputTextBorder,
                  focusedBorder: signUpFocusedInputTextBorder,
                  icon: Icon(
                    Icons.perm_identity,
                    color: Color(0xFF9B9B9B),
                    size: 40,
                  ),
                  labelText: 'First name',
                  labelStyle: labelTextInputStyle,
                ),
              )),
          Container(
              constraints: BoxConstraints(maxWidth: 600),
              child: TextFormField(
                onSaved: (value) => signUpModel.email = value,
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
                  labelText: 'Email',
                  labelStyle: labelTextInputStyle,
                ),
              )),
          Container(
              constraints: BoxConstraints(maxWidth: 600),
              child: TextFormField(
                onSaved: (value) => signUpModel.password = value,
                obscureText: signUpModel.passwordObfuscated,
                validator: (password) {
                  bool passwordValid = password.isNotEmpty;
                  return passwordValid ? null : "Password is required";
                },
                decoration: InputDecoration(
                  border: signUpInputTextBorder,
                  focusedBorder: signUpFocusedInputTextBorder,
                  suffixIcon: IconButton(
                      onPressed: signUpModel.switchPasswordObfuscation,
                      icon: signUpModel.passwordObfuscated
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
              )),
          SignUpButton(),
        ],
      ),
    );
  }
}

/*
  It may be better to pass only formKey as parameter (or the model)
*/
class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var signUpModel = context.watch<SignUpModel>();
    return Container(
      padding: EdgeInsets.all(30),
      child: Wrap(
        children: [
          ElevatedButton(
            onPressed: signUpModel.formValid
                ? () {
                    if (signUpModel.formKey.currentState.validate()) {
                      Fluttertoast.showToast(
                          msg: "Hola",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      signUpModel.formKey.currentState.save();
                    }
                  }
                : null,
            child: Text('Sign up with email'),
            style: signUpModel.formValid
                ? signUpButtonStyleEnabled
                : signUpButtonStyleDisabled,
          )
        ],
      ),
    );
  }
}
