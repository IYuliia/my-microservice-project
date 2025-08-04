# Модуль Terraform для RDS
Цей модуль Terraform створює повністю налаштовуваний екземпляр бази даних AWS RDS або кластер Aurora.

Приклад використання модуля

```
module "rds" {
  source      = "./modules/rds"

  db_name     = "exampledb"
  username    = "admin"
  password    = "supersecurepassword"
  port        = 5432

  engine              = "postgres"
  engine_version      = "15.3"
  instance_class      = "db.t3.micro"
  multi_az            = false
  use_aurora          = false

  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
}
```

## Архітектура


                    +-----------------------------+
                    |         AWS RDS            |
                    |-----------------------------|
                    | DB Name: exampledb          |
                    | Engine: postgres            |
                    | Class: db.t3.micro          |
                    | Subnet Group: DB-subnets    |
                    | Security Group: custom      |
                    +-------------+---------------+
                                  |
              +------------------+--------------------+
              |                                       |
     +--------v--------+                    +--------v--------+
     | Private Subnet 1|                    | Private Subnet 2|
     +-----------------+                    +-----------------+


## Вхідні змінні


| Назва                    | Тип    | Опис                                                     | Значення за замовчуванням |
|--------------------------|--------|----------------------------------------------------------|----------------------------|
| `db_name`                | string | Назва бази даних                                         | `""`                       |
| `username`               | string | Ім’я адміністратора бази даних                           | `""`                       |
| `password`               | string | Пароль адміністратора бази даних                         | `""`                       |
| `port`                   | number | Порт для доступу до бази даних                           | `5432`                     |
| `engine`                 | string | Тип рушія: `postgres`, `mysql`, `aurora-postgresql` тощо | `"postgres"`               |
| `engine_version`         | string | Версія рушія                                             | `"15.3"`                   |
| `instance_class`         | string | Клас екземпляру                                          | `"db.t3.micro"`            |
| `multi_az`               | bool   | Чи увімкнено Multi-AZ                                    | `false`                    |
| `use_aurora`             | bool   | Якщо `true` — створити Aurora кластер                    | `false`                    |
| `vpc_id`                 | string | ID VPC                                                   | `null`                     |
| `private_subnet_ids`     | list   | Приватні підмережі для Subnet Group                      | `[]`                       |
| `parameter_group_family` | string | Родина параметр-групи (наприклад, `postgres15`)          | `"postgres15"`             |
| `tags`                   | map    | Додаткові теги                                           | `{}`                       |



## Як змінити тип бази даних

 Для звичайної RDS:

```
use_aurora     = false
engine         = "postgres"
instance_class = "db.t3.micro"
```

 Для Aurora:

```
use_aurora     = true
engine         = "aurora-postgresql"
instance_class = "db.r6g.large"
```
Примітка: для Aurora обов’язково вкажи відповідну engine_version, наприклад "15.3" для aurora-postgresql.

## Вихідні значення

| Назва          | Опис                               |
|----------------|------------------------------------|
| `rds_endpoint` | DNS-адреса бази даних або кластера |
| `rds_port`     | Порт, на якому доступна база       |
| `rds_username` | Ім’я користувача                   |
| `rds_db_name`  | Назва бази даних                   |
| `rds_engine`   | Використаний рушій бази даних      |



## Приклад результату terraform apply

```
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

rds_db_name = "exampledb"
rds_endpoint = "exampledb.c9akcixxxxx.us-east-1.rds.amazonaws.com"
rds_engine = "postgres"
rds_port = 5432
rds_username = "admin"
```