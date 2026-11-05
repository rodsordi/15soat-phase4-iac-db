resource "random_password" "mongodb_root_password" {
  length  = 20
  special = false
}

resource "kubernetes_namespace" "database" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "mongodb_auth" {
  metadata {
    name      = "${var.service_name}-auth"
    namespace = kubernetes_namespace.database.metadata[0].name
  }

  data = {
    "mongodb-root-username" = var.admin_username
    "mongodb-root-password" = random_password.mongodb_root_password.result
  }
}

resource "kubernetes_service" "mongodb" {
  metadata {
    name      = var.service_name
    namespace = kubernetes_namespace.database.metadata[0].name
    labels = {
      app = "mongodb"
    }
  }

  spec {
    selector = {
      app = "mongodb"
    }

    port {
      name        = "mongodb"
      port        = 27017
      target_port = 27017
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_stateful_set" "mongodb" {
  metadata {
    name      = var.service_name
    namespace = kubernetes_namespace.database.metadata[0].name
    labels = {
      app = "mongodb"
    }
  }

  spec {
    replicas     = 1
    service_name = var.service_name

    selector {
      match_labels = {
        app = "mongodb"
      }
    }

    template {
      metadata {
        labels = {
          app = "mongodb"
        }
      }

      spec {
        container {
          name  = "mongodb"
          image = "mongo:${var.mongodb_version}"

          port {
            container_port = 27017
            name           = "mongodb"
          }

          env {
            name = "MONGO_INITDB_ROOT_USERNAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mongodb_auth.metadata[0].name
                key  = "mongodb-root-username"
              }
            }
          }

          env {
            name = "MONGO_INITDB_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mongodb_auth.metadata[0].name
                key  = "mongodb-root-password"
              }
            }
          }

          env {
            name  = "MONGO_INITDB_DATABASE"
            value = var.database_name
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "1Gi"
            }
            requests = {
              cpu    = "100m"
              memory = "256Mi"
            }
          }

          volume_mount {
            name       = "mongodb-data"
            mount_path = "/data/db"
          }

          liveness_probe {
            tcp_socket {
              port = 27017
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            tcp_socket {
              port = 27017
            }
            initial_delay_seconds = 10
            period_seconds        = 5
          }
        }

        volume {
          name = "mongodb-data"
          empty_dir {}
        }
      }
    }
  }
}

resource "aws_secretsmanager_secret" "mongodb_credentials" {
  name                    = "exec-mongodb-credentials-${var.environment}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "mongodb_credentials" {
  secret_id = aws_secretsmanager_secret.mongodb_credentials.id
  secret_string = jsonencode({
    engine   = "mongodb"
    host     = "${var.service_name}.${kubernetes_namespace.database.metadata[0].name}.svc.cluster.local"
    port     = 27017
    database = var.database_name
    username = var.admin_username
    password = random_password.mongodb_root_password.result
    uri      = "mongodb://${var.admin_username}:${random_password.mongodb_root_password.result}@${var.service_name}.${kubernetes_namespace.database.metadata[0].name}.svc.cluster.local:27017/${var.database_name}?authSource=admin"
  })
}
