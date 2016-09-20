#!/usr/bin/python
# -*- coding: utf-8 -*-
import telebot as tb
import sys
API_TOKEN='<COLOCAR_AQUI_O_TOKEN_DA_API>'
DESTINATARIO=sys.argv[1]
ASSUNTO=sys.argv[2]
MENSAGEM=sys.argv[3].replace('/n','\n')
alerta = tb.TeleBot(API_TOKEN)
alerta.send_message(DESTINATARIO, ASSUNTO + '\n' + MENSAGEM, disable_web_page_preview=True, parse_mode='HTML')
