import 'package:rxdart/rxdart.dart';

import 'bloc_event_state.dart';
import 'bloc_provider.dart';

///
/// Based class used for the transformation of a states
///
abstract class BlocStateTransformBase<T, S extends BlocState> implements BlocBase {
    //
    // Initial State
    //
    final T initialState;

    //
    // Transformed States
    //
    BehaviorSubject<T> _stateController = BehaviorSubject<T>();
    Stream<T> get stateStream => _stateController.stream;

    //
    // [Must Override] state handler
    //
    Stream<T> stateHandler({T currentState, S transformState});

    //
    // Constructor
    //
    BlocStateTransformBase({
        required this.initialState,
        required BlocEventStateBase<BlocEvent, S> blocIn,
    }){
        assert(blocIn != null);
        assert(blocIn is BlocEventStateBase<BlocEvent, BlocState>);

        blocIn.stateStream.listen((transformStateIn){
            T currentState = initialState;
            if (_stateController.hasValue) {
                currentState = _stateController.value ?? initialState;
            }

            stateHandler(currentState: currentState, transformState: transformStateIn).forEach((T newState){
                _stateController.sink.add(newState);
            });
        });
    }

    @override
    void dispose(){
        _stateController?.close();
    }
}
