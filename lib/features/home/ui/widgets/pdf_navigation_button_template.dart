import 'package:flutter/material.dart';

class PdfNavigationButtonTemplate
    extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final bool primary;

  const PdfNavigationButtonTemplate({
    super.key,
    required this.title,
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.primary,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    if (primary) {
      return SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed:
          enabled ? onTap : null,
          style:
          ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor:
            const Color(
              0xff2A9D8F,
            ),
            disabledBackgroundColor:
            const Color(
              0xffD9DFDE,
            ),
            foregroundColor:
            Colors.white,
            disabledForegroundColor:
            const Color(
              0xffA7B0AF,
            ),
            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                15,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Text(
                title,
                style:
                const TextStyle(
                  fontFamily:
                  'Tajawal',
                  fontSize: 14,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              Icon(
                icon,
                size: 20,
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed:
        enabled ? onTap : null,
        style:
        OutlinedButton.styleFrom(
          foregroundColor:
          const Color(
            0xff2A9D8F,
          ),
          disabledForegroundColor:
          const Color(
            0xffAAB4B3,
          ),
          side: BorderSide(
            color: enabled
                ? const Color(
              0xff2A9D8F,
            )
                : const Color(
              0xffDDE3E2,
            ),
          ),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              15,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
            ),
            const SizedBox(
              width: 7,
            ),
            Text(
              title,
              style:
              const TextStyle(
                fontFamily:
                'Tajawal',
                fontSize: 14,
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}