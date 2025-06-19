class HistoryQueries {
  static const String getAll = """
    query{
      historys{
        id_history
        id_user
        id_product
        jumlah
        sizeH
        product{
          image
          name
          price
          deskripsi
          brand
          size
          warna
        }
      }
    }
  """;
}