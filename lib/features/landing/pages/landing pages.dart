import 'package:appx_third_project/config/appx_data.dart';
import 'package:appx_third_project/config/appx_text.dart';
import 'package:appx_third_project/config/enum.dart';
import 'package:appx_third_project/config/theme/appx_theme.dart';
import 'package:appx_third_project/core/dependency_indection/locator.dart';
import 'package:appx_third_project/features/board/presentation/bloc/board_bloc.dart';
import 'package:appx_third_project/features/board/presentation/bloc/timer_bloc/timer_bloc.dart';
import 'package:appx_third_project/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/image_path.dart';

class TeamImage extends StatelessWidget {
  const TeamImage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * .15;
    double heightOfDevice = MediaQuery.of(context).size.height;
    return BlocBuilder<TimerBloc, TimerState>(
      bloc: locator<TimerBloc>(),
      builder: (context, timerState) {
        int timeRemining = timerState.mainDuration - timerState.duration;

        /// If the timer of each team ended we have to change the team
        /// and reastart the timer, so the bottom function will do that
        if (timerState.duration == 0) {
          locator<BoardBloc>().add(NeutralCardSelectedEvent());
        }

        final minutes = (timerState.duration ~/ 60).toString().padLeft(2, '0');
        final seconds = (timerState.duration % 60).toString().padLeft(2, '0');

        // Height of bottom shape
        double theTotalSizeOfBottomShape = 100;
        // Height of Upper shape
        double theTotalSizeOfUpperShape = 150;
        double? topPointOfUpperShape;
        double widthOfUpperShape = 0;
        Color colorOfShape = Colors.black;
        double heightOfBottomShape =
            timeRemining * theTotalSizeOfBottomShape / timerState.mainDuration;

        /// If we don't have timer functionality
        /// we have to show the whole shape
        if (timerState.noTimer) {
          heightOfBottomShape = 100;
        }

        double heightOfUpperShape =
            timeRemining *
                theTotalSizeOfUpperShape /
                timerState.mainDuration;

        if (AppxData().deviceType == DeviceType.tablet) {
          topPointOfUpperShape = (heightOfDevice / 2 - 124);
          widthOfUpperShape = width * .6;
        } else {
          topPointOfUpperShape = (heightOfDevice / 2 - 140);
          widthOfUpperShape = width * .68;
        }

        return BlocBuilder<BoardBloc, BoardState>(
          bloc: locator<BoardBloc>(),
          builder: (context, state) {
            if (state.turnTeam == WordType.blue) {
              colorOfShape = Colors.blue;
            } else if (state.turnTeam == WordType.red) {
              colorOfShape = Colors.red;
            }

            return Stack(
              children: [
                Image.asset(
                  height: double.maxFinite,
                  width: width,
                  fit: BoxFit.fill,
                  ImagePath.hourglass,
                ),

                //? The upper of the shape
                Positioned(
                  top: topPointOfUpperShape,
                  right: 0,
                  child: CustomPaint(
                    size: Size(
                        widthOfUpperShape, 150), // Adjust the size as needed
                    painter: UpperShape(
                      context: context,
                      color: colorOfShape,
                    ),
                  ),
                ),

                // Cover shpae section
                Positioned(
                  top: topPointOfUpperShape,
                  right: 0,
                  child: CustomPaint(
                    size: Size(
                      widthOfUpperShape,
                      heightOfUpperShape,
                    ), // Adjust the size as needed
                    painter: UpperShape(
                      context: context,
                      color: locator<AppColorScheme>().twilight,
                    ),
                  ),
                ),

                //? The bottom of the shpae
                Positioned(
                  bottom: heightOfDevice * .045,
                  right: 0,
                  child: CustomPaint(
                    size: Size(
                      width * .65,
                      heightOfBottomShape,
                    ), // Adjust the size as needed
                    painter: BottomShape(context: context),
                  ),
                ),

                //? Timer Section

                //? Timer
                if (!timerState.noTimer)
                  Positioned(
                    top: 29,
                    right: 17,
                    child: AppxTe
                    xt(

                      text: "$minutes : $seco
                      nds",
                      fontWeight: FontWeight.bold,
                      size:
                          AppxData().deviceType == DeviceType.tablet ? 20 : 15,
                    ),
                  )
              ],

            );
          },
        );
      },
    );
  }
}
