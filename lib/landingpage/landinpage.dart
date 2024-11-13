import 'package:appx_third_project/admin_key/admin_info_page.dart';
import 'package:appx_third_project/config/appx_padding.dart';
import 'package:appx_third_project/config/appx_strings.dart';
import 'package:appx_third_project/config/appx_text.dart';
import 'package:appx_third_project/config/enum.dart';
import 'package:appx_third_project/config/image_path.dart';
import 'package:appx_third_project/config/theme/appx_theme.dart';
import 'package:appx_third_project/core/dependency_indection/locator.dart';
import 'package:appx_third_project/core/page%20rout/page_rout.dart';
import 'package:appx_third_project/core/widgets/appx_button.dart';
import 'package:appx_third_project/core/widgets/appx_scaffold.dart';
import 'package:appx_third_project/features/premium/presentation/bloc/app_purchase_bloc.dart';
import 'package:appx_third_project/features/premium/presentation/widgets/premium_dialog.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppColorScheme theme = AppxTheme.of().colorScheme;

    return AppxScaffold(
      isInHome: true,
      padding: AppxPadding.all_0,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                ImagePath.spotLight,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            width: 210,
            height: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppxButton(
                  onPressed: () {
                    Navigator.pushNamed(context, PageName.createGame);
                  },
                  text: AppxStrings.createGame,
                ),
                AppxButton(
                  onPressed: () {
                    Navigator.pushNamed(context, PageName.spymaster);
                  },
                  text: AppxStrings.connectSpymaster,
                ),
                AppxButton(
                  onPressed: () {
                    Navigator.pushNamed(context, PageName.howToPlay);
                  },
                  text: AppxStrings.howToPlay,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            child: GestureDetector(
              onTap: () {
                tapFunction(context);

    // locator<AppPurchaseBloc>()
    //     .add(AppPurchaseStartEvent(premiumTypeEnum: PremiumTypeEnum.noAds));
              },
              child: AppxText(
                text: AppxStrings.copyRight,
                color: theme.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
