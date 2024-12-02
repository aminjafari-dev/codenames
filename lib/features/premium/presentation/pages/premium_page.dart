
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
