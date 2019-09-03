# Módulo Terraform - GCP - Load Balance

<!-- TODO: revisar concordância e sentido da frase abaixo. -->
Módulo do Terraform para provisionamento de recursos do Load Balance (GCP).

## Uso

```hcl
module "load-balance" {
  source = "git::ssh://git@gitlab.com/mandic-labs/terraform/modules/google/load-balance.git?ref=master//load-balancer-global"

   name              = "${var.network_name}"
  target_tags       = ["${var.target_tags}"]
  firewall_networks = ["${var.network}"]

  backends = {
    "0" = [
      {
        group = "${var.region_instance_group}"
      }

    ]
  }

  backend_params = [
    // health check path, port name, port number, timeout seconds.
    "/,http,80,10",
  ]
}
```

## Recursos provisionados

<!-- TODO: alterar lista de recursos provisionados pelo módulo. -->
- Instância Load Balance


## Customizações


## Exemplos

<!-- TODO: alterar título e link abaixo conforme diretório de exemplo criado. -->
- [Exemplo GLOBAL simples](examples/simple-example/global)
- [Exemplo INTERNAL simples](examples/simple-example/internal)
- [Exemplo REGIONAL simples](examples/simple-example/regional)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Licença

Copyright © 2019 Mandic Cloud Solutions. Todos os direitos reservados.
