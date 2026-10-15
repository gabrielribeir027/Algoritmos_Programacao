Algoritmo "MED_CONTROL_desafio"
//
//
// Descrição   : Aqui você descreve o que o programa faz! (função)
// Autor(a)    : Gabriel Santos Ribeiro
// Data atual  : 29/09/2026
Const
   MAX_PACIENTES = 30

   // Registro de informações do paciente! (1)
Tipo
   cadastro = registro
      codigo: inteiro
      nome: caractere
      idade: inteiro
      sexo: caractere
      prioridade: inteiro
      pressao_sistolica: real
      pressao_diastolica: real
      temperatura: real
      status: caractere
   fimregistro

   // VARIÁVEIS GLOBAIS
Var
   online: logico // TRAVA DO CORPO DO ALGORITMO (9)
   opcao,contador_pacientes,listagem_pacientes,posicao,codigo_consulta,waiting: inteiro
   pacientes: vetor[1..MAX_PACIENTES] de cadastro
   
   // ACUMULADORES/ESTATÍSTICAS
   idade_media,temperatura_media: real
   // IDADE/ESTÍSTICAS
   maior_idade, menor_idade:inteiro
   // PERCENTUAIS! ACUMULADORES
   percentual_aguardando, percentual_atendidos: real
   
   estatisticas: vetor[1..4,1..3] de inteiro
   
// Cadastro de pacientes, procedimento! (1)=====================================

procedimento cadastro_pacientes
Var
codigo_existe: logico  //Controlador de um código existente ou não!
i,codigo_digitado: inteiro
Inicio
   limpatela
   escreval("==== REGISTRO PACIENTE ====")
escreva("Codigo: ")
   leia(codigo_digitado)

   codigo_existe <- verdadeiro
   // Comparador de códigos, sem duplicação!
   enquanto codigo_existe faca
      codigo_existe <- falso
      // Estrutura vai pegar o código novo e comparar com os
      // valores armazenados!
      para i de 1 ate contador_pacientes faca
         se pacientes[i].codigo = codigo_digitado entao
            codigo_existe <- verdadeiro
         fimse
      fimpara

      se codigo_existe entao
         escreva("CÓDIGO JÁ CADASTRADO! DIGITE NOVAMENTE: ")
         leia(codigo_digitado)
         fimse
   fimenquanto
   // Vai somar + 1 ao registro inteiro!
   contador_pacientes <- contador_pacientes + 1
   pacientes[contador_pacientes].codigo <- codigo_digitado
   
   escreva("Nome: ")
   leia(pacientes[contador_pacientes].nome)
   escreva("Idade: ")
   leia(pacientes[contador_pacientes].idade)
   // Verificação de idade!
   enquanto (pacientes[contador_pacientes].idade <= 0) ou (pacientes[contador_pacientes].idade > 130) faça
      escreva("IDADE INVÁLIDA! DIGITE NOVAMENTE: ")
      leia(pacientes[contador_pacientes].idade)
   fimenquanto
   
   escreva("Sexo (M/F): ")
   leia(pacientes[contador_pacientes].sexo)
   pacientes[contador_pacientes].sexo <- Maiusc(pacientes[contador_pacientes].sexo)
   // (M) masculino ou (F) feminino!
   se (pacientes[contador_pacientes].sexo = "M") então
      pacientes[contador_pacientes].sexo <- ("Masculino")
      senão
           se (pacientes[contador_pacientes].sexo = "F") então
      pacientes[contador_pacientes].sexo <- ("Feminino")
      fimse
   fimse
   
   escreva("Prioridade: ")
   leia(pacientes[contador_pacientes].prioridade)
   // Verificaçao de prioridade!
   enquanto (pacientes[contador_pacientes].prioridade < 1) ou (pacientes[contador_pacientes].prioridade > 4) faça
            escreva("PRIORIDADE INVÁLIDA! DIGITE NOVAMENTE: ")
            leia(pacientes[contador_pacientes].prioridade)
   fimenquanto
   
   escreva("Pressão arterial sistólica: ")
   leia(pacientes[contador_pacientes].pressao_sistolica)
   
   escreva("Pressão arterial diastólica: ")
   leia(pacientes[contador_pacientes].pressao_diastolica)
   // Vericação diastólica (sempre menor que a sistólica)!
   enquanto (pacientes[contador_pacientes].pressao_diastolica > pacientes[contador_pacientes].pressao_sistolica) faça
            escreva("PRE. DIASTÓLICA INVÁLIDA! DIGITE NOVAMENTE: ")
            leia(pacientes[contador_pacientes].pressao_diastolica)
   fimenquanto
   
   escreva("Temperatura: ")
   leia(pacientes[contador_pacientes].temperatura)
   
   // Verificação de temperatura (números válidos!)
   enquanto (pacientes[contador_pacientes].temperatura < 19) ou (pacientes[contador_pacientes].temperatura > 43) faça
            escreva("TEMPERATURA INVÁLIDA! DIGITE NOVAMENTE: ")
            leia(pacientes[contador_pacientes].temperatura)
   fimenquanto
   pacientes[contador_pacientes].status <- ("Aguardando atendimento")
   escreval("STATUS:",pacientes[contador_pacientes].status)
   escreval("===========================")
