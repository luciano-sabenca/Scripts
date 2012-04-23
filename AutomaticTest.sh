#!/bin/bash

# Script para efetuar teste automaticos, comparando as respostas do Susy com as do seu programa
# Esse script baixa as entradas e saidas do susy, compila e executa seu programa, e compara as saidas do seu programa com as saidas esperadas.

# PROGRAMA DEVE SER EXECUTADO UMA PASTA ABAIXO DA PASTA DO LAB
# exemplo:

# ls susy
# lab01
# lab02
# lab15
# test.sh

# entradas: numero do lab (exemplo: 01, 03, 04b, 15)
#           quantidade de testes abertos (exemplo 02 06 16)
#           nome do programa (exemplo: 'programa', para um programa com nome programa.c)

# saida: resultado do comando diff para as saidas do seu programa e as saidas esperadas


echo '[TESTER] start'
echo
echo 'numero do lab: '
read lab;
echo 'quantidade de testes: '
read count;
echo 'nome do programa: '
read program;


cd "lab$lab"
if [ ! -d "dados" ] ;then
    mkdir dados # se a pasta dados nao existe, vamos cria-la
fi

cd dados  # entra na pasta dados
 

# agora vamos baixar todos os arquivos de testes abertos (entradas e saidas)

echo
echo '[i/o] downloading...'
for i in `seq -w 0 $count`;                #para i de 00 ateh count
do
    # so iremos baixar se ja nao tivermos baixado
    if [ ! -f 'arq'$i'.in' ] ;then
        wget http://susy.ic.unicamp.br:9999/mc102wy/$lab/dados/arq$i.in;   # baixa o arquivo de entrada
    fi
    if [ ! -f 'arq'$i'.res' ] ;then
        wget http://susy.ic.unicamp.br:9999/mc102wy/$lab/dados/arq$i.res;  # baixa o arquivo de saida
    fi
done;
echo
echo '[i/o] download completed'

cd .. 

gcc $program.c -o $program -Wall -ansi -pedantic -Werror # compila o programa e gera o executável
 
cd dados # entra no diretórios dos dados
 
echo
echo '[diff]'
echo
for i in `seq -w 0 $count`;               # variável i assume os valores 00, ..., count
     do        
    ../$program < arq$i.in > arq$i.out;   # executa o programa que está um nível abaixo
                                          # com a entrada arq%i.in e grava a saída no
                                          # arquivo arq$i.out
 
    echo '[ '$i' ]'
    diff -s arq$i.out arq$i.res;  # compara o arquivo de saída com a resposta esperada
    echo '[ /'$i' ]'
    echo
done

echo '[TESTER] completed'
echo 'copyleft Luciano P. Sabenca & Fernando H. S. Goncalves'