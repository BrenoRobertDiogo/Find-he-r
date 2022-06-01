export 'Pessoa.dart';
import 'Tag.dart';

class Pessoa {
  String? sexo;
  String? nome;
  String? imagem;
  int? idade;
  List<Tag>? tags;
  Pessoa([this.nome, this.sexo, this.imagem, this.idade, this.tags]);

}