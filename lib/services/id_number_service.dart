class IDNumberService {
  bool validateSAId(String id) {
    // Ensure the ID is exactly 13 digits and numeric.
    if (id.length != 13 || !RegExp(r'^\d+$').hasMatch(id)) {
      return false;
    }

    // Step 1: Sum digits in odd positions (using 0-based indexing for positions 0, 2, 4, 6, 8, 10).
    int sumOdd = 0;
    for (int i = 0; i < 12; i += 2) {
      sumOdd += int.parse(id[i]);
    }

    // Step 2: Concatenate digits in even positions (positions 1, 3, 5, 7, 9, 11), then multiply the resulting number by 2.
    String evenDigits = "";
    for (int i = 1; i < 12; i += 2) {
      evenDigits += id[i];
    }
    int evenNumber = int.parse(evenDigits);
    int product = evenNumber * 2;

    // Step 3: Sum all digits of the product.
    int sumEven = 0;
    for (var digit in product.toString().split('')) {
      sumEven += int.parse(digit);
    }

    // Step 4: Calculate the total sum.
    int totalSum = sumOdd + sumEven;

    // Step 5: Calculate the check digit.
    // If totalSum % 10 is 0, check digit is 0; otherwise, it's 10 - (totalSum % 10)
    int calculatedCheckDigit = (10 - (totalSum % 10)) % 10;

    // Step 6: Compare the calculated check digit with the 13th digit of the ID.
    int actualCheckDigit = int.parse(id[12]);

    return calculatedCheckDigit == actualCheckDigit;
  }
}
