import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart' as l;

void showLoader(BuildContext context) {
  l.Loader.show(context,
      progressIndicator: Loader(
        valueColor: const AlwaysStoppedAnimation(blueColor),
      ).visible(true),
      overlayColor: Colors.grey.withOpacity(0.5));
}

void hideLoader() {
  l.Loader.hide();
}
