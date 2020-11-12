# HTTP

> ## SUCESSO
1. Request com verbo http válido (Post) ||CHECK||
2. Passar nos headers o content type JSON ||CHECK||
3. Chamar request com body correto ||CHECK||
4. Ok - 200 e resposta com dados ||CHECK||
5. No content - 204 e resposta sem dados


>## Erros
1. Bad Request - 400
2. Unauthorized - 401
3. Forbidden - 403
4. Not found - 404
5. Internal server error - 500

>## Exceção - Status code diferente dos citados acima
1 Internal server error - 500

>## Exceção - Http request deu alguma exceção
1. Internal server error - 500

>## Exceção - Verbo http inválido
1. internal server error - 500