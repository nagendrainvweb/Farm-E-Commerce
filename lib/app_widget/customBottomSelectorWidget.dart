import 'package:flutter/material.dart';
import 'package:lotus_farm/style/app_colors.dart';

class CustomSelectWidegt extends StatelessWidget {
  const CustomSelectWidegt({
    Key key, this.title, this.list, this.selectedText, this.onItemClicked,
    
  }) : super(key: key);

  final String title;
  final List<String> list;
  final String selectedText;
  final Function onItemClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 8.0, bottom: 8, left: 12, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$title",
                  textScaleFactor: 1.2,
                  style: TextStyle(color: Colors.black87),
                ),
                IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
          ),
          Container(height: 1, color: AppColors.grey400),
          Flexible(
              child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: list.length,
                  separatorBuilder: (_, index) =>
                      Container(height: 1, color: AppColors.grey200),
                  itemBuilder: (_, index) => ListTile(
                      title: Text(
                        "${list[index]}",
                        style: TextStyle(
                          color: (list[index] == selectedText)
                              ? AppColors.orange
                              : AppColors.blackLight,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        onItemClicked(index);
                      },
                      trailing: (list[index] == selectedText)
                          ? Icon(Icons.check, color: AppColors.orange)
                          : Container(
                              width: 0,
                            ))))
        ],
      ),
    );
  }
}
