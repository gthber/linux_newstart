#!/usr/bin/env bash
#简单的shell英语词典
while [ TRUE ]
do
	clear
	read -p '>' word
	curl -s dict://dict.org/d:${word} > /tmp/word.log
	more +5 /tmp/word.log|sed 'N;$!P;$!D;$d'|sed '$d'|less
done
