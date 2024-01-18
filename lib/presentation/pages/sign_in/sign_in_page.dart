import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:passkey_example/presentation/pages/base/base_page.dart';
import 'package:passkey_example/presentation/pages/sign_in/sign_in_state.dart';
import 'package:passkey_example/presentation/pages/sign_in/sign_in_viewmodel.dart';
import 'package:passkey_example/presentation/shared_widgets/app_elevated_button.dart';
import 'package:passkey_example/presentation/shared_widgets/app_outlined_button.dart';
import 'package:passkey_example/router.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  SigninViewModel get viewModel => ref.read(signinVMProvider.notifier);

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(signinVMProvider, (previous, next) {
      if (next.status == SigninStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            content: const Text('Login Successfully'),
            duration: const Duration(seconds: 10),
          ),
        );
        context.go(Routes.profile);
      }
    });
    final state = ref.watch(signinVMProvider);
    return BasePage(
      showLoading: state.status == SigninStatus.loading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sign In',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your email address',
            ),
            onChanged: viewModel.updateUserName,
          ),
          const SizedBox(height: 20),
          AppElevatedButton(
            label: 'Sign In',
            onPressed: viewModel.login,
          ),
          const SizedBox(height: 10),
          AppOutlinedButton(
            label: 'I want to create a new account',
            onPressed: () => context.go(Routes.signUp),
          ),
        ],
      ),
    );
  }
}
