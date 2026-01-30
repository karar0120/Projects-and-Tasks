import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectsandtasks/core/constants/cache_consts.dart';
import 'package:projectsandtasks/core/styles/Colors.dart';
import 'package:projectsandtasks/core/utils/route/app_router.dart';
import 'package:projectsandtasks/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:projectsandtasks/shared/services/localeServices/locale_services.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';
import 'package:projectsandtasks/shared/widgets/button_widget.dart';
import 'package:projectsandtasks/shared/widgets/form_field_widget.dart';
import 'package:projectsandtasks/shared/widgets/GeneralComponents.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;

  String _tr(String key) => AppLocalizations.of(context)?.trans(key) ?? key;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submitLogin() {
    context.read<AuthCubit>().login(
          _usernameController.text,
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess) {
          _saveTokenAndNavigate(state.response.token);
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
            title: Text(_tr('login')),
            leading: const SizedBox.shrink(),
            centerTitle: true,
            actions: [
              IconButton(icon: const Icon(Icons.language, color: ColorConsts.gunmetalBlue, size: 22), onPressed: () => {}),
            ],
           ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      _tr('login'),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: ColorConsts.gunmetalBlue,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _tr('login_subtitle'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorConsts.textColor,
                            height: 1.4,
                          ),
                    ),
                    const SizedBox(height: 32),
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
                            onSubmit: _submitLogin,
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
                            onTap: isLoading ? null : _submitLogin,
                            borderRadius: BorderRadius.circular(8),
                            child: GeneralButton(
                              title: _tr('login'),
                              height: 52,
                              isLoading: isLoading,
                              loadingSize: 0.05,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        const Expanded(child: Divider(color: ColorConsts.dividerColor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            _tr('or'),
                            style: TextStyle(
                              color: ColorConsts.textColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: ColorConsts.dividerColor)),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child: DefaultTextButton(
                        title: _tr('dont_have_account'),
                        onTap: () => _navigateToRegister(),
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

  Future<void> _saveTokenAndNavigate(String token) async {
    await LocaleServices.setData(key: CacheConsts.accessToken, value: token);
    if (!mounted) return;
    doneBotToast(title: _tr('login_success'));
    _navigateToHome();
  }

  void _navigateToRegister() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.register);
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }
}
