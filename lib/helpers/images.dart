import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  String url;
  double? height; double? width; BoxFit fit = BoxFit.cover;
  CachedImage({super.key,required this.url, this.height,this.width,required this.fit});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => Center(
        child: Container(), // Loading indicator
      ),
      errorWidget: (context, url, error) => Center(
        child: Icon(Icons.image_outlined, color: Colors.white70,size: (height??0)/1.7,), // Error widget
      ),
      fadeInDuration: Duration(milliseconds: 300), // Animation duration
      fadeOutDuration: Duration(milliseconds: 300), // Animation duration
      height: height,
      width: width,
      fit: fit,
    );
  }
}