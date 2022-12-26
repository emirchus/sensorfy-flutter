import 'package:flutter/material.dart';

class CustomAppbar extends SliverPersistentHeaderDelegate {
  final String title;

  const CustomAppbar({required this.title});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    bool canPop = Navigator.canPop(context);
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: preferredSize.height,
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withOpacity(.8),
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: canPop
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {},
                    color: Colors.white,
                  )
                : Image.network(
                    "https://github.com/JunkieLabs/sensify-android/blob/main/images/sensify-logo.png?raw=true",
                    height: 30,
                  ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Size get preferredSize => const Size.fromHeight(84);

  @override
  double get maxExtent => preferredSize.height;

  @override
  double get minExtent => preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
