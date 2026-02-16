import 'package:expense_splitter/core/network/api_client.dart';
import 'package:expense_splitter/core/token/token_storage.dart';
import 'package:expense_splitter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:expense_splitter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:expense_splitter/features/auth/domain/repository/auth_repository.dart';
import 'package:expense_splitter/features/auth/domain/usecases/current_user.dart';
import 'package:expense_splitter/features/auth/domain/usecases/user_login.dart';
import 'package:expense_splitter/features/auth/domain/usecases/user_register.dart';
import 'package:expense_splitter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final tokenStorage = TokenStorage();
  final apiClient = ApiClient(
    baseUrl: 'http://localhost:3000/api',
    storage: tokenStorage,
  );

  serviceLocator.registerLazySingleton(() => apiClient);
  serviceLocator.registerLazySingleton(() => tokenStorage);
  _initAuth();
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocator(), serviceLocator()),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator()),
  );

  serviceLocator.registerFactory(() => UserRegister(serviceLocator()));
  serviceLocator.registerFactory(() => UserLogin(serviceLocator()));
  serviceLocator.registerFactory(() => CurrentUser(serviceLocator()));

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userLogin: serviceLocator(),
      userRegister: serviceLocator(),
      currentUser: serviceLocator(),
    ),
  );
}
