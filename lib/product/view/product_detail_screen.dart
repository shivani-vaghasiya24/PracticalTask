import 'package:flutter/material.dart';
import 'package:practical_task_2/Utils/app_colors.dart';
import 'package:practical_task_2/Utils/app_strings.dart';
import 'package:practical_task_2/Utils/util_functions.dart';
import 'package:practical_task_2/product/model/product.dart';
import 'package:practical_task_2/widgets/common_text.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    final String? productUrl =
        (product.images ?? []).isNotEmpty ? product.images![0] : null;
    return Scaffold(
      appBar: AppBar(
        title: CommonText(
          text: product.title ?? "",
          fontSize: 20,
          // fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            if (productUrl != null)
              Center(
                  child: Image.network(
                productUrl,
                height: 250,
                fit: BoxFit.contain,
              )),

            SizedBox(height: 16.0),

            // Product Description
            CommonText(
              text: product.description ?? "-",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),

            SizedBox(height: 8.0),
            CommonText(
              text: '\$${product.price}',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 8.0),
            if ((product.reviews ?? []).isNotEmpty)
              CommonText(
                text: "${AppStrings.reviews} :-",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            if ((product.reviews ?? []).isNotEmpty)
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: (product.reviews ?? []).length,
                  padding: EdgeInsets.only(top: 12, bottom: 16),
                  itemBuilder: (context, index) {
                    final review = product.reviews![index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColors.greyColor.withOpacity(0.5))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if ((review.reviewerName ?? "").isNotEmpty)
                                    CommonText(
                                      text: review.reviewerName!,
                                      fontSize: 16,
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  if ((review.date ?? "").isNotEmpty)
                                    CommonText(
                                      text: UtilFunctions.formatDateString(
                                          review.date!),
                                      fontSize: 16,
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                ],
                              ),
                            ),
                            if ((review.reviewerEmail ?? "").isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: CommonText(
                                  text: review.reviewerEmail!,
                                  color: AppColors.greyColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(2, (index) {
                                  return Icon(
                                    index < (review.rating ?? 0)
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: AppColors.darkYellow,
                                  );
                                }),
                              ),
                            ),
                            if ((review.comment ?? "").isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: CommonText(
                                  text: review.comment!,
                                  color: AppColors.blackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  })
          ],
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: ProductDetailScreen(
//       productName: "Sample Product",
//       productImage:
//           "https://via.placeholder.com/150", // Replace with your product image URL
//       productDescription: "This is a detailed description of the product.",
//     ),
//   ));
// }
