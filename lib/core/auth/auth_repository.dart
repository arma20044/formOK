import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form/core/auth/model/user_model.dart';
import 'package:form/model/login_model.dart';

import '../../infrastructure/login_datasource_impl.dart';
import '../../repositories/login_repository_impl.dart';
import '../api/mi_ande_api.dart';

class AuthRepository {
  

  Future<Login> login(
    String numeroDocumento,
    String password,
    String tipoDocumento,
  ) async {
    

    try {
      //llamada API
      final repoLogin = LoginRepositoryImpl(LoginDatasourceImpl(MiAndeApi()));

      Login responseLogin = await repoLogin.getLogin(
        numeroDocumento,
        password,
        tipoDocumento,
      );

      if (responseLogin.error) {
        throw Exception(responseLogin.errorValList);
      } else {
        

        
      }

      return responseLogin;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> logout() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    // Clear any stored authentication tokens
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository());
