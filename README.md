# SW Orders App

Aplicativo Flutter desenvolvido como parte de um teste técnico para consumo de uma API de pedidos. A aplicação segue o padrão MVVM, utiliza Provider para injeção de dependência e gerenciamento de estado, além de consumir uma API autenticada com OAuth2.0.

---

##  Decisões Técnicas
- Autenticação via OAuth2: tokens são persistidos localmente com shared_preferences, com suporte a renovação de token (refresh_token) ao expirar.
- Login com e-mail: mesmo com a documentação sugerindo username como inteiro, optei por String para compatibilidade com e-mails ou outro username válido.
- Tela de Login: incluída para viabilizar autenticação e gerenciamento de sessão.
- AuthWrapper: criado um widget de controle (AuthWrapper) que redireciona o usuário automaticamente para a tela de login ou pedidos, com base no estado atual da autenticação.
- Logout: implementado botão de logout com limpeza de tokens e redirecionamento para a tela de login.
- Provider como injeção de dependência: optei por utilizar o próprio Provider para injeção de dependência, evitando outras bibliotecas externas como get_it ou injectable, mantendo o projeto mais enxuto e fácil de entender.
- Http nativo: escolhi usar a biblioteca http ao invés de Dio por simplicidade.
- Caixas de diálogo personalizadas: implementei diálogos de confirmação para ações importantes, como logout e finalização de pedidos, melhorando a experiência e segurança do usuário.
- Validações: campos obrigatórios no formulário com mensagens de erro.
- Feedback visual: uso de SnackBar para indicar sucesso após "finalizar pedido".
- Persistência de sessão: o app mantém o usuário logado entre execuções, desde que o token ainda esteja válido ou seja possível renová-lo.

---

## Funcionalidades

- Autenticação OAuth 2.0 (grant type `password`)
- Armazenamento e renovação de tokens
- Login e manutenção de sessão
- Listagem de pedidos (pendentes e finalizados)
- Criação de novos pedidos via formulário
- Finalização de pedidos com `PUT`
- Tratamento de erros e feedback visual
- Gerenciamento de estado com `Provider` e `ChangeNotifier`

---

## Estrutura do Projeto

```
lib/
├── core/ # Helpers, utilitários e constantes
│ ├── helpers/
│ └── utils/
├── models/ # Modelos de dados (ex: OrderModel, TokenModel)
├── services/ # Camada de acesso à API (ex: AuthService, UserService)
├── view_models/ # Camada de ViewModels (ex: AuthViewModel, OrdersViewModel)
├── views/ # Telas da aplicação (ex: Login, Orders, New Order)
└── main.dart # Entrada da aplicação
```

---

Como Testar

- Após iniciar o app, a primeira tela será a de login.
- Utilize um usuário e senha válidos conforme a documentação da API ou a Collection do Postman fornecida.
- Após o login, o app redireciona automaticamente para a tela de pedidos.

---

Como rodar o projeto

**Pré-requisitos:**

- Flutter SDK (versão recomendada: `3.22.0` ou superior)
- Link para instalação do flutter - https://docs.flutter.dev/get-started/install
- Dart SDK (vem junto com o Flutter)
- Emulador Android/iOS, dispositivo físico ou web.

```bash
git clone https://github.com/brunomelohwm/sw_orders_app.git
cd sw_orders_app
flutter pub get
flutter run
