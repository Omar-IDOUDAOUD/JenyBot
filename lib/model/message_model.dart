import 'dart:async';

class MessageModel{
  final MessageOwner owner;
  final String content;
  final bool error; 
  

  MessageModel( {required this.owner, required this.content, this.error = false});  
}


enum MessageOwner{user, gpt}

