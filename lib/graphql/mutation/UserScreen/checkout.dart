class CheckoutMutations {
  static const String create = """
    mutation CreateCheckout(
      \$id_user: Int!,
      \$id_product: Int!,
      \$id_keranjang: Int,
      \$id_alamat: Int,
      \$metode_pengiriman: String,
      \$pembayaran: String,
      \$jumlah: Int
      \$sizeP: String,

    ) {
      createCheckout(
        id_user: \$id_user,
        id_product: \$id_product,
        id_keranjang: \$id_keranjang,
        id_alamat: \$id_alamat,
        metode_pengiriman: \$metode_pengiriman,
        pembayaran: \$pembayaran,
        jumlah: \$jumlah,
        sizeP: \$sizeP
      ) {
        id_checkout
      }
    }
  """;

  static const String update = """
    mutation UpdateCheckout(
      \$id_checkout: Int!,
      \$id_alamat: Int,
      \$metode_pengiriman: String,
      \$pembayaran: String,

    ) {
      updateCheckout(
        id_checkout: \$id_checkout
        id_alamat: \$id_alamat
        metode_pengiriman: \$metode_pengiriman,
        pembayaran: \$pembayaran,
      ) {
        id_checkout
      }
    }
  """;

  // ignore: constant_identifier_names
  static const String ConfirmCheckout = """
    mutation ConfirmCheckout(\$id_checkout: Int!) {
      confirmCheckout(id_checkout: \$id_checkout) {
        message
      }
    }
  """;

  static const String delete = """
    mutation DeleteCheckout(\$id_checkout: Int!) {
      deleteCheckout(id_checkout: \$id_checkout)
    }
  """;
}