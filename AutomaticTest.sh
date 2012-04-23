#!/bin/bash

# Script para efetuar teste automaticos, comparando as respostas do Susy com as do seu programa
# Esse script baixa as entradas e saidas do susy, compila e executa seu programa, e compara as saidas do seu programa com as saidas esperadas.

# Deve ser executado na pasta que contem o codigo fonte do programa


# entradas: numero do lab (exemplo: 01, 03, 04b, 15)
#           quantidade de testes abertos (exemplo 02 06 16)
#           nome do programa (exemplo: 'programa', para um programa com nome programa.c)

# saida: resultado do comando diff para as saidas do seu programa e as saidas esperadas

# Author: Luciano P. Sabenca
# Author: Fernando H. S. Goncalves

echo '===== WELCOME TO [TESTER] :) ====='
echo
echo 'Digite o numero do lab:'
read nlab;
echo 'Digite a quantidade de testes abertos que há para baixar:'
read count;
echo 'Digite o nome do programa:'
read program;

if [ ! -d "Lab_$nlab" ] ;then
   mkdir "Lab_$nlab"
fi

gcc $program.c -o $program -Wall -ansi -pedantic -Werror # compila o programa e gera o executável

mv  $program "Lab_$nlab"
cd "Lab_$nlab"
echo 'Começando a baixar os teste e as saidas esperadas!'
sleep 3

for i in `seq -w 0 $count`;                #para i de 00 ateh count
do 
      wget -O - 'http://susy.ic.unicamp.br:9999/mc102wy/'$nlab'/dados/arq'$i.'in' > $program'_teste_'$i ; 
      wget -O - 'http://susy.ic.unicamp.br:9999/mc102wy/'$nlab'/dados/arq'$i.'res'  > $program'_saida_esperada_'$i ;

done;


echo 'Saidas e respostas baixadas!'
echo

echo 'Executando e comparando as saidas!'
echo 
sleep 3

for i in `seq -w 0 $count`;                #para i de 00 ateh count
do
  echo "==== Executando Teste $i ====" 
  ./$program < $program'_teste_'$i > $program'_saida_'$i
  sleep 1
  diff -s $program'_saida_'$i $program'_saida_esperada_'$i 
  echo
done;

echo '[TESTER] completed!'
echo 'Copyleft Luciano P. Sabenca & Fernando H. S. Goncalves'

