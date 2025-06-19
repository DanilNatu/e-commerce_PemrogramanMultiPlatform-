class ProductMutations {
  static const String create = """
    mutation CreateProduct(
      \$idPenjual: Int!,
      \$kategori: String,
      \$price: Int,
      \$size: String,
      \$deskripsi: String,
      \$brand: String,
      \$image: String,
      \$warna: String,
      \$name: String!,
      \$stok: Int!
    ) {
      createProduct(
        id_penjual: \$idPenjual,
        kategori: \$kategori,
        size: \$size,
        deskripsi: \$deskripsi,
        brand: \$brand,
        price: \$price,
        image: \$image,
        warna: \$warna,
        name: \$name,
        stok: \$stok
      ) {
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

  static const String update = """
    mutation UpdateProduct(
      \$idProduct: Int!,
      \$kategori: String,
      \$price: Int,
      \$size: String,
      \$deskripsi: String,
      \$brand: String,
      \$image: String,
      \$warna: String,
      \$name: String,
      \$stok: Int
    ) {
      updateProduct(
        id_product: \$idProduct,
        kategori: \$kategori,
        size: \$size,
        deskripsi: \$deskripsi,
        brand: \$brand,
        price: \$price,
        image: \$image,
        warna: \$warna,
        name: \$name,
        stok: \$stok
      ) {
        id_product
      }
    }
  """;

  static const String updateStok = """
    mutation UpdateProductStok(
      \$id_product: Int!,
      \$stok: Int!
    ) {
      updateProductStok(
        id_product: \$id_product,
        stok: \$stok
      ) {
        id_product
        stok
      }
    }
  """;

  static const String delete = """
    mutation DeleteProduct(\$idProduct: Int!) {
      deleteProduct(id_product: \$idProduct) {
        message
      }
    }
  """;
}
