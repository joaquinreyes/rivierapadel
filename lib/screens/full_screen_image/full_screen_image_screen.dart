import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acepadel/routes/app_pages.dart';

import '../../components/network_circle_image.dart';

class FullScreenImage extends ConsumerStatefulWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  ConsumerState<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends ConsumerState<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Hero(
            tag: 'imageHero${widget.imageUrl}',
            child: InteractiveViewer(
              child: Center(
                child: NetworkCircleImage(
                  path: widget.imageUrl,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  showBG: true,
                  isYellowBg: true,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () {
                ref.read(goRouterProvider).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
