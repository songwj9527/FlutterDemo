import 'package:flutter/material.dart';
import 'package:flutter_demo_app/blocs/base/bloc_event_state.dart';

typedef Widget AsyncBlocStateBuilder<BlocState>(BuildContext context, BlocState state);

class BlocEventStateBuilder<BlocState> extends StatelessWidget {
  const BlocEventStateBuilder({
    Key? key,
    required this.builder,
    required this.bloc,
  }): assert(builder != null),
      assert(bloc != null),
      super(key: key);

  final BlocEventStateBase<BlocEvent,BlocState> bloc;
  final AsyncBlocStateBuilder<BlocState> builder;

  @override
  Widget build(BuildContext context){
    return StreamBuilder<BlocState>(
      stream: bloc.stateStream,
      initialData: bloc.initialState,
      builder: (context, snapshot){
        BlocState? snap_data = null;
        if (snapshot.hasData) {
          snap_data = snapshot.data;
        }
        if (snap_data == null) {
          snap_data = bloc.initialState;
        }
        return builder(context, snap_data!);
      },
    );
  }
}