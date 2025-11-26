double calculateSubtotal({
  required int basePrice,
  required int extraHours,
  required int extraHourPrice,
  required bool addonExtraReel,
  required int addonExtraReelPrice,
  required bool addonCustomizedEdit,
  required int addonCustomizedEditPrice,
  required bool addonHandLight,
  required int addonHandLightPrice,
}) {
  final extras = extraHours * extraHourPrice;

  final addons =
      (addonExtraReel ? addonExtraReelPrice : 0) +
      (addonCustomizedEdit ? addonCustomizedEditPrice : 0) +
      (addonHandLight ? addonHandLightPrice : 0);

  return (basePrice + extras + addons).toDouble();
}

double calculateGST(double subtotal, double gstRate) {
  return subtotal * gstRate;
}

double calculateTotal(double subtotal, double tax) {
  return subtotal + tax;
}

int parsePriceToInt(String price) {
  final digitsOnly = price.replaceAll(RegExp(r'[^0-9]'), '');
  if (digitsOnly.isEmpty) return 0;
  return int.tryParse(digitsOnly) ?? 0;
}
