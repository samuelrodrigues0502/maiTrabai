import 'dart:convert';

class Usuario {
  late int id;
  late String nomeUsuario;
  late String nomeReal;
  late String senha;
  late String cpf;
  late String dataNasc;
  late int qtdLike;

  Usuario(this.id, this.nomeUsuario, this.nomeReal, this.senha, this.cpf,
      this.dataNasc, this.qtdLike);
  Usuario.vazio();

  factory Usuario.build(String raw){
    return Usuario.fromJson(jsonDecode(raw));
  }

  ///Cria um JSON a partir da class
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = "${this.id}";
    data['nomeUsuario'] = this.nomeUsuario;
    data['nomeReal'] = this.nomeReal;
    data['senha'] = this.senha;
    data['cpf'] = this.cpf;
    data['dataNasc'] = this.dataNasc;
    data['qtdLike'] = "${this.qtdLike}";
    return data;
  }

  ///Retorna um novo objeto a partir de um json de entrada
  factory Usuario.fromJson(Map<String, dynamic> json){
    return Usuario(
        int.parse(json['id']),
        json['nomeUsuario'] as String,
        json['nomeReal'] as String,
        json['senha'] as String,
        json['cpf'] as String,
        json['dataNasc'] as String,
        int.parse(json['qtdLike']),
    );
  }

  /**
   * recebe um objeto dinâmico e preenche o objeto
   */
  Usuario.map(dynamic obj){
    this.id = int.parse(obj['id']);
    this.nomeUsuario = obj['nomeUsuario'];
    this.nomeReal = obj['nomeReal'];
    this.senha = obj['senha'];
    this.cpf = obj['cpf'];
    this.dataNasc = obj['dataNasc'];
    this.qtdLike = int.parse(obj['qtdLike']);
  }

  Map<String, dynamic>? toMap(){
    var mapa = new Map<String, dynamic>();
    mapa["id"] = "$id";
    mapa["nomeUsuario"] = "$nomeUsuario";
    mapa["nomeReal"] = "$nomeReal";
    mapa["senha"] = "$senha";
    mapa["cpf"] = "$cpf";
    mapa["dataNasc"] = "$dataNasc";
    mapa["qtdLike"] = "$qtdLike";
    return mapa;
  }
}