fimprocedimento

// Listagem de pacientes! (2)===================================================

procedimento lista_pacientes
Inicio
   listagem_pacientes <- 1
   limpatela
   escreval("==== LISTA DE PACIENTES ====")
   se contador_pacientes = 0 então
      escreval("AINDA SEM PACIENTES CADASTRADOS!")
   senão
   enquanto listagem_pacientes <= contador_pacientes faça
      escreval("CÓDIGO: ",pacientes[listagem_pacientes].codigo)
      escreval("NOME: ", pacientes[listagem_pacientes].nome)
      escreval("IDADE:",pacientes[listagem_pacientes].idade," anos")
      escreval("SEXO: ",pacientes[listagem_pacientes].sexo)
      se pacientes[listagem_pacientes].prioridade = 1 entao
         escreval("Prioridade: EMERGÊNCIA")
      fimse
      se pacientes[listagem_pacientes].prioridade = 2 entao
         escreval("Prioridade: MUITO URGENTE")
      fimse
      se pacientes[listagem_pacientes].prioridade = 3 entao
         escreval("Prioridade: URGENTE")
      fimse
      se pacientes[listagem_pacientes].prioridade = 4 entao
         escreval("Prioridade: POUCO URGENTE")
      fimse
      listagem_pacientes <- listagem_pacientes + 1 // Contador ENQUANTO!
      escreval("===========================")
   fimenquanto
   fimse
fimprocedimento

// Consulta de paciente! (3)====================================================

funcao consulta_pacientes(codigo_consulta:inteiro): inteiro
Var
i,resultado: inteiro
Inicio
resultado <- -1 // Até agora sem ninguém (Por isso -1)

       para i de 1 até contador_pacientes faça
            se pacientes[i].codigo = codigo_consulta então
               resultado <- i
            fimse
       fimpara
       retorne resultado
fimfuncao

// Fila de atendimento! (4)=====================================================

// Bubble sort pra organizar a fila!
procedimento fila_atendimento
Var
aux: cadastro
i,j,x: inteiro
Inicio
limpatela
escreval("==== FILA DE ATENDIMENTO ====")
// BUBBL SORT PRA ORGANIZAR ESSA FILA!
para i de 1 até contador_pacientes faça
     para j de 1 até contador_pacientes - 1 faça
          se (pacientes[j].prioridade > pacientes[j+1].prioridade) ou (pacientes[j].prioridade = pacientes[j+1].prioridade) e (pacientes[j].idade < pacientes[j+1].idade)então
             aux <- pacientes[j]
             pacientes[j] <-  pacientes[j+1]
             pacientes[j+1] <- aux
          fimse
     fimpara
fimpara
para i de 1 até contador_pacientes faça
     se pacientes[i].status = "Aguardando atendimento" então
        escreval(pacientes[i].prioridade ," - ", pacientes[i].nome, pacientes[i].idade," anos")
        x <- x + 1
     fimse
fimpara
       se x = 0 então
            escreval("SEM PACIENTES NA FILA!")
       fimse
fimprocedimento

// Realização de atendimento! (5)===============================================

