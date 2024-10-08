import 'package:fgadea_dev/common/command_prompt_commands.dart';
import 'package:fgadea_dev/features/flbash_terminal/presentation/bloc/flutter_shell_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlutterShell extends StatelessWidget {
  final bool isMobile;
  const FlutterShell({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<FlutterShellBloc>(context),
      child: BlocConsumer<FlutterShellBloc, FlutterShellState>(
        listener: (context, state) {
          state.inputFieldController.selection = TextSelection.collapsed(
              offset: state.inputFieldController.text.length);
          Future.delayed(const Duration(milliseconds: 100), () {
            state.listController.animateTo(
                state.listController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 100),
                curve: Curves.linear);
          });
        },
        builder: (context, state) {
          return Flexible(
            fit: FlexFit.tight,
            child: Container(
              color: Colors.black,
              child: ListView.builder(
                controller: state.listController,
                padding: const EdgeInsets.all(12),
                shrinkWrap: true,
                itemCount: state.shellData.length + 1,
                itemBuilder: ((context, index) =>
                    shellListViewBuilder(context, index, state)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget shellListViewBuilder(
      BuildContext context, int index, FlutterShellState state) {
    if (index == state.shellData.length) {
      return InputField(context, state);
    }
    return CommandPrompt.interpreter(context, state.shellData[index]).text;
  }

  Widget InputField(BuildContext context, FlutterShellState state) {
    state.inputFieldController.selection = state.inputFieldController.selection
        .copyWith(extentOffset: state.inputFieldController.text.length);
    return TextField(
      controller: state.inputFieldController,
      focusNode: state.focusNode,
      autofocus: true,
      showCursor: true,
      readOnly: isMobile,
      cursorColor: Colors.green,
      cursorWidth: 10,
      onEditingComplete: () {
        BlocProvider.of<FlutterShellBloc>(context)
            .add(FlutterShellCommand(state.inputFieldController.text));
      },
      // onSubmitted: (value) {
      //   BlocProvider.of<FlutterShellBloc>(context)
      //       .add(FlutterShellCommand(value));
      // },
      decoration: null,
    );
  }
}
