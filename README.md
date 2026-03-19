# Maitrabai

Aplicativo mobile em Flutter para intermediacao de servicos entre usuarios.

## Visao geral

O projeto permite:
- cadastro e login de usuarios
- publicacao de servicos
- aceite de servicos por outros usuarios
- acompanhamento de servicos criados e aceitos
- desistir, concluir ou remover servicos
- gerenciamento de perfil e exclusao de conta

## Stack

| Camada | Tecnologia |
|---|---|
| Mobile | Flutter + Dart |
| Backend | Firebase (Cloud Firestore) |
| Persistencia | Colecoes NoSQL no Firestore |

Dependencias principais: Flutter, Firebase Core e Cloud Firestore.

## Arquitetura do projeto

Estrutura atual:
- lib/model: modelos de dominio (Usuario e Servico)
- lib/view: telas, navegacao e interacoes
- Firestore acessado diretamente nas telas

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

## Testes

Executar testes:

~~~bash
flutter test
~~~

Observacao:
- [test/widget_test.dart](test/widget_test.dart) ainda e o teste padrao inicial do Flutter.

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

## Roadmap sugerido

- separar regra de negocio em camada de servicos/repositorios
- migrar login para Firebase Authentication
- nao armazenar senha em texto puro
- melhorar validacoes de formulario
- adicionar testes de widget e integracao
- padronizar estrategia de ids no Firestore

## Autor

Samuel Rodrigues