procedimento atendimento
Var
posicao_proximo,i:inteiro // Para saber se tem alguem na fila!
Inicio
limpatela
escreval("==== REALIZAÇÃO DE ATENDIMENTO ====")
posicao_proximo <- -1 // Vou declarar que ainda não existe!
para i de 1 até contador_pacientes faça
     se pacientes[i].status = "Aguardando atendimento" então
        se posicao_proximo = -1 então
           posicao_proximo <- i
           senão
                se (pacientes[i].prioridade < pacientes[posicao_proximo].prioridade) ou ((pacientes[i].prioridade = pacientes[posicao_proximo].prioridade) e (pacientes[i].idade > pacientes[posicao_proximo].idade)) então
                   posicao_proximo <- i
                fimse
        fimse
     fimse
fimpara
se posicao_proximo = -1 então
   escreval("NÃO HÁ PACIENTES AGUARDANDO")
senão
     escreval("PROXIMO PACIENTE: ")
     escreval("CÓDIGO: ",pacientes[posicao_proximo].codigo)
     escreval("NOME: ", pacientes[posicao_proximo].nome)
     escreval("IDADE:",pacientes[posicao_proximo].idade," anos")
     escreval("PRIORIDADE: ",pacientes[posicao_proximo].prioridade)
     pacientes[posicao_proximo].status <- "Atendido"
fimse
fimprocedimento

// Exibir atendidos! (6)========================================================
procedimento atendidos
Var
i,aguard:inteiro
Inicio
limpatela
aguard <- 0
escreval("==== ATENDIDOS ====")
// Caso se ainda não tiverem cadastrados!
se contador_pacientes = 0 então
   escreval("SEM PACIENTES CADASTRADO!")
senão
// Caso se não tiverem atendidos ainda!
     para i de 1 até contador_pacientes faça
          se (pacientes[i].status = "Aguardando atendimento") então
             aguard <- aguard + 1
          fimse
       fimpara
     fimse
se aguard = contador_pacientes então
   escreval("SEM PACIENTES ATENDIDOS AINDA!")
senão

// Mostrar os atendidos!
para i de 1 até contador_pacientes faça
     se pacientes[i].status = "Atendido" então
        escreval("CÓDIGO: ",pacientes[i].codigo)
        escreval("NOME: ", pacientes[i].nome)
        escreval("IDADE:",pacientes[i].idade," anos")
        escreval("===========================")
     fimse
fimpara
fimse
fimprocedimento

// Estatisticas! (7)============================================================
procedimento exibir_estatisticas
Var
   i, linha, coluna, m: inteiro
Inicio
   limpatela

   // Zera a matriz antes de contar novamente
   para linha de 1 ate 4 faca
      para coluna de 1 ate 3 faca
         estatisticas[linha,coluna] <- 0
      fimpara
   fimpara

   // Percorre todos os pacientes cadastrados
   para i de 1 ate contador_pacientes faca

      linha <- pacientes[i].prioridade

      // Conta cadastrados
      estatisticas[linha,1] <- estatisticas[linha,1] + 1

      // Conta os pacientes conforme o status
      se pacientes[i].status = "Aguardando atendimento" entao
         estatisticas[linha,2] <- estatisticas[linha,2] + 1
      senao
         se pacientes[i].status = "Atendido" entao
            estatisticas[linha,3] <- estatisticas[linha,3] + 1
         fimse
      fimse

   fimpara

  // Exibe a tabela de estatisticas
   escreval("================== ESTATISTICAS ===================")
   escreval("   Prioridade | Cadastrados | Aguardando | Atendidos")

   para linha de 1 ate 4 faca

      // Escreve o nome da prioridade
      se linha = 1 entao
         escreva("EMERGÊNCIA    |")
      senao
         se linha = 2 entao
            escreva("MUITO URGENTE |")
         senao
            se linha = 3 entao
               escreva("URGENTE       |")
            senao
               escreva("POUCO URGENTE |")
            fimse
         fimse
      fimse

      // Exibe os valores de cada coluna
      escreva("     ", estatisticas[linha,1], "      |")
      escreva("     ", estatisticas[linha,2], "     |")
      escreval("     ", estatisticas[linha,3])
   fimpara
   escreval("===================================================")
   // Total de pacientes/idade média
   se contador_pacientes >= 1 então
      // TEMPERATURA MÉDIA!
      temperatura_media <- 0
      para m de 1 até contador_pacientes faça
        temperatura_media <- temperatura_media + pacientes[m].temperatura
      fimpara
          temperatura_media <- temperatura_media/contador_pacientes
      // MAIOR IDADE!
      para m de 1 até contador_pacientes faça
           se pacientes[m].idade = pacientes[1].idade então
              maior_idade <- pacientes[m].idade
           fimse
           se pacientes[m].idade > maior_idade então
              maior_idade <- pacientes[m].idade
           fimse
      fimpara
      // MENOR IDADE!
      para m de 1 até contador_pacientes faça
           se pacientes[m].idade = pacientes[1].idade então
              menor_idade <- pacientes[m].idade
           fimse
           se pacientes[m].idade < menor_idade então
              menor_idade <- pacientes[m].idade
           fimse
      fimpara
      // PERCENTUAIS!
      percentual_atendidos <- 0
      percentual_aguardando <- 0
      para m de 1 até contador_pacientes faça
           se pacientes[m].status = "Atendido" então
              percentual_atendidos <- percentual_atendidos + 1
           senão
                se pacientes[m].status = "Aguardando atendimento" então
                   percentual_aguardando <- percentual_aguardando + 1
                fimse
           fimse
           fimpara
      percentual_atendidos <- (percentual_atendidos/contador_pacientes)*100
      percentual_aguardando <- (percentual_aguardando/contador_pacientes)*100


      escreval("=> TOTAL DE PACIENTES:",contador_pacientes,"!")
      escreval("=> A TEMPERATURA MÉDIA: ",temperatura_media:5:2,"°")
      escreval("=> A MAIOR IDADE: ",maior_idade," ANOS")
      escreval("=> A MENOR IDADE: ",menor_idade," ANOS")
      escreval("=> O PERCENTUAL DE ATENDIDOS: ",percentual_atendidos:5:2,"%")
      escreval("=> O PERCENTUAL DE AGUARDANDOS: ",percentual_aguardando:5:2,"%")
      escreval("=> PACIENTES AGUARDANADO ATENDIMENTO: ", quantidade_aguardando())
      escreval("=> MÉDIA IDADE: ", calcular_media_idades())
   senão
        escreval("=> AINDA SEM PACIENTES CADASTRADOS!")c
   fimse
