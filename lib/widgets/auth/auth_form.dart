import 'dart:io';
import 'package:flutter/material.dart';
import 'picker/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, {super.key});

  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
    // ignore: no_leading_underscores_for_local_identifiers
    File? _imageupload,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  // For storing validated username mail and password
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File ? _selectedImage;

  void _trySubmit() {
    // isValid will have boolean data i.e it will validate weather values in form are valid or not
    final isValid = _formKey.currentState!.validate();
    if(!isValid || !_isLogin && _selectedImage==null){
      return;
    }
    FocusScope.of(context).unfocus();
    if (isValid) {
      // This save method will trigger onSaved functions in form
      _formKey.currentState!.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _isLogin, context, _selectedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Card gives white color to form otherwise background color hi same rha jayega
      child: Card(
        margin: const EdgeInsets.all(15),
        // ScrollView so that when we open keyboard all the enties are accessible
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (!_isLogin)
                    UserImagePicker(
                      onPickImage: (pickedImage) {
                        _selectedImage=pickedImage;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value==null || value.trim().isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                    ),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Username'),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be atleast 7 characters long.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Signup')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
