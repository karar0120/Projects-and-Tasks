import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectsandtasks/core/styles/Colors.dart';
import 'package:projectsandtasks/core/utils/route/app_router.dart';
import 'package:projectsandtasks/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';
import 'package:projectsandtasks/shared/widgets/button_widget.dart';
import 'package:projectsandtasks/shared/widgets/form_field_widget.dart';
import 'package:projectsandtasks/shared/widgets/GeneralComponents.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;

  String _tr(String key) => AppLocalizations.of(context)?.trans(key) ?? key;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submitRegister() {
    context.read<AuthCubit>().register(
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          doneBotToast(title: _tr('register_success'));
          _navigateToLogin();
        }
        if (state is AuthError) {
          errorBotToast(title: state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          backgroundColor: ColorConsts.backgroundColor,
          appBar: GeneralAppBar(
            title: Text(_tr('register')),

            leading:IconButton(icon: const Icon(Icons.arrow_back_ios, color: ColorConsts.whiteColor, size: 22), onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false)), 
            centerTitle: true,
            
           ),
          
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _tr('register'),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: ColorConsts.gunmetalBlue,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _tr('register_subtitle'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorConsts.textColor,
                            height: 1.4,
                          ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: ColorConsts.gunmetalBlue.withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (state is AuthError) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: ColorConsts.tomato.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: ColorConsts.tomato.withOpacity(0.5)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline, color: ColorConsts.tomato, size: 22),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      state.message,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: ColorConsts.tomato,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          DefaultFormField(
                            labelText: _tr('username'),
                            controller: _usernameController,
                            type: TextInputType.text,
                            focusNode: _usernameFocus,
                            onSubmit: () => _emailFocus.requestFocus(),
                            onChange: () => context.read<AuthCubit>().clearError(),
                            onTap: () {},
                            validate: () {},
                            prefixPressed: () {},
                            suffixPressed: () {},
                            obscureText: false,
                          ),
                          const SizedBox(height: 16),
                          DefaultFormField(
                            labelText: _tr('email'),
                            controller: _emailController,
                            type: TextInputType.emailAddress,
                            focusNode: _emailFocus,
                            onSubmit: () => _passwordFocus.requestFocus(),
                            onChange: () => context.read<AuthCubit>().clearError(),
                            onTap: () {},
                            validate: () {},
                            prefixPressed: () {},
                            suffixPressed: () {},
                            obscureText: false,
                          ),
                          const SizedBox(height: 16),
                          DefaultFormField(
                            labelText: _tr('password'),
                            controller: _passwordController,
                            type: TextInputType.visiblePassword,
                            focusNode: _passwordFocus,
                            onSubmit: _submitRegister,
                            onChange: () => context.read<AuthCubit>().clearError(),
                            onTap: () {},
                            validate: () {},
                            prefixPressed: () {},
                            suffixPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                            suffixIcon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: ColorConsts.gunmetalBlue,
                            ),
                            obscureText: _obscurePassword,
                          ),
                          const SizedBox(height: 24),
                          InkWell(
                            onTap: isLoading ? null : _submitRegister,
                            borderRadius: BorderRadius.circular(8),
                            child: GeneralButton(
                              title: _tr('register'),
                              height: 52,
                              isLoading: isLoading,
                              loadingSize: 0.05,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: DefaultTextButton(
                        title: _tr('already_have_account'),
                        onTap: _navigateToLogin,
                        align: AlignmentDirectional.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToLogin() {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }
}
