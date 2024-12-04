import 'dart:developer';
import 'dart:io';
import 'package:appx_third_project/config/appx_text.dart';
import 'package:appx_third_project/config/enum.dart';
import 'package:appx_third_project/config/theme/appx_theme.dart';
import 'package:appx_third_project/core/dependency_indection/locator.dart';
import 'package:appx_third_project/features/premium/domain/usecases/entitlements_check_usecase.dart';
import 'package:appx_third_project/features/premium/domain/usecases/fetch_offering_usecase.dart';
import 'package:appx_third_project/features/premium/domain/usecases/fetch_product_usecase.dart';
import 'package:appx_third_project/features/premium/domain/usecases/purchase_package.dart';
import 'package:appx_third_project/features/premium/domain/usecases/set_up_purhcase_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_purchase_event.dart';
part 'app_purchase_state.dart';

class AppPurchaseBloc extends Bloc<AppPurchaseEvent, AppPurchaseState> {
  final FetchOfferingUsecase fetchOfferingUsecase;
  final FetchProductUsecase fetchProductUsecase;
  final PurchasePackageUsecase purchasePackageUsecase;
  final SetUpPurchaseUsecase setUpPurchaseUsecase;
  final EntitlementsCheckUsecase entitlementsCheckUsecase;
  AppPurchaseBloc({
    required this.fetchOfferingUsecase,
    required this.fetchProductUsecase,
    required this.purchasePackageUsecase,
    required this.setUpPurchaseUsecase,
    required this.entitlementsCheckUsecase,
  }) : super(const AppPurchaseState(loading: false)) {
    on<AppPurchaseStartEvent>(
      (event, emit) async {
        bool internet = await checkInternet();
        if (!internet) {
          return;
        }
        try {
          showDialog(
            context: event.context!,
            builder: (_) => Center(
              child: CircularProgressIndicator(
                color: locator<AppColorScheme>().babyBlue,
              ),
            ),
          );
          await setUpPurchaseUsecase.call();

          List<Offering> offering = await fetchOfferingUsecase.call();
          // The Package of offering for purchase wich user selected
          Package? premiumPackage;
          for (var offer in offering) {
            if (offer.identifier
                .contains(premiumConverterToString(event.premiumTypeEnum))) {
              premiumPackage = offer.lifetime!;
            }
          }

          CustomerInfo customerInfo =
              await purchasePackageUsecase.call(params: premiumPackage);

          if (customerInfo.entitlements.active.values.isNotEmpty) {
            emit(AppPurchaseState(
                premiums: event.premiumTypeEnum, loading: false));

            locator<SharedPreferences>().setString(
                "purchase", premiumConverterToString(event.premiumTypeEnum));
            Navigator.pop(event.context!);
            // showDialog(
            //   context: event.context!,
            //   builder: (context) => Dialog(
            //     backgroundColor: AppxTheme.of().colorScheme.buttonBackground,
            //     child: const AppPurchaseCompletedPage(),
            //   ),
            // );
          } else {
            add(const AppPurchaseCheckedEvent(init: true));
          }
        } catch (e) {
          if (e.toString().contains(" own ") ||
              e.toString().contains("ITEM_ALREADY_OWNED") ||
              e.toString().contains("is already active") ||
              e.toString().contains("PRODUCT_ALREADY_PURCHASED")) {
            emit(const AppPurchaseState(
                premiums: PremiumTypeEnum.mainTheme, loading: false));
            locator<SharedPreferences>().setString(
                "purchase", premiumConverterToString(event.premiumTypeEnum));
            Navigator.pop(event.context!);
            // showDialog(
            //   context: event.context!,
            //   builder: (context) => Dialog(
            //     backgroundColor: AppxTheme.of().colorScheme.buttonBackground,
            //     child: const AppPurchaseCompletedPage(),
            //   ),
            // );
          } else {
            add(const AppPurchaseCheckedEvent(init: false));
            // emit(AppPurchaseError(e.toString()));
            Navigator.pop(event.context!);
          }
        }
      },
    );

    on<AppPurchaseCheckedEvent>((event, emit) async {
      await setUpPurchaseUsecase.call();
      String? purchas = locator<SharedPreferences>().getString("purchase");
      if (purchas != null) {
        emit(AppPurchaseState(
            premiums: premiumConverterToEnum(purchas), loading: false));
      } else {
        List<EntitlementInfo> entitlementInfo =
            await entitlementsCheckUsecase.call();
        if (entitlementInfo.isNotEmpty) {
          if (entitlementInfo.length >= 2) {
            // emit(
            //   const AppPurchaseState(
            //       premiums: PremiumTypeEnum.full, loading: false),
            // );
            // locator<SharedPreferences>().setString("purchase", "full");
          } else {
            String identifier = entitlementInfo.first.identifier;
            final premium = premiumConverterToEnum(identifier);
            emit(
              AppPurchaseState(premiums: premium, loading: false),
            );
            locator<SharedPreferences>().setString(
              "purchase",
              identifier,
            );
          }
        } else if (!event.init) {
          ScaffoldMessenger.of(event.context!).showSnackBar(
            const SnackBar(
              content: AppxText(
                text: "You Don't have any purchase",
                size: 20,
              ),
            ),
          );
        }
      }
    });
  }

