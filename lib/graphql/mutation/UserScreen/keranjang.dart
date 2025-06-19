class KeranjangMutations {
  static const String create = """
    mutation CreateKeranjang(
      \$jumlah : Int!,
      \$id_user: Int!,
      \$id_product: Int!,
      \$sizeK: String!
    ) {
      createKeranjang(
        jumlah: \$jumlah,
        id_user: \$id_user,
        id_product: \$id_product,
        sizeK: \$sizeK
      ) {
        id_keranjang
      }
    }
  """;

  static const String updateJumlah = """
    mutation UpdateKeranjang(
      \$id_keranjang: Int!
      \$jumlah : Int,
    ) {
      updateKeranjang(
        id_keranjang: \$id_keranjang
        jumlah: \$jumlah,
      ) {
        id_keranjang
        jumlah
      }
    }
  """;

  static const String delete = """
    mutation DeleteKeranjang(\$id_keranjang: Int!) {
      deleteKeranjang(id_keranjang: \$id_keranjang) {
        message
      }
    }
  """;
}