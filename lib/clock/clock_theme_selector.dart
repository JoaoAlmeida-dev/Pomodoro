import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'controller/clock_theme/clock_theme_cubit.dart';

class ClockThemeSelector extends StatelessWidget {
  const ClockThemeSelector({
    super.key,
  });

  static final Map<MaterialColor, String> availableColors = {
    Colors.red: "red",
    Colors.pink: "pink",
    Colors.purple: "purple",
    Colors.deepPurple: "deepPurple",
    Colors.indigo: "indigo",
    Colors.blue: "blue",
    Colors.lightBlue: "lightBlue",
    Colors.cyan: "cyan",
    Colors.teal: "teal",
    Colors.green: "green",
    Colors.lightGreen: "lightGreen",
    Colors.lime: "lime",
    Colors.yellow: "yellow",
    Colors.amber: "amber",
    Colors.orange: "orange",
    Colors.deepOrange: "deepOrange",
    Colors.brown: "brown",
    Colors.blueGrey: "blueGrey",
  };

  @override
  Widget build(BuildContext context) {
    return Wrap(
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.spaceEvenly,
        spacing: 20,
        children: [
          BlocBuilder<ClockThemeCubit, ClockThemeState>(
            builder: (context, state) {
              return DropdownButton<MaterialColor>(
                menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                value: state.foreground,
                icon: Icon(Icons.alarm, color: state.foreground),
                items: availableColors.entries
                    .map(
                      (entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Row(
                          children: [
                            Icon(Icons.color_lens, color: entry.key),
                            Text(
                              entry.value.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: entry.key),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged:
                    BlocProvider.of<ClockThemeCubit>(context).changeForeground,
              );
            },
          ),
          BlocBuilder<ClockThemeCubit, ClockThemeState>(
            builder: (context, state) {
              return DropdownButton<MaterialColor>(
                menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                icon: Icon(Icons.circle, color: state.background),
                value: state.background,
                items: availableColors.entries
                    .map(
                      (entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Row(
                          children: [
                            Icon(Icons.color_lens, color: entry.key),
                            Text(
                              entry.value.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: entry.key),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged:
                    BlocProvider.of<ClockThemeCubit>(context).changeBackground,
              );
            },
          ),
        ]);
  }
}
