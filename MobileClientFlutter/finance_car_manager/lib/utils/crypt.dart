import 'package:encrypt/encrypt.dart';

class Crypt{
  Key key;
  IV iv;
  Encrypter encrypter;
  Crypt.initialize(){
    key = Key.fromUtf8(')f!i#n%an@)c#(0e_Ca(r_Ma#nage(r*');
    iv = IV.fromLength(16);
    encrypter = Encrypter(AES(key));
  }

  String encrypt(String text){
    return encrypter.encrypt(text, iv: iv).base64;
  }
}