  Future<bool> checkInternet() async {
    try {
      var checkInternet = await InternetAddress.lookup("google.com");
      if (checkInternet.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  String premiumConverterToString(PremiumTypeEnum premiumType) {
    switch (premiumType) {
      // case PremiumTypeEnum.categories:
      //   return "categories";

      // case PremiumTypeEnum.full:
      //   return "full";
      // case PremiumTypeEnum.skin:
      //   return "skin";
      case PremiumTypeEnum.mainTheme:
        return "mainTheme";
      case PremiumTypeEnum.noads:
        return "no_add_pro_feature_life";
    }
  }

  PremiumTypeEnum premiumConverterToEnum(String premiumType) {
    switch (premiumType) {
      // case "categories":
      //   return PremiumTypeEnum.categories;
      // case "full":
      //   return PremiumTypeEnum.full;
      // case "skin":
      //   return PremiumTypeEnum.skin;
      case "mainTheme":
        log("purchase item converter to enaum ....mainTheme");
        return PremiumTypeEnum.mainTheme;
      case "no_add_pro_feature_life":
        log("purchase item converter to enaum .... no_add_pro_feature_life");
        return PremiumTypeEnum.noads;
      default:
        return PremiumTypeEnum.mainTheme;
    }
  }

  // PremiumTypeEnum premiumConverterToEnum2(String premiumType) {
  //   if (premiumType.contains("categor")) {
  //     return PremiumTypeEnum.categories;
  //   } else if (premiumType.contains("full")) {
  //     return PremiumTypeEnum.full;
  //   } else if (premiumType.contains("ad")) {
  //     return PremiumTypeEnum.noAds;
  //   } else if (premiumType.contains("flexible")) {
  //     return PremiumTypeEnum.flexible;
  //   } else if (premiumType.contains("skin")) {
  //     return PremiumTypeEnum.skin;
  //   } else {
  //     return PremiumTypeEnum.full;
  //   }
  // }

  // PremiumTypeEnum premiumConverterToEnum(String premiumType) {
  //   switch (premiumType) {
  //     case  "categories":
  //       return PremiumTypeEnum.categories;
  //     case "full":
  //       return PremiumTypeEnum.full;
  //     case "skin":
  //       return PremiumTypeEnum.skin;
  //     case "flexible":
  //       return PremiumTypeEnum.flexible;
  //     case "noads":
  //       return PremiumTypeEnum.noAds;
  //     default:
  //       return PremiumTypeEnum.full;
  //   }
  // }
}