fimprocedimento

// FUNÇÃO CÁLCULO DE AGUARDANDOS!===============================================
funcao quantidade_aguardando(): inteiro
var
   i, quantidade: inteiro
inicio
   quantidade <- 0

   para i de 1 ate contador_pacientes faca
      se pacientes[i].status = "Aguardando atendimento" entao
         quantidade <- quantidade + 1
      fimse
   fimpara

   retorne quantidade
fimfuncao

// CÁLCULO DE MÉDIA DE IDADES!==================================================
funcao calcular_media_idades(): real
var
   i: inteiro
   soma: real
inicio
   soma <- 0

   se contador_pacientes = 0 entao
      retorne 0
   fimse

   para i de 1 ate contador_pacientes faca
      soma <- soma + pacientes[i].idade
   fimpara

   retorne soma / contador_pacientes
fimfuncao

// Recursividade (8)============================================================

// Busca recursiva: retorna a posição do paciente ou 0 se não encontrar
funcao busca_recursiva(codigo_busca, posicao_atual, quantidade: inteiro): inteiro
Var
   resultado: inteiro
Inicio
   // Caso-base: chegou ao final sem encontrar
   se posicao_atual > quantidade entao
      resultado <- 0
   senao
      // Verifica o código na posição atual
      se pacientes[posicao_atual].codigo = codigo_busca entao
         resultado <- posicao_atual
      senao
         // Chama a função para a próxima posição
         resultado <- busca_recursiva(codigo_busca, posicao_atual + 1, quantidade)
      fimse
   fimse

   retorne resultado
Fimfuncao


// Conta recursivamente os pacientes aguardando atendimento
funcao aguardando_recursivo(posicao_atual, quantidade: inteiro): inteiro
Var
   resultado: inteiro
Inicio
   // Caso-base: passou pelo último paciente
   se posicao_atual > quantidade entao
      resultado <- 0
   senao
      // Verifica se o paciente está aguardando
      se pacientes[posicao_atual].status = "Aguardando atendimento" entao
         resultado <- 1 + aguardando_recursivo(posicao_atual + 1, quantidade)
      senao
         resultado <- aguardando_recursivo(posicao_atual + 1, quantidade)
      fimse
   fimse

   retorne resultado
Fimfuncao


// Consulta recursiva
procedimento consulta_recursiva
Var
   codigo_procurado, posicao: inteiro
