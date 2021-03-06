import 'package:customerapp/components/appBar/user_actions_bar.dart';
import 'package:customerapp/styles/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DefaultLoggedBar extends StatelessWidget with PreferredSizeWidget {
  final double appBarHeight = 115.0;
  @override
  get preferredSize => Size.fromHeight(appBarHeight);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: borderAppBar, width: 1.0))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: defaultAppBarBackgroundColor,
              title: Padding(
                  padding: EdgeInsets.all(40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Logo(), UserActionsBar(BarType.defaultBar)],
                  )))
        ],
      ),
    );
  }
}

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        return Navigator.pushNamed(context, '/initial-logged-in');
      },
      hoverColor: Colors.transparent,
      iconSize: 180,
      icon: Image.asset(
        'resources/images/name_and_logo.png',
      ),
    );
  }
}

class LogoGray extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        return Navigator.pushNamed(context, '/initial-logged-in');
      },
      iconSize: 60,
      hoverColor: Colors.transparent,
      icon: Image.asset(
        'resources/images/name_and_logo_over_gray_lq.png',
      ),
    );
  }
}
