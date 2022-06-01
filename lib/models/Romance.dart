export 'Romance.dart';

class Romance {
  String user = "";
  String pessoaMatch = "";
  String porcentagem = "";
  String result = "";
  Romance(this.user, this.pessoaMatch, String porcentagem, this.result){
    this.porcentagem = porcentagem == "" ? '0' : porcentagem;
  }
}