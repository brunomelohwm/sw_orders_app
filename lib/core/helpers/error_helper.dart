class ErrorHelper {
  static String getErrorMessage(dynamic error) {
    final message = error.toString().toLowerCase();

    if (message.contains('401')) {
      return 'Sessão expirada. Faça login novamente.';
    } else if (message.contains('400')) {
      return 'Dados inválidos. Verifique e tente novamente.';
    } else if (message.contains('404')) {
      return 'Recurso não encontrado.';
    } else if (message.contains('500')) {
      return 'Erro interno no servidor. Tente novamente mais tarde.';
    } else if (message.contains('503')) {
      return 'Serviço temporariamente indisponível.';
    } else if (message.contains('socketexception')) {
      return 'Sem conexão com a internet.';
    } else {
      return 'Ocorreu um erro inesperado. Mensagem: $message';
    }
  }
}
