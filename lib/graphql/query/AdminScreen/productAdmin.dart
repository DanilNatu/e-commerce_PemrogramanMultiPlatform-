class ProductAdminQueries {
  static const String getAll = """
    query{
      products{
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

  static const String getById = """
    query GetProduct(\$idProduct: Int!) {
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