import 'package:flutter/material.dart';
import 'package:flutter_demo_app/blocs/base/bloc_event_state.dart';
import 'package:flutter_demo_app/blocs/base/bloc_state_transform_base.dart';

typedef Widget AsyncBlocStateBuilder<BlocState>(BuildContext context, BlocState state);

class BlocStateTransformBuilder<T extends BlocState, S extends BlocState> extends StatelessWidget {
    const BlocStateTransformBuilder({
        Key? key,
        required this.builder,
        required this.transformBloc,
    }): assert(builder != null),
        assert(transformBloc != null),
        super(key: key);

    final BlocStateTransformBase<T,S> transformBloc;
    final AsyncBlocStateBuilder<T> builder; 

    @override
    Widget build(BuildContext context){
        return StreamBuilder<T>(
            stream: transformBloc.stateStream,
            initialData: transformBloc.initialState,
            builder: (context, snapshot){
                T? snap_data = null;
                if (snapshot.hasData) {
                    snap_data = snapshot.data;
                }
                if (snap_data == null) {
                    snap_data = transformBloc.initialState;
                }
                return builder(context, snap_data);
            },
        );
   }
}
