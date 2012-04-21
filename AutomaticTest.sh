#!/bin/bash


# Script para efetuar teste automaticos, comparando as respostas do Susy com as do seu programa
# Author: Luciano Padua Sabenca CC 012
echo
echo '===== Script para efetuar testes automaticamente, baixando-os do Susy ====='
echo 'Digite a Materia e a(s) turma(s)(exemplo: mc102wy):'
read link;
echo 'Digite o numero do lab:'
read nlab;
echo 'Ha zero antes do numero do arquivo de teste(por exemplo: arq01) sim/nao ?'
read hazero
echo 'Digite a quantidade de testes abertos que há para baixar:'
read qtd;
echo 'Digite o nome do programa compilado:'
read nomePrograma;
echo 'Começando a baixar os teste e as saidas esperadas!'

if [ ! -d "Lab_$nlab" ] ;then
   mkdir "Lab_$nlab"
   cp $nomePrograma $nlab/
   cd "Lab_$nlab"
fi

sleep 5

for ((a=00; a <= $qtd ; a++)); 
do 
   if [ "$hazero" == "sim" ] ;  then
      wget  -O - 'http://susy.ic.unicamp.br:9999/'$link'/'$nlab'/dados/arq0'$a.'in' > $nomePrograma'_teste_'$a; 
      wget  -O -   'http://susy.ic.unicamp.br:9999/'$link'/'$nlab'/dados/arq0'$a.'res'  > $nomePrograma'_saida_prevista_'$a
   else
      wget -O - 'http://susy.ic.unicamp.br:9999/'$link'/'$nlab'/dados/arq'$a.'in' > $nomePrograma'_teste_'$a; 
      wget -O - 'http://susy.ic.unicamp.br:9999/'$link'/'$nlab'/dados/arq'$a.'res'  > $nomePrograma'_saida_prevista_'$a;
   fi
done;


echo 'Saidas e respostas baixadas!'

echo 'Executando e comparando as saidas!'
echo 
sleep 5

for ((a=0; a <= $qtd ; a++)); 
do
  echo "==== Executando Teste $a ====" 
  sleep 1
  ./$nomePrograma < $nomePrograma'_teste_'$a > $nomePrograma'_saida_'$a
  diff -s $nomePrograma'_saida_'$a $nomePrograma'_saida_prevista_'$a
done;
echo 'Script executado!'



