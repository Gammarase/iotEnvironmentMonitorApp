import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/network/api_client.dart';
import 'core/network/network_info.dart';
import 'core/storage/secure_storage.dart';

// Auth
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/home/presentation/providers/navigation_provider.dart';

// Devices
import 'features/devices/data/datasources/devices_remote_datasource.dart';
import 'features/devices/data/repositories/devices_repository_impl.dart';
import 'features/devices/domain/usecases/get_devices_usecase.dart';
import 'features/devices/domain/usecases/get_device_details_usecase.dart';
import 'features/devices/domain/usecases/create_device_usecase.dart';
import 'features/devices/domain/usecases/update_device_usecase.dart';
import 'features/devices/domain/usecases/delete_device_usecase.dart';
import 'features/devices/presentation/providers/devices_provider.dart';
import 'features/devices/presentation/providers/device_details_provider.dart';

// Recommendations
import 'features/recommendations/data/datasources/recommendations_remote_datasource.dart';
import 'features/recommendations/data/repositories/recommendations_repository_impl.dart';
import 'features/recommendations/domain/usecases/get_recommendations_usecase.dart';
import 'features/recommendations/domain/usecases/get_pending_recommendations_usecase.dart';
import 'features/recommendations/domain/usecases/get_recommendation_details_usecase.dart';
import 'features/recommendations/domain/usecases/acknowledge_recommendation_usecase.dart';
import 'features/recommendations/domain/usecases/dismiss_recommendation_usecase.dart';
import 'features/recommendations/presentation/providers/recommendations_provider.dart';

// Statistics
import 'features/statistics/data/datasources/sensor_readings_remote_datasource.dart';
import 'features/statistics/data/repositories/sensor_readings_repository_impl.dart';
import 'features/statistics/domain/usecases/get_current_reading_usecase.dart';
import 'features/statistics/domain/usecases/get_readings_history_usecase.dart';
import 'features/statistics/presentation/providers/statistics_provider.dart';

// Profile
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/usecases/get_profile_usecase.dart';
import 'features/profile/domain/usecases/update_profile_usecase.dart';
import 'features/profile/presentation/providers/profile_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core dependencies
  final secureStorage = SecureStorage(const FlutterSecureStorage());
  final networkInfo = NetworkInfo(Connectivity());
  final apiClient = ApiClient(
    secureStorage: secureStorage,
    baseUrl: AppConfig.apiBaseUrl,
  );

  // Auth dependencies
  final authRemoteDataSource = AuthRemoteDataSourceImpl(apiClient: apiClient);
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    secureStorage: secureStorage,
    networkInfo: networkInfo,
  );

  // Auth use cases
  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);
  final logoutUseCase = LogoutUseCase(authRepository);
  final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);

  // Devices dependencies
  final devicesRemoteDataSource = DevicesRemoteDataSourceImpl(apiClient: apiClient);
  final devicesRepository = DevicesRepositoryImpl(
    remoteDataSource: devicesRemoteDataSource,
    networkInfo: networkInfo,
  );

  // Devices use cases
  final getDevicesUseCase = GetDevicesUseCase(devicesRepository);
  final getDeviceDetailsUseCase = GetDeviceDetailsUseCase(devicesRepository);
  final createDeviceUseCase = CreateDeviceUseCase(devicesRepository);
  final updateDeviceUseCase = UpdateDeviceUseCase(devicesRepository);
  final deleteDeviceUseCase = DeleteDeviceUseCase(devicesRepository);

  // Recommendations dependencies
  final recommendationsRemoteDataSource = RecommendationsRemoteDataSourceImpl(apiClient: apiClient);
  final recommendationsRepository = RecommendationsRepositoryImpl(
    remoteDataSource: recommendationsRemoteDataSource,
    networkInfo: networkInfo,
  );

  // Recommendations use cases
  final getRecommendationsUseCase = GetRecommendationsUseCase(recommendationsRepository);
  final getPendingRecommendationsUseCase = GetPendingRecommendationsUseCase(recommendationsRepository);
  final getRecommendationDetailsUseCase = GetRecommendationDetailsUseCase(recommendationsRepository);
  final acknowledgeRecommendationUseCase = AcknowledgeRecommendationUseCase(recommendationsRepository);
  final dismissRecommendationUseCase = DismissRecommendationUseCase(recommendationsRepository);

  // Statistics dependencies
  final sensorReadingsRemoteDataSource = SensorReadingsRemoteDataSourceImpl(apiClient: apiClient);
  final sensorReadingsRepository = SensorReadingsRepositoryImpl(
    remoteDataSource: sensorReadingsRemoteDataSource,
    networkInfo: networkInfo,
  );

  // Statistics use cases
  final getCurrentReadingUseCase = GetCurrentReadingUseCase(sensorReadingsRepository);
  final getReadingsHistoryUseCase = GetReadingsHistoryUseCase(sensorReadingsRepository);

  // Profile dependencies
  final profileRepository = ProfileRepositoryImpl(authRepository: authRepository);

  // Profile use cases
  final getProfileUseCase = GetProfileUseCase(profileRepository);
  final updateProfileUseCase = UpdateProfileUseCase(profileRepository);

  runApp(
    MultiProvider(
      providers: [
        // Core providers
        Provider<SecureStorage>.value(value: secureStorage),
        Provider<NetworkInfo>.value(value: networkInfo),
        Provider<ApiClient>.value(value: apiClient),

        // Auth provider
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
            logoutUseCase: logoutUseCase,
            getCurrentUserUseCase: getCurrentUserUseCase,
          ),
        ),

        // Navigation provider
        ChangeNotifierProvider<NavigationProvider>(
          create: (_) => NavigationProvider(),
        ),

        // Devices providers
        ChangeNotifierProvider<DevicesProvider>(
          create: (_) => DevicesProvider(
            getDevicesUseCase: getDevicesUseCase,
            createDeviceUseCase: createDeviceUseCase,
            updateDeviceUseCase: updateDeviceUseCase,
            deleteDeviceUseCase: deleteDeviceUseCase,
          ),
        ),
        ChangeNotifierProvider<DeviceDetailsProvider>(
          create: (_) => DeviceDetailsProvider(
            getDeviceDetailsUseCase: getDeviceDetailsUseCase,
          ),
        ),

        // Recommendations provider
        ChangeNotifierProvider<RecommendationsProvider>(
          create: (_) => RecommendationsProvider(
            getRecommendationsUseCase: getRecommendationsUseCase,
            getPendingRecommendationsUseCase: getPendingRecommendationsUseCase,
            getRecommendationDetailsUseCase: getRecommendationDetailsUseCase,
            acknowledgeRecommendationUseCase: acknowledgeRecommendationUseCase,
            dismissRecommendationUseCase: dismissRecommendationUseCase,
          ),
        ),

        // Statistics provider
        ChangeNotifierProvider<StatisticsProvider>(
          create: (_) => StatisticsProvider(
            getCurrentReadingUseCase: getCurrentReadingUseCase,
            getReadingsHistoryUseCase: getReadingsHistoryUseCase,
          ),
        ),

        // Profile provider
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(
            getProfileUseCase: getProfileUseCase,
            updateProfileUseCase: updateProfileUseCase,
          ),
        ),

        // Feature providers will be added here
      ],
      child: const MyApp(),
    ),
  );
}
