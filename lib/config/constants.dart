import 'package:flutter/material.dart';

class Constants {

  static int userId;

  static final List WEEK_DAYS = [
    "Domingo",
    "Segunda feira",
    "Terça feira",
    "Quarta feira",
    "Quinta feira",
    "Sexta feira",
    "Sábado"
  ];

  static final List MONTHS = [
    "Janeiro",
    "Fevereiro",
    "Março",
    "Abril",
    "Maio",
    "Junho",
    "Julho",
    "Agosto",
    "Setembro",
    "Outubro",
    "Novembro",
    "Dezembro",
  ];

  static final Map ORDER_STATUS = {
    "waiting_confirmation" : "Esperando confirmação",
    "not_confirmed" : "Não confirmado",
    "confirmed" : "Confirmado",
    "in_production" : "Em produção",
    "waiting_deliveryman" : "Esperando entregador",
    "sent" : "Enviado",
    "done" : "Entregue"
  };

  static final List<String> neighborhoods = [
    "Alvorada", "Araxá", "Beirol", "Boné Azul", "Brasil Novo", "Buritizal",
    "Cabralzinho", "Central", "Cidade Nova", "Congós", "Infraero", "Jardim Equatorial",
    "Jardim Felicidade", "Jesus de Nazaré", "Laguinho", "Marco Zero", "Nova Esperança",
    "Novo Buritizal", "Novo Horizonte", "Pacoval", "Pedrinhas", "Perpétuo Socorro", "Santa Inês",
    "Santa Rita", "São Lázaro", "Trem", "Universidade", "Zerão"
  ];

  static final Map neighborhoodsTax = {
    "Alvorada" : 0,
    "Araxá" : 0,
    "Beirol" : 0,
    "Boné Azul" : 0,
    "Brasil Novo" : 0,
    "Buritizal" : 0,
    "Cabralzinho" : 0,
    "Central" : 0,
    "Cidade Nova" : 0,
    "Congós" : 0,
    "Infraero" : 0,
    "Jardim Equatorial" : 0,
    "Jardim Felicidade" : 0,
    "Jesus de Nazaré" : 0,
    "Laguinho" : 0,
    "Marco Zero" : 0,
    "Nova Esperança" : 0,
    "Novo Buritizal" : 0,
    "Novo Horizonte" : 0,
    "Pacoval" : 0,
    "Pedrinhas" : 0,
    "Perpétuo Socorro" : 0,
    "Santa Inês" : 0,
    "Santa Rita" : 0,
    "São Lázaro" : 0,
    "Trem" : 0,
    "Universidade" : 0,
    "Zerão" : 0,
  };

}