Feature: Login
Como um cliente
Quero poder acessar minha conta e me manter logado
para que eu possa ver e respondeer enquetes de forma rapida


Cenário: Credenciais Validas
Dado que o clente informou credenciais Validas
Quando solicitar para fazer Login
Então o sistema deve enviar o usuario para a tela de pesquisas
E manter o usuario conectado

Cenário: Credenciais invalidas
Dado que o cliente informou credenciais invalidas
Quando solicitar para fazer Login
Entao o sistema deve retornar mensagem de erro

