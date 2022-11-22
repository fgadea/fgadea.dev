import 'package:fgadea.dev/models/iterpreter_model.dart';
import 'package:flutter/material.dart';

import '../models/app_directory.dart';
import 'application_filesystem.dart';

class CommandPrompt {
  static AppDirectory prevDir = getDirectory();
  static AppDirectory dir = getDirectory();
  static const String _welcome = '''
██╗  ██╗███████╗██╗     ██╗      ██████╗ 
██║  ██║██╔════╝██║     ██║     ██╔═══██╗
███████║█████╗  ██║     ██║     ██║   ██║
██╔══██║██╔══╝  ██║     ██║     ██║   ██║
██║  ██║███████╗███████╗███████╗╚██████╔╝
╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝ ╚═════╝ 
                                                                         
I'm Felipe Gadea, welcome to my personal website, this works like regular terminal.

Type '-help' to show commands you can use
''';

  static const String _help = "This is help";

  static InterpreterModel interpreter(BuildContext context, String command) {
    String text = "";
    Color? color;
    List<String> commands = command.split(' ');
    bool clear = false;
    switch (commands.first) {
      case "welcome":
        text = _welcome;
        break;
      case "clr":
      case "clear":
        clear = true;
        break;
      case "pwd":
        text = dir.path;
        break;
      case "ls":
      case "dir":
        text = "\nDirectory: ${dir.path}\n";
        text += "\nName\n----\n";
        for (final AppDirectory? item in dir.items ?? []) {
          text += "${item?.path.split("/").last}\n";
        }
        break;
      case "cd":
        if (commands.length == 1) {
          text =
              "$command : The term '$command' is not recognised. Verify that the command is correct and try again.";
          color = Colors.red;
          break;
        }
        if (commands[1] == "..") {
          dir = prevDir;
        } else {
          var finalDir = dir.items?.firstWhere(
            (element) => element.path.endsWith(
              commands[1],
            ),
          );
          if (finalDir == null) break;
          prevDir = dir;
          dir = finalDir;
        }
        text = "\nDirectory: ${dir.path}\n";
        text += "\nName\n----\n";
        for (final AppDirectory? item in dir.items ?? []) {
          text += "${item?.path.split("/").last}\n";
        }
        break;
      case "open":
        if (commands.length == 1) {
          text =
              "$command : The term '$command' is not recognised. Verify that the command is correct and try again.";
          color = Colors.red;

          break;
        }
        if (commands[1] == "resumen.pdf") {
          showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              content: Text(
                "This is under development",
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        }
        break;
      case "help":
      case "h":
      case "-h":
      case "-help":
        text = _help;
        break;
      default:
        text =
            "$command : The term '$command' is not recognised. Verify that the command is correct and try again.";
        color = Colors.red;
    }

    final textW = Text(
      text,
      style: TextStyle(color: color ?? Colors.white),
    );
    return InterpreterModel(text: textW, clear: clear);
  }
}
