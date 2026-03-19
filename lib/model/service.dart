import 'dart:convert';

class Servico{
    late int id;
    late String nome;
    late double valor;
    late String descricao;
    late int idCriaServ;
    late int idPegaServ;
    late String tipoServico;
    late String disponivel;

    Servico(this.id, this.nome, this.valor, this.descricao, this.idCriaServ,
        this.idPegaServ, this.tipoServico, this.disponivel);

    factory Servico.build(String raw){
        return Servico.fromJson(jsonDecode(raw));
    }

    ///Cria um JSON a partir da class
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = "${this.id}";
        data['nome'] = this.nome;
        data['valor'] = "${this.valor}";
        data['descricao'] = this.descricao;
        data['idCriaServ'] = "${this.idCriaServ}";
        data['idPegaServ'] = "${this.idPegaServ}";
        data['tipoServico'] = this.tipoServico;
        data['disponivel'] = this.disponivel;
        return data;
    }

    ///Retorna um novo objeto a partir de um json de entrada
    factory Servico.fromJson(Map<String, dynamic> json){
        return Servico(
            int.parse(json['id']),
            json['nome'] as String,
            double.parse(json['valor']),
            json['descricao'] as String,
            int.parse(json['idCriaServ']),
            int.parse(json['idPegaServ']),
            json['tipoServico'] as String,
            json['disponivel'] as String
        );
    }

    /**
     * recebe um objeto dinâmico e preenche o objeto
     */
    Servico.map(dynamic obj){
        this.id = int.parse(obj['id']);
        this.nome = obj['nome'];
        this.valor = double.parse(obj['valor']);
        this.descricao = obj['descricao'];
        this.idCriaServ = int.parse(obj['idCriaServ']);
        this.idPegaServ = int.parse(obj['idPegaServ']);
        this.tipoServico = obj['tipoServico'];
        this.disponivel = obj['disponivel'];
    }

    Map<String, dynamic>? toMap(){
        var mapa = new Map<String, dynamic>();
        mapa["id"] = "$id";
        mapa["nome"] = "$nome";
        mapa["valor"] = "$valor";
        mapa["descricao"] = "$descricao";
        mapa["idCriaServ"] = "$idCriaServ";
        mapa["idPegaServ"] = "$idPegaServ";
        mapa["tipoServico"] = "$tipoServico";
        mapa["disponivel"] = "$disponivel";
        return mapa;
    }

}