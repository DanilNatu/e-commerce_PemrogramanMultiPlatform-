class FavoriteMutations {
  static const String create = """
    mutation CreateFavorite(
      \$id_user: Int!, 
      \$id_product: Int!
    ) {
      createFavorite(
        id_user: \$id_user, 
        id_product: \$id_product
      ) {
        id_favorite
      }
    }
  """;

  static const String delete = """
    mutation DeleteFavorite(\$id_favorite: Int!) {
      deleteFavorite(id_favorite: \$id_favorite) {
        message
      }
    }
  """;
}
