# Plano de Implementação: Migração da Infraestrutura de Bancos de Dados para us-east-2 (iac-db)

> **Decisão do Usuário**: Opção 1 - Migração para us-east-2 & Persistência Poliglota com 2x RDS Postgres + MongoDB no EKS
> **Status**: Aprovado para Execução

---

## 1. Contexto & Diagnóstico

O repositório `15soat-phase4-iac-db` gerencia a camada de persistência poliglota dos microsserviços da oficina mecânica (Tech Challenge Fase 4). Com a migração da conta AWS e do cluster EKS para a região `us-east-2`, a infraestrutura de banco de dados deve ser alinhada à mesma região e ao backend remoto unificado no S3 (`fiap-phase4-terraform-state/iac-db/terraform.tfstate`).

A topologia arquitetural de persistência poliglota adotada compreende:
- **`work-order-db`**: Instância gerenciada Amazon RDS PostgreSQL (`db.t4g.micro`, 20 GiB gp3, elegível para Free Tier) alocada nas subnets privadas da VPC do cluster EKS.
- **`billing-db`**: Instância gerenciada Amazon RDS PostgreSQL (`db.t4g.micro`, 20 GiB gp3, elegível para Free Tier) alocada nas subnets privadas da VPC do cluster EKS.
- **`exec-mongodb`**: Cluster MongoDB implantado como StatefulSet no Kubernetes (namespace `infra-database`).
- **AWS Secrets Manager**: Credenciais de acesso e strings JDBC versionadas dinamicamente e criptografadas para consumo das aplicações.

A validação prévia confirmou que as subnets privadas da VPC `fiap-workshop-eks-vpc` possuem a tag `kubernetes.io/role/internal-elb = 1` nas zonas `us-east-2a` e `us-east-2b`, garantindo auto-descoberta transparente para o `DBSubnetGroup`.

---

## 2. Ações de Implementação

### 2.1 Ajuste de Região no Terraform e CI/CD
- Em `providers.tf`:
  - Atualizar o `backend "s3"`: `region = "us-east-2"`.
- Em `variables.tf`:
  - Atualizar o default da variável `aws_region` para `"us-east-2"`.
- Em `.github/workflows/terraform.yml`:
  - Ajustar o fallback da variável de ambiente `AWS_REGION` de `'us-east-1'` para `'us-east-2'`.
- Em `terraform.tfvars.example`:
  - Atualizar `aws_region = "us-east-2"`.

### 2.2 Formatação e Validação
- Executar `terraform fmt -recursive`.
- Executar `terraform init` e `terraform validate`.
- Submeter o código à auditoria do subagente `Code Reviewer Sentinel`.

### 2.3 Solicitação de Permissão para Commit & Push
- Apresentar o resultado e solicitar permissão explícita ao usuário para commit, push e abertura/merge do PR (conforme Diretriz Global #1).
