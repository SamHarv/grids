import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '/logic/services/auth.dart';
import '../../data/models/grid_model.dart';
import '../../ui/views/account_view.dart';
import '../../ui/views/auth_views/forgot_password_view.dart';
import '../../ui/views/auth_views/sign_in_view.dart';
import '../../ui/views/auth_views/sign_up_view.dart';
import '../../ui/views/grid_page.dart';
import '../../ui/views/grids_view.dart';

Auth auth = Auth(); // Determine if user is signed in

final routerDelegate = BeamerDelegate(
  notFoundRedirectNamed: auth.user == null
      ? '/sign-in'
      : '/grids', // check auth status and redirect to '/home' or '/sign-in'
  initialPath: auth.user == null ? '/sign-in' : '/grids', // As above
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
          child: GridPage(grid: data as Grid, gridID: data.gridID),
        );
      },
      '/sign-in': (context, state, data) {
        return const BeamPage(
          key: ValueKey('sign-in'),
          type: BeamPageType.noTransition,
          title: 'Sign In',
          child: SignInView(),
        );
      },
      '/sign-up': (context, state, data) {
        return const BeamPage(
          key: ValueKey('sign-up'),
          type: BeamPageType.noTransition,
          title: 'Sign Up',
          child: SignUpView(),
        );
      },
      '/forgot-password': (context, state, data) {
        return const BeamPage(
          key: ValueKey('forgot-password'),
          type: BeamPageType.noTransition,
          title: 'Forgot Password',
          child: ForgotPasswordView(),
        );
      },
      '/account': (context, state, data) {
        return const BeamPage(
          key: ValueKey('account'),
          type: BeamPageType.noTransition,
          title: 'Account',
          child: AccountView(),
        );
      },
    },
  ).call,
);