Inicio
   limpatela
   escreval("==== CONSULTA RECURSIVA ====")

   se contador_pacientes = 0 entao
      escreval("Nenhum paciente cadastrado!")
   senao
      escreva("Digite o código do paciente: ")
      leia(codigo_procurado)

      // Busca começa na posição 1
      posicao <- busca_recursiva(codigo_procurado, 1, contador_pacientes)

      se posicao = 0 entao
         escreval("Erro: código inválido/inexistente")
      senao
         escreval("Paciente encontrado na posição: ", posicao)
         escreval("Nome: ", pacientes[posicao].nome)
         escreval("Idade: ", pacientes[posicao].idade, " anos")
         escreval("Status: ", pacientes[posicao].status)
      fimse

      escreval("==============================")
      escreval("Pacientes aguardando (recursivo): ",aguardando_recursivo(1, contador_pacientes))
   fimse
fimprocedimento


// Menu Principal! CORPO DO ALGORITMO! =========================================
Inicio
   online <- falso
   opcao <- 1
   contador_pacientes <- 0
   enquanto não online faça
      limpatela
      // Aviso ao usuário se o valor da opção for inválido!
      se (opcao > 9) ou (opcao < 1) então
         escreval("*VALOR INVÁLIDO")
      fimse

      escreval("Sejam bem-vindos ao MedControl!")
      escreval("MEDCONTROL - GERENCIAMENTO DE ATENDIMENTOS")
      escreval("1. Cadastrar paciente")
      escreval("2. Listar pacientes")
      escreval("3. Consultar dados pacientes")
      escreval("4. Exibir fila de atendimento")
      escreval("5. Realizar atendimento")
      escreval("6. Exibir pacientes atendidos")
      escreval("7. Exibir estatísticas")
      escreval("8. Executar consulta recursiva")
      escreval("9. Encerrar sistema")
      escreva("=> Digite a opção desejada: ")
      leia(opcao)
      se opcao = 9 então
         limpatela
         online <- verdadeiro
         escreval("CONSULTA FINALIZADA...")
      fimse
      se opcao = 1 então
         // Vai avisar se o valor chegar a 30!
         se contador_pacientes >= MAX_PACIENTES então
            escreval("LIMITE DE PACIENTES ATINGIDO!")
            leia(waiting)
         senão
            cadastro_pacientes
            escreval("PACIENTE CADASTRADO!")
            leia(waiting)
         fimse
      fimse
      se opcao = 2 então
         lista_pacientes
         leia(waiting)
      fimse
      se opcao = 3 então
         limpatela
         escreval("==== CONSULTA DE DADOS ====")
         se contador_pacientes = 0 então
            escreval("AINDA SEM PACIENTES CADASTRADOS!")
         senão
         escreva("Informe o código do paciente: ")
         leia(codigo_consulta)
         posicao <- consulta_pacientes(codigo_consulta)
                 se posicao = - 1 então
                    escreval("PACIENTE NÃO CADASTRADO!")
                    escreval("===========================")
                 senao
                    escreval("CÓDIGO: ", pacientes[posicao].codigo)
                    escreval("NOME: ", pacientes[posicao].nome)
                    escreval("IDADE:",pacientes[posicao].idade," anos")
                    se pacientes[posicao].prioridade = 1 entao
                        escreval("Prioridade: EMERGÊNCIA")
                     fimse
                     se pacientes[posicao].prioridade = 2 entao
                        escreval("Prioridade: MUITO URGENTE")
                     fimse
                     se pacientes[posicao].prioridade = 3 entao
                        escreval("Prioridade: URGENTE")
                     fimse
                     se pacientes[posicao].prioridade = 4 entao
                        escreval("Prioridade: POUCO URGENTE")
                     fimse
                    escreval("STATUS: ",pacientes[posicao].status)
                    escreval("===============================")
                 fimse
         fimse
            leia(waiting)
      fimse
      se opcao = 4 então
         fila_atendimento
         leia(waiting)
      fimse
      se opcao = 5 então
         atendimento
         leia(waiting)
      fimse
      se opcao = 6 então
         atendidos
         leia(waiting)
      fimse
      se opcao = 7 então
         exibir_estatisticas
         leia(waiting)
      fimse
      se opcao = 8 então
         consulta_recursiva
         leia(waiting)
      fimse
fimenquanto
Fimalgoritmo