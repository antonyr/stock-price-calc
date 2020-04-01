import 'package:flutter/widgets.dart';

findNormalizedPrice(
    TextEditingController shareCountController,
    TextEditingController averageCostController,
    TextEditingController currentUnitPrice,
    purchasableQuantity) {
  var currentStockPrice = double.parse(currentUnitPrice.text);
  var purchasedShares = int.parse(shareCountController.text);
  var averagePrice = double.parse(averageCostController.text);
  var totalPrice = averagePrice * purchasedShares;
  var newlySpentPrice = purchasableQuantity * currentStockPrice;
  var result =
      (totalPrice + newlySpentPrice) / (purchasableQuantity + purchasedShares);
  return result;
}

findPurchasableQuantity(availableAmountController, currentUnitPriceController) {
  var availableAmount = double.parse(availableAmountController.text);
  var currentStockPrice = double.parse(currentUnitPriceController.text);
  return availableAmount ~/ currentStockPrice;
}

reset(TextEditingController sharesCountController, totalPriceController,
    currentUnitPriceController, availableAmountController) {
  sharesCountController.clear();
  totalPriceController.clear();
  currentUnitPriceController.clear();
  availableAmountController.clear();
}
