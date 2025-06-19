class AlamatMutations {
  static const String create = """
    mutation CreateAlamat(
      \$id_user: Int!,
      \$namaA: String!,
      \$alamat: String!,
      \$teleponA: String!
    ) {
      createAlamat(
        id_user: \$id_user,
        namaA: \$namaA,
        alamat: \$alamat,
        teleponA: \$teleponA
      ) {
        id_alamat
        id_user
        namaA
        alamat
        teleponA
        alamat_utama
      }
    }
  """;

  static const String update = """
    mutation UpdateAlamat(
      \$id_alamat: Int!,
      \$namaA: String!,
      \$alamat: String!,
      \$teleponA: String!
    ) {
      updateAlamat(
        id_alamat: \$id_alamat,
        namaA: \$namaA,
        alamat: \$alamat,
        teleponA: \$teleponA
      ) {
        id_alamat
        id_user
        namaA
        alamat
        teleponA
        alamat_utama
      }
    }
  """;

  static const String setDefault = """
    mutation AlamatUtama(
      \$id_alamat: Int!,
      \$id_user: Int!
    ) {
      alamatUtama(
        id_alamat: \$id_alamat,
        id_user: \$id_user
      ) {
        message
      }
    }
  """;

  static const String delete = """
    mutation DeleteAlamat(\$id_alamat: Int!) {
      deleteAlamat(id_alamat: \$id_alamat) {
        message
      }
    }
  """;
}