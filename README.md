# Maitrabai

Aplicacao mobile desenvolvida em Flutter para intermediacao de servicos entre usuarios.

## Visao geral

O projeto foi concebido para viabilizar a conexao entre usuarios que ofertam e que contratam servicos, contemplando as seguintes funcionalidades:
- cadastro e login de usuarios
- publicacao de servicos
- aceite de servicos por outros usuarios
- acompanhamento de servicos criados e aceitos
- desistir, concluir ou remover servicos
- gerenciamento de perfil e exclusao de conta

No contexto de desenvolvimento, a aplicacao foi estruturada para representar um fluxo funcional completo de produto digital:
- entrada e validacao basica de dados de usuario
- persistencia e consulta de dados em banco NoSQL
- atualizacao de estado de servicos em tempo de uso
- navegacao entre etapas de autenticacao e area logada
- manipulacao de cenarios de ciclo de vida de um servico (criar, aceitar, desistir, concluir e remover)

## Stack

| Camada | Tecnologia |
|---|---|
| Mobile | Flutter + Dart |
| Backend | Firebase (Cloud Firestore) |
| Persistencia | Colecoes NoSQL no Firestore |

Dependencias principais: Flutter, Firebase Core e Cloud Firestore.

## Competencias tecnicas aplicadas

- Desenvolvimento mobile cross-platform com Flutter e Dart
- Organizacao por camadas iniciais com separacao entre modelos e telas
- Integracao com Firebase para inicializacao e persistencia de dados
- Modelagem de dados orientada a regras de negocio (usuarios e servicos)
- Consumo de colecoes e documentos no Firestore (leitura, escrita e atualizacao)
- Gerenciamento de estado de tela com base em interacao do usuario
- Navegacao e composicao de interface com multiplas telas e abas
- Implementacao de fluxo de autenticacao e cadastro dentro do app
- Tratamento de transicoes de estado no dominio de servicos
- Estruturacao de projeto Flutter multi-plataforma (Android, iOS, Web, Desktop)

As competencias acima evidenciam a aplicacao pratica de fundamentos de engenharia de software, modelagem de dados e desenvolvimento mobile orientado a requisitos funcionais.

## Arquitetura do projeto

Estrutura atual:
- lib/model: modelos de dominio (Usuario e Servico)
- lib/view: telas, navegacao e interacoes
- Firestore acessado diretamente nas telas

Essa organizacao reflete uma separacao inicial de responsabilidades, favorecendo legibilidade e evolucao incremental do codigo.

Arquivos centrais:
- [lib/main.dart](lib/main.dart)
- [lib/view/splash1.dart](lib/view/splash1.dart)
- [lib/view/login.dart](lib/view/login.dart)
- [lib/view/cadastro.dart](lib/view/cadastro.dart)
- [lib/view/principal.dart](lib/view/principal.dart)

## Fluxo funcional

1. Splash inicial
2. Inicializacao do Firebase
3. Login ou cadastro
4. Carregamento do usuario
5. Navegacao principal por abas:
   - Feed
   - Criar servico
   - Perfil

O fluxo foi planejado para garantir continuidade de uso e transicao consistente entre autenticacao, consumo de dados e operacoes principais da aplicacao.

## Estrutura de dados (Firestore)

### Colecao usuarios

Campos utilizados:
- id
- nomeUsuario
- nomeReal
- senha
- cpf
- dataNasc
- qtdLike

### Colecao servicos

Campos utilizados:
- id
- nome
- valor
- descricao
- idCriaServ
- idPegaServ
- tipoServico
- disponivel

Regras de negocio atuais:
- idPegaServ igual a 0 significa servico nao aceito
- disponivel igual a true significa servico aberto
- ao aceitar: idPegaServ recebe o id do usuario e disponivel vira false
- ao desistir: idPegaServ volta para 0 e disponivel vira true

Essas regras buscam garantir consistencia no ciclo de vida dos servicos e reduzir ambiguidade na interpretacao do estado de cada registro.

## Requisitos

- Flutter SDK instalado
- Dart SDK instalado
- Projeto Firebase configurado
- Arquivo android/app/google-services.json presente

Observacao:
- [lib/firebase_options.dart](lib/firebase_options.dart) foi gerado pelo FlutterFire CLI.

## Como executar

1. Instalar dependencias

~~~bash
flutter pub get
~~~

2. Executar o app

~~~bash
flutter run
~~~

3. Escolher dispositivo especifico (opcional)

~~~bash
flutter devices
flutter run -d <device-id>
~~~

Os comandos acima permitem reproduzir localmente o ambiente de execucao da aplicacao para fins de avaliacao tecnica.

## Testes

Execucao dos testes:

~~~bash
flutter test
~~~

Observacao:
- [test/widget_test.dart](test/widget_test.dart) ainda e o teste padrao inicial do Flutter.

No estagio atual, a estrategia de testes encontra-se em fase inicial, com oportunidade de ampliacao para cenarios de widget e integracao.

## Estrutura de pastas (resumo)

~~~text
lib/
  main.dart
  firebase_options.dart
  model/
    user.dart
    service.dart
  view/
    splash1.dart
    splash2.dart
    login.dart
    cadastro.dart
    principal.dart
    screens/
      feed.dart
      criaServ.dart
      perfil.dart
      listaServicos.dart
~~~

  ## Consideracoes finais

  O projeto demonstra a implementacao de um produto mobile funcional com integracao em nuvem, contemplando aspectos de modelagem, navegacao e persistencia. Em termos academicos, representa uma base consistente para evolucoes arquiteturais e ampliacao de criterios de qualidade, como seguranca, testes automatizados e modularizacao das regras de negocio.

## Autor

Samuel Rodrigues
