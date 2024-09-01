import 'package:flutter/material.dart';
import 'package:practical_task_2/provider/product_provider.dart';
import 'package:practical_task_2/widgets/common_text.dart';
import 'package:provider/provider.dart';

class BrandSelectionDialog {
  static void showBrandSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final provider = Provider.of<ProductProvider>(context, listen: false);

        return AlertDialog(
          title: Center(
            child: Text(
              "Select Brands",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          content:
              Consumer<ProductProvider>(builder: (context, provider, child) {
            return SingleChildScrollView(
              child: provider.brandList.isNotEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: provider.brandList.map<Widget>((String brand) {
                        return CheckboxListTile(
                          title: Text(
                            brand,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          value: provider.selectedBrandList.contains(brand),
                          onChanged: (bool? selected) {
                            provider.selectBrand(brand);
                            // provider.toggleBrandSelection(brand);
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      }).toList(),
                    )
                  : Center(
                      child: CommonText(text: "No Data Found"),
                    ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
