class QuadraModel {
  String? id;
  String? nome;
  String? endereco;
  String? bairro;
  int? numero;
  String? cidade;
  String? imagem;
  int? telefone;

  String? horaAberto;
  String? horaFecha;

  static final quadras = [
    QuadraModel(),
  ];

  QuadraModel(
      {this.id,
      this.nome,
      this.endereco,
      this.bairro,
      this.cidade,
      this.numero,
      this.imagem,
      this.telefone,
      this.horaAberto,
      this.horaFecha});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nome": nome,
      "endereço": endereco,
      "Bairro": bairro,
      "número": numero,
      "cidade": cidade,
      "imagem": imagem,
      "telefone": telefone,
      "Hora que abre": horaAberto,
      "Hora que fecha": horaFecha
    };
  }

  factory QuadraModel.fromMap(Map<String, dynamic> map) {
    return QuadraModel(
        id: map['id'],
        nome: map['nome'],
        endereco: map['endereço'],
        bairro: map['Bairro'],
        cidade: map['cidade'],
        numero: map['número'],
        imagem: map['imagem'],
        telefone: map['telefone'],
        horaAberto: map['Hora que abre'],
        horaFecha: map['Hora que fecha']);
  }
}
