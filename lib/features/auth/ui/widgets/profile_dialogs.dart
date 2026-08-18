import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/profile_provider.dart';
import 'edit_major_dialog.dart';
import 'edit_name_dialog.dart';

class ProfileDialogs {
  static Future<void> showEditName(
      BuildContext context,
      ) async {
    final provider =
    context.read<ProfileProvider>();

    final profile =
        provider.profile;

    if (profile == null) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (_) {
        return EditNameDialog(
          firstName:
          profile.firstName,
          lastName:
          profile.lastName,
          onUpdated:
          provider.refreshProfile,
        );
      },
    );
  }

  static Future<void> showEditMajor(
      BuildContext context,
      ) async {
    final provider =
    context.read<ProfileProvider>();

    final profile =
        provider.profile;

    if (profile == null) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (_) {
        return EditMajorDialog(
          currentMajor:
          profile.major,
          onUpdated:
          provider.refreshProfile,
        );
      },
    );
  }
}