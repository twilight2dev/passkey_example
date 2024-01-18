import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:passkey_example/presentation/pages/base/base_page.dart';
import 'package:passkey_example/presentation/pages/sign_up/sign_up_state.dart';
import 'package:passkey_example/presentation/pages/sign_up/sign_up_viewmodel.dart';
import 'package:passkey_example/router.dart';
import 'package:passkey_example/presentation/shared_widgets/app_elevated_button.dart';
import 'package:passkey_example/presentation/shared_widgets/app_outlined_button.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  SignupViewModel get viewModel => ref.read(signupVMProvider.notifier);

  final _emailController = TextEditingController();
  // String? _error;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signupVMProvider);
    return BasePage(
      showLoading: state.status == SignupStatus.loading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sign Up',
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
            label: 'Sign Up',
            onPressed: viewModel.signUp,
          ),
          const SizedBox(height: 10),
          AppOutlinedButton(
            label: 'I already have an account',
            onPressed: () => context.go(Routes.signIn),
          ),
        ],
      ),
    );
  }
}
