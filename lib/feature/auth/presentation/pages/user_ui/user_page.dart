import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/feature/auth/presentation/bloc/user/useevent.dart';
import 'package:project_manager/feature/auth/presentation/bloc/user/userbloc.dart';
import 'package:project_manager/feature/auth/presentation/bloc/user/userstate.dart';


class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(LoadUsersEvent());

    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý người dùng')),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) return const Center(child: CircularProgressIndicator());
          if (state is UserError) return Center(child: Text('Error: ${state.message}'));
          if (state is UserLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  leading: const Icon(Icons.account_circle_rounded),
                  title: Text(user.username),
                  subtitle: Text('Role: ${user.role}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (role) {
                      context.read<UserBloc>().add(UpdateUserRoleEvent(
                            userId: user.id,
                            newRole: role,
                          ));
                    },
                    itemBuilder: (context) => ['ADMIN', 'LEADER', 'STAFF']
                        .map((r) => PopupMenuItem(value: r, child: Text(r)))
                        .toList(),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
