# Infraestrutura de Banco de Dados como Código (`15soat-phase4-iac-db`)

Módulos Terraform para provisionamento de infraestrutura dedicada de bancos de dados relacionais (SQL) e não-relacionais (NoSQL) para os microsserviços da oficina mecânica, atendendo estritamente ao isolamento do padrão **Database-per-Service**:
- **`work_order_db`**: AWS RDS PostgreSQL 16 (Relacional / ACID)
- **`billing_db`**: AWS RDS PostgreSQL 16 (Relacional / ACID)
- **`exec_db`**: AWS DocumentDB / MongoDB (NoSQL / Orientado a Documentos)

## Arquitetura Global Database-per-Service & Fronteiras de Domínio

<div style="overflow-x: auto; width: 100%;">
<div style="min-width: 900px;">

```mermaid
erDiagram
    %% Microservice: api-work-order (PostgreSQL - work_order_db)
    CUSTOMER {
        uuid id PK "Chave Primária"
        string document UK "CPF ou CNPJ (VO)"
        string name "Nome do Cliente"
        string email UK "E-mail"
    }

    VEHICLE {
        uuid id PK "Chave Primária"
        uuid customer_id FK "FK referenciando CUSTOMER(id)"
        string license_plate UK "Placa do Veículo (VO)"
        string make "Marca / Fabricante"
        string model "Modelo"
        integer manufacture_year "Ano Fabricação"
    }

    CUSTOMER ||--o{ VEHICLE : "possui"

    WORK_ORDER {
        uuid id PK "Chave Primária"
        uuid customer_id FK "FK referenciando CUSTOMER(id)"
        uuid vehicle_id FK "FK referenciando VEHICLE(id)"
        string customer_document "Snapshot CPF/CNPJ"
        string license_plate "Snapshot Placa"
        string status "Status do Ciclo da OS"
        numeric total_amount "Valor total orçado"
    }

    CUSTOMER ||--o{ WORK_ORDER : "solicita"
    VEHICLE ||--o{ WORK_ORDER : "atendido_em"

    %% Tabelas Associativas de Itens (Camada Intermediária)
    WORK_ORDER_SERVICE {
        uuid id PK "Chave Primária"
        uuid work_order_id FK "FK referenciando WORK_ORDER(id)"
        uuid service_id FK "FK referenciando SERVICE(id)"
        numeric unit_price "Preço Unitário Congelado"
        integer quantity "Quantidade"
    }

    WORK_ORDER_MATERIAL {
        uuid id PK "Chave Primária"
        uuid work_order_id FK "FK referenciando WORK_ORDER(id)"
        uuid material_id FK "FK referenciando MATERIAL(id)"
        numeric unit_price "Preço Unitário Congelado"
        integer quantity "Quantidade"
    }

    %% Catálogos de Itens (Base)
    SERVICE {
        uuid id PK "Chave Primária"
        string code UK "Código de Catálogo"
        string name "Nome do Serviço"
        numeric price "Preço de Mão de Obra"
    }

    MATERIAL {
        uuid id PK "Chave Primária"
        string sku UK "Código de Estoque / SKU"
        numeric unit_price "Preço Unitário"
        integer stock_quantity "Saldo de Estoque"
    }

    %% Relações Topo -> Meio -> Base (Dagre Top-to-Bottom Flow)
    WORK_ORDER ||--o{ WORK_ORDER_SERVICE : "possui"
    WORK_ORDER ||--o{ WORK_ORDER_MATERIAL : "possui"
    WORK_ORDER_SERVICE }o--|| SERVICE : "referencia_catalogo"
    WORK_ORDER_MATERIAL }o--|| MATERIAL : "referencia_catalogo"

    %% Microservice: api-billing (PostgreSQL - billing_db)
    INVOICE {
        uuid id PK "Chave Primária"
        uuid work_order_id UK "Chave Lógica Externa da OS"
        numeric amount "Valor Total Cobrado"
        string status "PENDING, PAID, FAILED"
        string external_payment_id "Mercado Pago ID"
    }

    PAYMENT_WEBHOOK {
        uuid id PK "Chave Primária"
        uuid invoice_id FK "Fatura Associada"
        string payment_status "Status do Gateway"
    }

    INVOICE ||--o{ PAYMENT_WEBHOOK : "registra_transacoes"

    %% Microservice: api-exec (MongoDB - exec_db)
    EXECUTION_ORDER {
        string id PK "ObjectId MongoDB (_id)"
        string workOrderId UK "Chave Lógica Externa da OS"
        string status "QUEUED, IN_REPAIR, COMPLETED"
        string technicianId "Mecânico Alocado"
    }

    CHECKLIST_ITEM {
        string task "Inspeção Técnica"
        boolean completed "Conformidade"
    }

    MAINTENANCE_MATERIAL {
        string sku "SKU da Peça Aplicada"
        integer quantity "Quantidade Consumida"
    }

    EXECUTION_ORDER ||--|{ CHECKLIST_ITEM : "embedded_checklists"
    EXECUTION_ORDER ||--o{ MAINTENANCE_MATERIAL : "embedded_materiais"

    %% Inter-service Choreographed Relationships (via Apache Kafka)
    WORK_ORDER ..> INVOICE : "WorkOrderApprovedEvent (Kafka)"
    INVOICE ..> EXECUTION_ORDER : "PaymentConfirmedEvent (Kafka)"
```

</div>
</div>

## Segurança e Gestão de Segredos
- Todas as credenciais mestras são geradas dinamicamente via `random_password`.
- Senhas e strings de conexão são armazenadas de forma segura e criptografada no **AWS Secrets Manager**.
- Subnets dedicadas e Security Groups restringem o tráfego de rede exclusivamente ao VPC do cluster Kubernetes.
- Zero credenciais ou variáveis sensíveis versionadas no Git.

## Estrutura de Módulos
- `modules/rds-postgres`: Módulo reutilizável para instâncias do Amazon RDS PostgreSQL.
- `modules/documentdb`: Módulo reutilizável para clusters do Amazon DocumentDB / MongoDB.

## Validação Sintática e de Conformidade
```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```
