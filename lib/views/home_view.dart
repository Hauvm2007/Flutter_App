import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'login_view.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 22, 23, 43),
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(LoggedOut());
              },
            ),
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            print('listener run');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        },
        builder: (context, state) {
          if (state is HomeState) {
            return RefreshIndicator(
              onRefresh: () async {
                // Reset the list to show the initial 10 items
                BlocProvider.of<AuthBloc>(context).add(RefreshList());
              },
              child: Container(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.items.length + 1,
                        itemBuilder: (context, index) {
                          if (index == state.items.length) {
                            return state.hasReachedMax
                              ? SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () {
                                        BlocProvider.of<AuthBloc>(context).add(LoadMoreItems());
                                      },
                                      child: Text("Show More List", style: TextStyle(color: Colors.grey),),
                                    ),
                                  ),
                                );
                          }
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(state.items[index]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
