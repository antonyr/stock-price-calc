import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:try_app/events.dart';
import 'package:mockito/mockito.dart';

class MockTextController extends Mock implements TextEditingController {}

void main() {
  test(
      'findNormalizedPrice should return normalized price after purchasing stocks with the given amount',
      () {
    var sharesCountController = MockTextController();
    var averageCostController = MockTextController();
    var currentUnitPriceController = MockTextController();

    when(sharesCountController.text).thenReturn('5');
    when(averageCostController.text).thenReturn('25.0');
    when(currentUnitPriceController.text).thenReturn('20');

    var normalizedPrice = findNormalizedPrice(sharesCountController,
        averageCostController, currentUnitPriceController, 50);

    expect(normalizedPrice, equals('20.45'));
  });

  test(
      'findNormalizedPrice should return normalized price after purchasing number of stocks',
      () {
    var sharesCountController = MockTextController();
    var averageCostController = MockTextController();
    var currentUnitPriceController = MockTextController();

    when(sharesCountController.text).thenReturn('5');
    when(averageCostController.text).thenReturn('25.0');
    when(currentUnitPriceController.text).thenReturn('20');

    var normalizedPrice = findNormalizedPrice(sharesCountController,
        averageCostController, currentUnitPriceController, 50);

    expect(normalizedPrice, equals('20.45'));
  });

  test(
      'findPurchasableQuantity should return how many stocks can we buy with the given amount',
      () {
    var availableAmountController = MockTextController();
    var currentUnitPriceCntroller = MockTextController();

    when(availableAmountController.text).thenReturn('1000');
    when(currentUnitPriceCntroller.text).thenReturn('20.0');

    var purchasableQuantity = findPurchasableQuantity(
        availableAmountController, currentUnitPriceCntroller);

    expect(purchasableQuantity, equals(50));
  });
}
