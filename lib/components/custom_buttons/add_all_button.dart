import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:musicplayerandroid/providers/info_provider.dart';
import 'package:musicplayerandroid/providers/selection_provider.dart';
import 'package:musicplayerandroid/utils/fluenticons/fluenticons.dart';
import 'package:provider/provider.dart';

class AddAllButton extends StatelessWidget {
  const AddAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectionProvider>(
      builder: (context, selectionProvider, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: selectionProvider.selected.isNotEmpty
            ? ElevatedButton.icon(
              onPressed: () async {
                final paths = selectionProvider.selected.values.toList();
                InfoProvider().addToQueue(paths);
                selectionProvider.clear();
                BotToast.showText(text: "Added ${paths.length} song(s) to queue.");
              },
              label: const Text("Add all to queue"),
              icon: const Icon(FluentIcons.addMultiple),
            iconAlignment: IconAlignment.end,
            )
            : const SizedBox(),
        );
      },
    );
  }
}