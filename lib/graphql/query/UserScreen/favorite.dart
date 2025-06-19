class FavoriteQueries {
  static const String getAll = """
    query{
      favorites{
        id_favorite
        id_user
        id_product
        product{
          image
          name
          price
          kategori
          brand
          deskripsi
          size
          stok
          warna
        }
      }
    }
  """;
}