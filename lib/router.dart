import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrcode_app/home/view/home_page.dart';
import 'package:qrcode_app/login/view/login_page.dart';
import 'package:qrcode_app/register/view/first_register.dart';
import 'package:qrcode_app/register/view/register_page.dart';
import 'package:qrcode_app/util/constant.dart';

import 'change_password/view/change_password_page.dart';

// const String loginRoute = '/login';
const String homeRoute = '/home';
const String signUpRoute = '/signup';
const String fsignUpRoute = '/fsignup';
const String changePassRoute = '/changePass';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) {
        return getBoolAsync(kIsLoggedIn, defaultValue: false)
            ? homeRoute
            : fsignUpRoute;

        /*  ? const StoreBottomNavigation()
                : const CustomerBottomNavigation(); */
      },
      //builder: (context, state) => const NewsListPage(),
    ),
    /*  GoRoute(
      path: '/news/:id',
      builder: (context, state) => NewsPage(
        id: state.params['id']!,
      ),
    ), */
    GoRoute(
      path: homeRoute,
      builder: (context, state) => const MyHomePage(),
    ),

    // GoRoute(
    //   path: loginRoute,
    //   builder: (context, state) => const LoginPage(),
    // ),

    GoRoute(
      path: signUpRoute,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: fsignUpRoute,
      builder: (context, state) => const FirstRegisterPage(),
    ),
    GoRoute(
      path: changePassRoute,
      builder: (context, state) => const ChangePasswordPage(),
    ),
    /* path: '/news/:id',
      builder: (context, state) => NewsPage(
        id: state.params['id']!,
      ), */
    //CustomerStoreViewScreen
/*     GoRoute(
      path: '$customerStoreViewRoute/:storeId',
      builder: (context, state) => CustomerStoreViewScreen(
        storeId: state.params['storeId']!,
      ),
    ),

    GoRoute(
      path: mapViewRoute,
      builder: (context, state) {
        LatLng position = state.extra as LatLng;
        return MapScreen(
          initialPosNew: position,
        );
      },
    ),
    GoRoute(
      path: '$guestUserStoreViewRoute/:categoryId',
      builder: (context, state) => GuestUserStoreView(
        categoryId: state.params['categoryId']!,
      ),
    ),
    GoRoute(
      path: createStoryRoute,
      builder: (context, state) => const CreateStory(),
    ),
    GoRoute(
      path: '$storeRoute/:categoryId/:isGuestUser',
      builder: (context, state) => Store(
        categoryId: state.params['categoryId']!,
        isGuestUser: state.params['isGuestUser']!,
      ),
    ),
    GoRoute(
      path: viewAllStoriesRoute,
      builder: (context, state) {
        List<Story?>? stories = state.extra as List<Story?>?;

        return ViewAllStories(
          stories: stories,
          index: 0,
        );
      },
    ),
    GoRoute(
      path: '$otpVerificationRoute/:phoneNumber/:isStore',
      builder: (context, state) => OtpVerificationScreen(
        phoneNumber: state.params['phoneNumber']!,
        isStore: state.params['isStore']!,
      ),
    ),

    /* ViewStory(
                                      storeId: newList[index]!.id.toString(),
                                      storeName: 
                                          newList[index]!.storeName,
                                      isFollowed: newList[index]!.isFollowed,
                                      storeArName: newList[index]!.storeArName,
                                    ), */

    GoRoute(
      path:
          '$viewStoryRoute/:storeId/:storeName/:isFollowed/:storeArName:/categoryId',
      builder: (context, state) => ViewStory(
        storeId: state.params['storeId']!,
        storeName: state.params['storeName']!,
        storeArName: state.params['storeArName']!,
        isFollowed: state.params['isFollowed']!,
        categoryId: state.params['categoryId']!,
      ),
    ),
    GoRoute(
      path:
          '$guestUserViewStoryRoute/:storeId/:storeName/:isFollowed/:storeArName',
      builder: (context, state) => GuestUserViewStory(
        storeId: state.params['storeId']!,
        storeName: state.params['storeName']!,
        storeArName: state.params['storeArName']!,
        isFollowed: state.params['isFollowed']!,
      ),
    ), */
  ],
);
