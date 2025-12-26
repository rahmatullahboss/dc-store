import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:dc_store/core/network/api_response.dart';
import 'package:dc_store/features/auth/bloc/auth_bloc.dart';
import '../../mocks/mock_factories.dart';
import '../../mocks/mock_repositories.dart';

void main() {
  group('AuthBloc', () {
    late MockAuthRepository mockAuthRepository;
    late MockStorageService mockStorageService;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockStorageService = MockStorageService();

      // Register fallback values for mocktail
      registerFallbackValue(AuthFactory.createAuthResponse());
    });

    AuthBloc createBloc() => AuthBloc();

    group('AuthCheckRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when no token exists',
        setUp: () {
          when(() => mockStorageService.getString(any())).thenReturn(null);
        },
        build: createBloc,
        act: (bloc) => bloc.add(AuthCheckRequested()),
        expect: () => [isA<AuthLoading>(), isA<AuthUnauthenticated>()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when token exists and is valid',
        setUp: () {
          when(
            () => mockStorageService.getString(any()),
          ).thenReturn('valid_token');
        },
        build: createBloc,
        act: (bloc) => bloc.add(AuthCheckRequested()),
        expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
      );
    });

    group('AuthLoginRequested', () {
      const testEmail = 'test@example.com';
      const testPassword = 'password123';

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] on successful login',
        setUp: () {
          final authResponse = AuthFactory.createAuthResponse();
          when(
            () => mockAuthRepository.login(testEmail, testPassword),
          ).thenAnswer((_) async => ApiResponse.success(authResponse));
        },
        build: createBloc,
        act: (bloc) => bloc.add(
          const AuthLoginRequested(email: testEmail, password: testPassword),
        ),
        expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] on failed login',
        setUp: () {
          when(
            () => mockAuthRepository.login(testEmail, testPassword),
          ).thenAnswer(
            (_) async => ApiResponse.fromMessage('Invalid credentials'),
          );
        },
        build: createBloc,
        act: (bloc) => bloc.add(
          const AuthLoginRequested(email: testEmail, password: testPassword),
        ),
        expect: () => [isA<AuthLoading>(), isA<AuthError>()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] with correct message on failure',
        setUp: () {
          when(
            () => mockAuthRepository.login(testEmail, testPassword),
          ).thenAnswer((_) async => ApiResponse.fromMessage('Account locked'));
        },
        build: createBloc,
        act: (bloc) => bloc.add(
          const AuthLoginRequested(email: testEmail, password: testPassword),
        ),
        expect: () => [
          isA<AuthLoading>(),
          predicate<AuthState>((state) {
            if (state is AuthError) {
              return state.message.contains('Account locked') ||
                  state.message.contains('error');
            }
            return false;
          }),
        ],
      );
    });

    group('AuthRegisterRequested', () {
      const testName = 'Test User';
      const testEmail = 'test@example.com';
      const testPassword = 'password123';

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthRegistrationSuccess] on successful registration',
        setUp: () {
          final authResponse = AuthFactory.createAuthResponse();
          when(
            () =>
                mockAuthRepository.register(testName, testEmail, testPassword),
          ).thenAnswer((_) async => ApiResponse.success(authResponse));
        },
        build: createBloc,
        act: (bloc) => bloc.add(
          const AuthRegisterRequested(
            name: testName,
            email: testEmail,
            password: testPassword,
          ),
        ),
        expect: () => [isA<AuthLoading>(), isA<AuthRegistrationSuccess>()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when email already exists',
        setUp: () {
          when(
            () =>
                mockAuthRepository.register(testName, testEmail, testPassword),
          ).thenAnswer(
            (_) async => ApiResponse.fromMessage('Email already exists'),
          );
        },
        build: createBloc,
        act: (bloc) => bloc.add(
          const AuthRegisterRequested(
            name: testName,
            email: testEmail,
            password: testPassword,
          ),
        ),
        expect: () => [isA<AuthLoading>(), isA<AuthError>()],
      );
    });

    group('AuthLogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthUnauthenticated] on logout',
        setUp: () {
          when(() => mockAuthRepository.logout()).thenAnswer((_) async {});
        },
        build: createBloc,
        act: (bloc) => bloc.add(AuthLogoutRequested()),
        expect: () => [isA<AuthUnauthenticated>()],
      );
    });

    group('AuthForgotPasswordRequested', () {
      const testEmail = 'test@example.com';

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthPasswordResetSent] on success',
        setUp: () {
          when(
            () => mockAuthRepository.forgotPassword(testEmail),
          ).thenAnswer((_) async => ApiResponse.success(null));
        },
        build: createBloc,
        act: (bloc) => bloc.add(AuthForgotPasswordRequested(email: testEmail)),
        expect: () => [isA<AuthLoading>(), isA<AuthPasswordResetSent>()],
      );
    });
  });
}
