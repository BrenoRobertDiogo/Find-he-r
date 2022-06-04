export 'Pessoa.dart';
import 'Tag.dart';

class Pessoa {
  String? sexo;
  String? nome;
  String? senha;
  String? imagem;
  int? idade;
  List<Tag>? tags;
  Pessoa([this.nome, this.senha,this.sexo, this.imagem, this.idade, this.tags]);
}