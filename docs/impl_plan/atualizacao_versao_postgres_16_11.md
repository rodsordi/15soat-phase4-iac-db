# Plano de Implementação: Atualização de Versão de Motor RDS PostgreSQL (16.11)

> **Decisão do Usuário**: Opção 1 - Atualizar para PostgreSQL 16.11 e Parametrizar na Raiz
> **Status**: Aprovado para Execução

---

## 1. Contexto & Diagnóstico

Durante a execução da esteira do repositório `15soat-phase4-iac-db` (Workflow Run ID `44139857579`), o provisionamento inicial dos recursos de rede, MongoDB no EKS e segredos no AWS Secrets Manager foi concluído com sucesso. No entanto, a criação das instâncias Amazon RDS PostgreSQL (`work-order-db-prd` e `billing-db-prd`) falhou com o erro:
`InvalidParameterCombination: Cannot find version 16.10 for postgres`.

A consulta à API da AWS RDS na região `us-east-2` identificou que a minor version `16.10` foi descontinuada pela AWS, sendo `16.11` a versão mínima suportada da família PostgreSQL 16 para instâncias `db.t4g.micro`.

---

## 2. Ações de Implementação

### 2.1 Parametrização da Versão de Motor do PostgreSQL
- Em `modules/rds-postgres/variables.tf`:
  - Atualizar o default de `engine_version` de `"16.10"` para `"16.11"`.
- No arquivo `variables.tf` (raiz):
  - Declarar a variável `postgres_engine_version` (tipo `string`, default `"16.11"`).
- No arquivo `main.tf` (raiz):
  - Passar `engine_version = var.postgres_engine_version` nas chamadas de `module.work_order_db` e `module.billing_db`.

### 2.2 Formatação e Validação
- Executar `terraform fmt -recursive`.
- Executar `terraform validate`.
- Executar `terraform plan` de validação local.
- Submeter as alterações ao Quality Gate do subagente `Code Reviewer Sentinel`.

### 2.3 Solicitação de Permissão para Commit & Push
- Apresentar o resultado e solicitar permissão explícita ao usuário para commit, push e abertura/merge do PR (conforme Diretriz Global #1).
