class ProductQueries {
  static const String getAll = """
    query GetProducts(\$id_user: Int) {
      products(id_user: \$id_user) {
        id_product
        id_penjual
        brand
        kategori
        size
        deskripsi
        price
        image
        warna
        name
        stok
        id_favorite
        penjual {
          id_penjual
          nama
        }
      }
    }
  """;

  static const String getById = """
    query GetProduct(\$idProduct: Int) {
      product(id_product: \$idProduct) {
        id_product
        id_penjual
        brand
        kategori
        size
        deskripsi
        price
        image
        warna
        name
        stok
        penjual {
          id_penjual
          nama
        }
      }
    }
  """;
}
