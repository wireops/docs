# Convenções e testes

Prefira alterações pequenas, cobertas por testes e consistentes com os pacotes vizinhos. Use capacidades RBAC nas rotas, aplique validação de política na mesma extração usada pelo lint e nunca registre valores secretos.

Execute testes Go relevantes e os testes da interface antes de abrir uma mudança. Mudanças de schema exigem migração PocketBase; mudanças no protocolo exigem compatibilidade explícita entre servidor e worker.

