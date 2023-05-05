import 'package:empire_expert/common/colors.dart';
import 'package:flutter/material.dart';

class SerivceCard extends StatefulWidget {
  final String backgroundImage;
  final String title;
  final String price;
  final String usageCount;
  final String rating;
  final String tag;

  const SerivceCard({
    super.key,
    required this.backgroundImage,
    required this.title,
    required this.price,
    required this.usageCount,
    required this.rating,
    required this.tag,
  });

  @override
  State<SerivceCard> createState() => _SerivceCardState();
}

class _SerivceCardState extends State<SerivceCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [
          Stack(children: [
            SizedBox(
              width: double.infinity,
              height: 200,
              child: widget.backgroundImage != "null"
                  ? ClipRRect(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        widget.backgroundImage,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      "assets/image/error-image/no-image.png",
                      fit: BoxFit.fitWidth,
                    ),
            ),
            Positioned(
              left: 10,
              top: 10,
              child: Container(
                width: 100,
                height: 40,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: Text(
                    widget.tag,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ]),
          ListTile(
            title: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Container(
              decoration: const BoxDecoration(
                  color: AppColors.searchBarColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              height: 35,
              width: 70,
              child: Center(
                child: Text(
                  widget.price,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Divider(
              color: Colors.grey[400],
            ),
          ),
          ListTile(
            title: RichText(
                text: TextSpan(
                    text: widget.usageCount,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                    ),
                    children: const [
                  TextSpan(
                    text: " luợt sử dụng",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ])),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.orange[400],
                ),
                Text(widget.rating),
              ],
            ),
          )
        ],
      ),
    );
  }
}
