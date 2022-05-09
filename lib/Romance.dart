export 'Romance.dart';
class Romance {
  String user = "";
  String pessoaMatch = "";
  String porcentagem = "";
  String result = "";
  Romance(String user, String pessoaMatch, String porcentagem, String result){
    this.user = user;
    this.pessoaMatch =  pessoaMatch;
    this.porcentagem = porcentagem == "" ? '0' : porcentagem;
    this.result = result;
  }
}