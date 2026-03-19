# Maitrabai

Aplicação mobile desenvolvida em Flutter para intermediação de serviços entre usuários.

## Visão geral

O projeto foi concebido para viabilizar a conexão entre usuários que ofertam e que contratam serviços, contemplando as seguintes funcionalidades:
- cadastro e login de usuários
- publicação de serviços
- aceite de serviços por outros usuários
- acompanhamento de serviços criados e aceitos
- desistir, concluir ou remover serviços
- gerenciamento de perfil e exclusão de conta

No contexto de desenvolvimento, a aplicação foi estruturada para representar um fluxo funcional completo de produto digital:
- entrada e validação básica de dados de usuário
- persistência e consulta de dados em banco NoSQL
- atualização de estado de serviços em tempo de uso
- navegação entre etapas de autenticação e área logada
- manipulação de cenários de ciclo de vida de um serviço (criar, aceitar, desistir, concluir e remover)

## Stack

| Camada | Tecnologia |
|---|---|
| Mobile | Flutter + Dart |
| Backend | Firebase (Cloud Firestore) |
| Persistência | Coleções NoSQL no Firestore |

Dependências principais: Flutter, Firebase Core e Cloud Firestore.

## Competências técnicas aplicadas

- Desenvolvimento mobile cross-platform com Flutter e Dart
- Organização por camadas iniciais com separação entre modelos e telas
- Integração com Firebase para inicialização e persistência de dados
- Modelagem de dados orientada a regras de negócio (usuários e serviços)
- Consumo de coleções e documentos no Firestore (leitura, escrita e atualização)
- Gerenciamento de estado de tela com base em interação do usuário
- Navegação e composição de interface com múltiplas telas e abas
- Implementação de fluxo de autenticação e cadastro dentro do app
- Tratamento de transições de estado no domínio de serviços
- Estruturação de projeto Flutter multi-plataforma (Android, iOS, Web, Desktop)

As competências acima evidenciam a aplicação prática de fundamentos de engenharia de software, modelagem de dados e desenvolvimento mobile orientado a requisitos funcionais.

## Arquitetura do projeto

Estrutura atual:
- lib/model: modelos de domínio (Usuário e Serviço)
- lib/view: telas, navegação e interações
- Firestore acessado diretamente nas telas

Essa organização reflete uma separação inicial de responsabilidades, favorecendo legibilidade e evolução incremental do código.

Arquivos centrais:
- [lib/main.dart](lib/main.dart)
- [lib/view/splash1.dart](lib/view/splash1.dart)
- [lib/view/login.dart](lib/view/login.dart)
- [lib/view/cadastro.dart](lib/view/cadastro.dart)
- [lib/view/principal.dart](lib/view/principal.dart)

## Fluxo funcional

1. Splash inicial
2. Inicialização do Firebase
3. Login ou cadastro
4. Carregamento do usuário
5. Navegação principal por abas:
  - Feed
  - Criar serviço
  - Perfil

O fluxo foi planejado para garantir continuidade de uso e transição consistente entre autenticação, consumo de dados e operações principais da aplicação.

## Estrutura de dados (Firestore)

### Coleção usuários

Campos utilizados:
- id
- nomeUsuario
- nomeReal
- senha
- cpf
- dataNasc
- qtdLike

### Coleção serviços

Campos utilizados:
- id
- nome
- valor
- descricao
- idCriaServ
- idPegaServ
- tipoServico
- disponivel

Regras de negócio atuais:
- idPegaServ igual a 0 significa serviço não aceito
- disponivel igual a true significa serviço aberto
- ao aceitar: idPegaServ recebe o id do usuário e disponivel vira false
- ao desistir: idPegaServ volta para 0 e disponivel vira true

Essas regras buscam garantir consistência no ciclo de vida dos serviços e reduzir ambiguidade na interpretação do estado de cada registro.

## Requisitos

- Flutter SDK instalado
- Dart SDK instalado
- Projeto Firebase configurado
- Arquivo android/app/google-services.json presente

Observação:
- [lib/firebase_options.dart](lib/firebase_options.dart) foi gerado pelo FlutterFire CLI.

## Como executar

1. Instalar dependências

~~~bash
flutter pub get
~~~

2. Executar o app

~~~bash
flutter run
~~~

3. Escolher dispositivo específico (opcional)

~~~bash
flutter devices
flutter run -d <device-id>
~~~

Os comandos acima permitem reproduzir localmente o ambiente de execução da aplicação para fins de avaliação técnica.

## Testes

Execução dos testes:

~~~bash
flutter test
~~~

Observação:
- [test/widget_test.dart](test/widget_test.dart) ainda é o teste padrão inicial do Flutter.

No estágio atual, a estratégia de testes encontra-se em fase inicial, com oportunidade de ampliação para cenários de widget e integração.

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

## Considerações finais

O projeto demonstra a implementação de um produto mobile funcional com integração em nuvem, contemplando aspectos de modelagem, navegação e persistência. Em termos acadêmicos, representa uma base consistente para evoluções arquiteturais e ampliação de critérios de qualidade, como segurança, testes automatizados e modularização das regras de negócio.

## Autor

Samuel Rodrigues Viana de Faria.
