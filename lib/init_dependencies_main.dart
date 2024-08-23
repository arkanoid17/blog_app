part of 'init_dependencies.dart';


final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseAnon);

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton<Box>(()=>Hive.box(name: 'blogs'));

  serviceLocator.registerLazySingleton(() => supabase.client);
  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory(()=>InternetConnection());
  serviceLocator.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(internetConnection: serviceLocator()));
}

void _initAuth() {
  serviceLocator

  //Remote Data Source
    ..registerFactory<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ))

  //Repository

    ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator()
    ))

  //Use cases

    ..registerFactory<UserSignUp>(() => UserSignUp(
      serviceLocator(),
    ))
    ..registerFactory<UserSignIn>(() => UserSignIn(
      serviceLocator(),
    ))
    ..registerFactory<CurrentUser>(() => CurrentUser(
      serviceLocator(),
    ))

  //Bloc

    ..registerLazySingleton<AuthBloc>(() => AuthBloc(
      userSignUp: serviceLocator(),
      userSignIn: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ));
}

void _initBlog(){
  serviceLocator
  //data source
    ..registerFactory<BlogRemoteDataSource>(() => BlogRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<BlogLocalDataSource>(() => BlogLocalDataSourceImpl(box: serviceLocator()))

  //repository
    ..registerFactory<BlogRepository>(()=>BlogRepositoryImpl(serviceLocator(),serviceLocator(),serviceLocator()))

  //use case
    ..registerFactory(()=>UploadBlog(serviceLocator()))
    ..registerFactory(()=>GetAllBlogs(serviceLocator()))

  //bloc
    ..registerLazySingleton(()=>BlogBloc(
      uploadBlog: serviceLocator(),
      getAllBlogs: serviceLocator(),
    ));
}
