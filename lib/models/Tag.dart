export 'Tag.dart';

class Tag {
  String Nome = "";
  int QtdEstrelas = 0;
  Tag(this.Nome, this.QtdEstrelas);
  Map<String, dynamic> TagToSend() => {"NomeTag": Nome, "Estrelas": QtdEstrelas};
}
