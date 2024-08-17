import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodels/login_viewmodel.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginViewModel _loginViewModel;
  final List<String> _allItems = List.generate(30, (index) => "Item ${index + 1}");

  AuthBloc(this._loginViewModel) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
    on<LoadMoreItems>(_onLoadMoreItems);
    on<RefreshList>(_onRefreshList);
  }

  //Check Login Status when start app
  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final isLoggedIn = await _loginViewModel.checkLoginStatus();
    if (isLoggedIn) {
      emit(HomeState(items: _allItems.take(10).toList()));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  //Press button Login
  void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    try {
      final success = await _loginViewModel.login(event.email, event.password);
      if (success) {
        emit(HomeState(items: _allItems.take(10).toList()));
      } else {
        emit(AuthFailure('Invalid email or password'));
        emit (AuthUnauthenticated());
      }
    } catch (error) {
      emit(AuthFailure('An error occurred'));
      emit (AuthUnauthenticated());
    }
  }

  //Press button logout
  void _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await _loginViewModel.logout();
    emit(AuthUnauthenticated());
  }

  //Show more list
  void _onLoadMoreItems(LoadMoreItems event, Emitter<AuthState> emit) {
    final currentState = state;
    if (currentState is HomeState && !currentState.hasReachedMax) {
      final itemsToShow = currentState.items.length + 10;
      emit(currentState.copyWith(
        items: _allItems.take(itemsToShow).toList(),
        hasReachedMax: itemsToShow >= _allItems.length,
      ));
    }
  }

  //pull down to refresh 
  void _onRefreshList(RefreshList event, Emitter<AuthState> emit) {
    emit(HomeState(items: _allItems.take(10).toList()));
  }
}
