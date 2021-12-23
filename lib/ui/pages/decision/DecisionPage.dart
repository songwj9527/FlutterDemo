import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/blocs/base/bloc_provider.dart';
import 'package:flutter_demo_app/blocs/blocs/decision_page/decision_page_bloc.dart';
import 'package:flutter_demo_app/blocs/blocs/decision_page/decision_page_event.dart';
import 'package:flutter_demo_app/blocs/blocs/decision_page/decision_page_state.dart';
import 'package:flutter_demo_app/ui/pages/home/home_page.dart';
import 'package:flutter_demo_app/ui/pages/login/login_page.dart';

class DecisionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    LogUtil.e("DecisionPage: createState()");
    return _DecisionPageState();
  }
}

class _DecisionPageState extends State<DecisionPage> {
  DecisionPageState? _oldState;

  @override
  Widget build(BuildContext context) {
    LogUtil.e("_DecisionPageState: build()");

    DecisionPageBloc? decisionPageBloc = BlocProvider.of<DecisionPageBloc>(context);
    return StreamBuilder<DecisionPageState>(
      stream: decisionPageBloc!.stateStream,
      initialData: decisionPageBloc.initialState??DecisionPageState.event(DecisionPageEventType.Nothing),
      builder: (ctx, snapshot) {
        if (snapshot.hasData && _oldState != snapshot.data && snapshot.data!.event != null) {
          LogUtil.e("_DecisionPageState: "+snapshot.data!.event.toString());
          _oldState = snapshot.data;
          if (snapshot.data!.event == DecisionPageEventType.LoginPage) {
            _redirectToPage(ctx, LoginPage());
          } else if (snapshot.data!.event == DecisionPageEventType.HomePage) {
            _redirectToPage(ctx, HomePage());
          }
        }
        return Container();
      },
    );
  }

  void _redirectToPage(BuildContext context, Widget page){
    WidgetsBinding.instance?.addPostFrameCallback((_){
      LogUtil.e("_DecisionPageState: _redirectToPage()");
//      MaterialPageRoute newRoute = MaterialPageRoute(
//          builder: (BuildContext context) => page
//      );
      CupertinoPageRoute newRoute = CupertinoPageRoute(
        builder: (BuildContext context) => page
      );
      Navigator.of(context).pushAndRemoveUntil(newRoute, ModalRoute.withName('/DecisionPage'));
    });
  }
}