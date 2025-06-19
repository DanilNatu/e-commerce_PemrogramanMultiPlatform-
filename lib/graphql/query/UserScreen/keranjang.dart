class KeranjangQueries {
  static const String getAll = """
    query{
      keranjangs{
        id_keranjang
        id_user
        id_product
        jumlah
        sizeK
        product{
          image
          name
          price
          brand
          warna
        }
      }
    }
  """;
}