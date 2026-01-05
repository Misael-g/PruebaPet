// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'core/config/supabase_config.dart';

// Auth
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/reset_password_usecase.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/reset_password_screen.dart';

// User
import 'features/user/data/datasources/user_remote_datasource.dart';
import 'features/user/data/repositories/user_repository_impl.dart';
import 'features/user/domain/usecases/get_current_user_usecase.dart';
import 'features/user/domain/usecases/update_profile_usecase.dart';
import 'features/user/domain/usecases/upload_avatar_usecase.dart';
import 'features/user/domain/usecases/update_avatar_usecase.dart';
import 'features/user/domain/usecases/delete_avatar_usecase.dart';
import 'features/user/presentation/providers/user_provider.dart';
import 'features/user/presentation/screens/profile_screen.dart';
import 'features/user/presentation/screens/edit_profile_screen.dart';

// Pets
import 'features/pets/data/datasources/pets_remote_datasource.dart';
import 'features/pets/data/repositories/pets_repository_impl.dart';
import 'features/pets/domain/repositories/pets_repository.dart';
import 'features/pets/presentation/providers/pets_provider.dart';
import 'features/pets/presentation/screens/home_screen.dart' as pets_home;
import 'features/pets/presentation/screens/pet_detail_screen.dart';

// Favorites
import 'features/favorites/data/datasources/favorites_remote_datasource.dart';
import 'features/favorites/data/repositories/favorites_repository_impl.dart';
import 'features/favorites/presentation/providers/favorites_provider.dart';
import 'features/favorites/presentation/screens/favorites_screen.dart';

// Adoption Requests
import 'features/adoption_requests/data/datasources/adoption_requests_remote_datasource.dart';
import 'features/adoption_requests/data/repositories/adoption_requests_repository_impl.dart';
import 'features/adoption_requests/presentation/providers/adoption_requests_provider.dart';
import 'features/adoption_requests/presentation/screens/request_form_screen.dart';
import 'features/adoption_requests/presentation/screens/my_requests_screen.dart';
import 'features/adoption_requests/presentation/screens/request_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  await SupabaseConfig.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Provider
        ChangeNotifierProvider(
          create: (context) {
            final dataSource = AuthRemoteDataSourceImpl();
            final repository = AuthRepositoryImpl(remoteDataSource: dataSource);
            
            return AuthProvider(
              loginUseCase: LoginUseCase(repository),
              registerUseCase: RegisterUseCase(repository),
              resetPasswordUseCase: ResetPasswordUseCase(repository),
              authRepository: repository,
            );
          },
        ),
        
        // User Provider
        ChangeNotifierProvider(
          create: (context) {
            final dataSource = UserRemoteDataSourceImpl();
            final repository = UserRepositoryImpl(remoteDataSource: dataSource);

            return UserProvider(
              getCurrentUserUseCase: GetCurrentUserUseCase(repository),
              updateProfileUseCase: UpdateProfileUseCase(repository),
              uploadAvatarUseCase: UploadAvatarUseCase(repository),
              updateAvatarUseCase: UpdateAvatarUseCase(repository),
              deleteAvatarUseCase: DeleteAvatarUseCase(repository),
            );
          },
        ),

        // Pets Provider
        ChangeNotifierProvider(
          create: (context) {
            final dataSource = PetsRemoteDataSourceImpl();
            final repository = PetsRepositoryImpl(remoteDataSource: dataSource);
            return PetsProvider(repository: repository);
          },
        ),

        // Favorites Provider
        ChangeNotifierProvider(
          create: (context) {
            final dataSource = FavoritesRemoteDataSourceImpl();
            final repository = FavoritesRepositoryImpl(remoteDataSource: dataSource);
            return FavoritesProvider(repository: repository);
          },
        ),

        // Adoption Requests Provider
        ChangeNotifierProvider(
          create: (context) {
            final dataSource = AdoptionRequestsRemoteDataSourceImpl();
            final repository = AdoptionRequestsRepositoryImpl(remoteDataSource: dataSource);
            return AdoptionRequestsProvider(repository: repository);
          },
        ),
      ],
      child: MaterialApp(
        title: 'PetAdopt',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        routes: {
          '/': (context) => const AuthWrapper(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/reset-password': (context) => const ResetPasswordScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/edit-profile': (context) => const EditProfileScreen(),
          '/pet-detail': (context) {
            final id = ModalRoute.of(context)!.settings.arguments as String?;
            if (id == null) return const Scaffold(body: Center(child: Text('ID de mascota inválido')));
            return PetDetailScreen(petId: id);
          },
          '/favorites': (context) => const FavoritesScreen(),
          '/request-form': (context) {
            final petId = ModalRoute.of(context)!.settings.arguments as String?;
            if (petId == null) return const Scaffold(body: Center(child: Text('Pet ID requerido')));
            return RequestAdoptionScreen(petId: petId);
          },
          '/my-requests': (context) => const MyRequestsScreen(),
          '/request-detail': (context) {
            final id = ModalRoute.of(context)!.settings.arguments as String?;
            if (id == null) return const Scaffold(body: Center(child: Text('ID de solicitud inválido')));
            return RequestDetailScreen(requestId: id);
          },
        },
        initialRoute: '/',
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.status == AuthStatus.initial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (authProvider.isAuthenticated) {
          // Mostrar la pantalla de mascotas (real)
          return const pets_home.HomeScreen();
        }
        
        return const LoginScreen();
      },
    );
  }
}

// Home temporal - luego será reemplazado
class HomeScreen extends StatelessWidget {
  final user;
  
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetAdopt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, size: 100, color: Colors.deepPurple),
            const SizedBox(height: 24),
            Text(
              '¡Bienvenido ${user.nombre}!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tipo de usuario: ${user.tipoUsuario}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}