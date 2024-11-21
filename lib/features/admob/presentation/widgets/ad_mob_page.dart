import 'package:appx_third_project/config/appx_data.dart';
import 'package:appx_third_project/config/appx_padding.dart';
import 'package:appx_third_project/config/enum.dart';
import 'package:appx_third_project/config/theme/appx_theme.dart';
import 'package:appx_third_project/core/dependency_indection/locator.dart';
import 'package:appx_third_project/features/board/presentation/widgets/spymaster_toolbar.dart';
import 'package:appx_third_project/features/board/presentation/widgets/words_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

class SpymasterBoardPage extends StatefulWidget {
  const SpymasterBoardPage({super.key});

  @override
  State<SpymasterBoardPage> createState() => _SpymasterBoardPageState();
}

class _SpymasterBoardPageState extends State<SpymasterBoardPage> {
  final theme = locator<AppColorScheme>();

  @override
  void initState() {
    super.initState();
    // Set landscape orientation when this screen is initialized
    Wakelock.enable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    // Reset to portrait orientation when leaving the screen
    Wakelock.disable();

    if (AppxData().deviceType == DeviceType.mobile) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppColorScheme theme = locator<AppColorScheme>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.twilight,
        body: _body(),
      ),
    );
  }

  _body() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (AppxData().deviceType == DeviceType.mobile)
          Container(
            width: 77,
            padding: const EdgeInsets.only(left: 24, top: 17, bottom: 17),
            child: SpymasterToolBar(),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (AppxData().deviceType == DeviceType.tablet)
                Container(
                  padding: AppxPadding.v17_h19,
                  child: SpymasterToolBar(),
                ),
              Expanded(
                child: WordsBoard(
                  isSpymaster: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
