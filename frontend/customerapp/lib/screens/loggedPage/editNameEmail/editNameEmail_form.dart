import 'package:customerapp/dto/user.dart';
import 'package:customerapp/models/changeNameEmail.dart';
import 'package:customerapp/models/logged.dart';
import 'package:customerapp/screens/commonComponents/single_message_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:customerapp/styles/signup.dart';
import 'package:provider/provider.dart';
import 'package:customerapp/endpoints/user.dart';

class EditNameEmail extends StatelessWidget {
  final Function update;
  EditNameEmail({this.update});
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
                  'Your details',
                  style: registerToKometTextStyle,
                ),
              )),
              EditNameEmailForm(update: update),
            ])));
  }
}

class EditNameEmailForm extends StatelessWidget {
  final Function update;
  EditNameEmailForm({this.update});
  @override
  Widget build(BuildContext context) {
    var editNameEmailModel = context.watch<EditNameEmailModel>();
    var loggedModel = context.watch<LoggedModel>();
    return Form(
      onChanged: () => editNameEmailModel.formValid =
          editNameEmailModel.formKey.currentState.validate(),
      key: editNameEmailModel.formKey,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              constraints: BoxConstraints(maxWidth: 600),
              child: TextFormField(
                initialValue: LoggedModel.user.name,
                onSaved: (value) => editNameEmailModel.firstName = value,
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
                onFieldSubmitted: (value) {
                  tryEditNameEmailForm(
                      context, editNameEmailModel, loggedModel, update);
                },
                autofocus: true,
              )),
          Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              constraints: BoxConstraints(maxWidth: 600),
              child: TextFormField(
                initialValue: LoggedModel.user.email,
                onSaved: (value) => editNameEmailModel.email = value,
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
                onFieldSubmitted: (value) {
                  tryEditNameEmailForm(
                      context, editNameEmailModel, loggedModel, update);
                },
              )),
          SaveInformationNameEmailButton(update: update),
        ],
      ),
    );
  }
}

/*
  It may be better to pass only formKey as parameter (or the model)
*/
class SaveInformationNameEmailButton extends StatelessWidget {
  final Function update;
  SaveInformationNameEmailButton({this.update});
  @override
  Widget build(BuildContext context) {
    var editNameEmailModel = context.watch<EditNameEmailModel>();
    var loggedModel = context.watch<LoggedModel>();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Wrap(
        children: [
          ElevatedButton(
            onLongPress: null,
            onPressed: editNameEmailModel.formValid
                ? () {
                    tryEditNameEmailForm(
                        context, editNameEmailModel, loggedModel, update);
                  }
                : null,
            child: Text('Save'),
            style: editNameEmailModel.formValid
                ? signUpButtonStyleEnabled
                : signUpButtonStyleDisabled,
          )
        ],
      ),
    );
  }
}

void tryEditNameEmailForm(
    BuildContext context,
    EditNameEmailModel editNameEmailModel,
    LoggedModel loggedModel,
    Function update) {
  if (editNameEmailModel.formValid) {
    if (editNameEmailModel.formKey.currentState.validate()) {
      showLoaderDialog(context);
      editNameEmailModel.formKey.currentState.save();
      UserDTO formUser = new UserDTO();
      formUser.name = editNameEmailModel.firstName;
      formUser.email = editNameEmailModel.email;
      updateUserAndEmail(formUser).then((newLoggedUser) async {
        loggedModel.getUserAndNotify().email = editNameEmailModel.email;
        loggedModel.getUserAndNotify().name = editNameEmailModel.firstName;
        update();
        Navigator.pop(context); //exit loader
        Navigator.pop(context); //exit changeInfo dialog
      }).catchError((error) {
        print(error);
        Navigator.pop(context); //exit loader
        showEditNameEmailFailedDialog(context);
      });
    }
  }
}

showEditNameEmailFailedDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) =>
          SingleMessageDialog("Couldn't edit user information."));
}
