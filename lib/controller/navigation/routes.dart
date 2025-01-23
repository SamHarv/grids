import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:grids/data/auth/firebase_auth.dart';

import '/data/model/grid_model.dart';
import '/presentation/pages/account_page.dart';
import '/presentation/pages/auth_pages/forgot_password_page.dart';
import '/presentation/pages/auth_pages/sign_in_page.dart';
import '/presentation/pages/auth_pages/sign_up_page.dart';
import '/presentation/pages/grid_page.dart';
import '/presentation/pages/grids_page.dart';

FirebaseAuthService auth = FirebaseAuthService();

final routerDelegate = BeamerDelegate(
  notFoundRedirectNamed: auth.user == null ? '/sign-in' : '/grids', // as below
  initialPath: auth.user == null
      ? '/sign-in'
      : '/grids', // check auth status and redirect to '/home' or '/login'
  locationBuilder: RoutesLocationBuilder(
    routes: {
      '/grids': (context, state, data) {
        return const BeamPage(
          key: ValueKey('home'),
          type: BeamPageType.noTransition,
          title: 'grids.',
          child: GridsPage(),
        );
      },
      '/grid': (context, state, data) {
        return BeamPage(
          key: const ValueKey('grid'),
          type: BeamPageType.noTransition,
          title: 'grids.',
          child: GridPage(grid: data as GridModel, gridID: data.gridID),
        );
      },
      '/sign-in': (context, state, data) {
        return const BeamPage(
          key: ValueKey('sign-in'),
          type: BeamPageType.noTransition,
          title: 'Sign In',
          child: SignInPage(),
        );
      },
      '/sign-up': (context, state, data) {
        return const BeamPage(
          key: ValueKey('sign-up'),
          type: BeamPageType.noTransition,
          title: 'Sign Up',
          child: SignUpPage(),
        );
      },
      '/forgot-password': (context, state, data) {
        return const BeamPage(
          key: ValueKey('forgot-password'),
          type: BeamPageType.noTransition,
          title: 'Forgot Password',
          child: ForgotPasswordPage(),
        );
      },
      '/account': (context, state, data) {
        return const BeamPage(
          key: ValueKey('account'),
          type: BeamPageType.noTransition,
          title: 'Account',
          child: AccountPage(),
        );
      },
    },
  ).call,
);
