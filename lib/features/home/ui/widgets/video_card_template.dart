import 'package:flutter/material.dart';

class VideoCardTemplate extends StatelessWidget {
  final String imagePath;
  final String description;
  final String title;
  final String duration;
  final int views;
  final String status;
  final VoidCallback? onTap;

  const VideoCardTemplate({
    super.key,
    required this.imagePath,
    required this.description,
    required this.title,
    required this.duration,
    required this.views,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Color(0xff264653),
                      size: 28,
                    ),
                  ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff2A9D8F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Tajawal",
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // العنوان
                    Text(
                      title,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Tajawal",
                        color: Color(0xff264653),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // الوصف
                    if (description.isNotEmpty)
                      Text(
                        description,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: "Tajawal",
                        ),
                      ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(
                          Icons.visibility_rounded,
                          size: 20,
                          color: Color(0xffA67500),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$views",
                          style: const TextStyle(
                            color: Color(0xffA67500),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Tajawal",
                            fontSize: 16,
                          ),
                        ),

                        const Spacer(),

                        const Icon(
                          Icons.access_time_rounded,
                          size: 20,
                          color: Color(0xff92A1A1),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          duration,
                          style: const TextStyle(
                            color: Color(0xff92A1A1),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Tajawal",
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}