import 'dart:math';
import 'package:flutter/material.dart';
import 'package:practical_task_2/Utils/app_colors.dart';
import 'package:practical_task_2/product/view/product_detail_screen.dart';
import 'package:practical_task_2/provider/product_provider.dart';
import 'package:practical_task_2/widgets/brand_selection_dialog.dart';
import 'package:practical_task_2/widgets/common_button.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Product List'),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: ElevatedButton(
                onPressed: () {
                  BrandSelectionDialog.showBrandSelectionDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.whiteColor, // Background color
                  iconColor: AppColors.primaryColor, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Radius of the button
                  ),
                ),
                child: Text(
                  "Filter",
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            // InkWell(
            //   child: CommonButton(
            //     text: "Filter",
            //     margin: EdgeInsets.all(12),
            //     buttonColor: AppColors.whiteColor,
            //     textColor: AppColors.primaryColor,
            //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            //   ),
            // )
          ],
        ),
        body: Consumer<ProductProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent) {
                  if (provider.isLoading || !provider.isMoreAvailable) {
                    return false;
                  }
                  provider.fetchProducts(false);
                }
                return false;
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, top: 12),
                        child: Row(
                          children: provider.categoryList
                              .map<Widget>((String category) {
                            return InkWell(
                              onTap: () {
                                provider.selectCategory(category);
                              },
                              child: CommonButton(
                                text: category,
                                margin: const EdgeInsets.only(right: 12),
                                buttonColor: provider.selectedCategoryList
                                        .contains(category)
                                    ? AppColors.primaryColor
                                    : AppColors.transparentColor,
                                textColor: provider.selectedCategoryList
                                        .contains(category)
                                    ? AppColors.whiteColor
                                    : AppColors.blackColor,
                                fontWeight: provider.selectedCategoryList
                                        .contains(category)
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Builder(builder: (context) {
                      if (provider.products.isEmpty) {
                        return const Center(child: Text("No Data Found"));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.products.length,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(top: 12),
                        itemBuilder: (context, index) {
                          final product = provider.products[index];
                          final String? productUrl =
                              (product.images ?? []).isNotEmpty
                                  ? product.images![0]
                                  : null;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                          product: product,
                                        )),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 12, left: 12, right: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColors.greyColor
                                            .withOpacity(0.5))),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 2),
                                        child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.28,
                                              maxHeight: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.28,
                                            ),
                                            child: productUrl != null
                                                ? Image.network(
                                                    productUrl,
                                                    height: 250,
                                                    width: 150,
                                                    fit: BoxFit.fill,
                                                  )
                                                : const Icon(Icons.error)),
                                      ),
                                      if ((product.discountPercentage ?? 0)
                                              .toDouble() >
                                          0)
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Transform.rotate(
                                            angle: -pi / 4,
                                            child: Container(
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  color: AppColors.greenColor),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2),
                                                child: Text(
                                                  '${product.discountPercentage}%',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          AppColors.whiteColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    ]),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 2),
                                                    child: Text(
                                                      product.title ?? "-",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 2),
                                                  child: Text(
                                                    product.description ?? "-",
                                                    maxLines: 2,
                                                    // overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 2),
                                                  child: Text(
                                                    product.brand ?? "N/A",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 2),
                                                  child: Text(
                                                    '\$${product.price}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    if (provider.isLoading && provider.isMoreAvailable)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Center(child: CircularProgressIndicator()),
                      )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
