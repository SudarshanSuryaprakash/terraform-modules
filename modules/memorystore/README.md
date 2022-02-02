# Google Cloud Memorystore Terraform Module

A Terraform module for creating a fully functional Google Memorystore (redis) instance.

## Compatibility
This module is meant for use with Terraform 0.13+ and tested using Terraform 1.0+.

## Usage

```hcl
module "memorystore" {
  count          = var.enable_memorystore ? 1 : 0
  source         = "./modules/memorystore"
  name           = "memorystore_example"
  project_id        = var.project_id
  region = "us-east4"
  memory_size_gb = "1"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alternative\_location\_id | The alternative zone where the instance will be provisioned. | `string` | `null` | no |
| auth\_enabled | Indicates whether OSS Redis AUTH is enabled for the instance. If set to true AUTH is enabled on the instance. | `bool` | `false` | no |
| authorized\_network | The full name of the Google Compute Engine network to which the instance is connected. If left unspecified, the default network will be used. | `string` | `null` | no |
| connect\_mode | The connection mode of the Redis instance. Can be either DIRECT\_PEERING or PRIVATE\_SERVICE\_ACCESS. The default connect mode if not provided is DIRECT\_PEERING. | `string` | `null` | no |
| display\_name | An arbitrary and optional user-provided name for the instance. | `string` | `null` | no |
| labels | The resource labels to represent user provided metadata. | `map(string)` | `null` | no |
| location\_id | The zone where the instance will be provisioned. If not provided, the service will choose a zone for the instance. For STANDARD\_HA tier, instances will be created across two zones for protection against zonal failures. If [alternativeLocationId] is also provided, it must be different from [locationId]. | `string` | `null` | no |
| memory\_size\_gb | Redis memory size in GiB. Defaulted to 1 GiB | `number` | `1` | no |
| name | The ID of the instance or a fully qualified identifier for the instance. | `string` | n/a | yes |
| project\_id | The ID of the project in which the resource belongs to. | `string` | n/a | yes |
| redis\_configs | The Redis configuration parameters. See [more details](https://cloud.google.com/memorystore/docs/redis/reference/rest/v1/projects.locations.instances#Instance.FIELDS.redis_configs) | `map(any)` | `{}` | no |
| redis\_version | The version of Redis software. | `string` | `null` | no |
| region | The GCP region to use. | `string` | `null` | no |
| reserved\_ip\_range | The CIDR range of internal addresses that are reserved for this instance. | `string` | `null` | no |
| tier | The service tier of the instance. https://cloud.google.com/memorystore/docs/redis/reference/rest/v1/projects.locations.instances#Tier | `string` | `"STANDARD_HA"` | no |
| transit\_encryption\_mode | The TLS mode of the Redis instance, If not provided, TLS is enabled for the instance. | `string` | `"SERVER_AUTHENTICATION"` | no |

## Outputs

| Name | Description |
|------|-------------|
| current\_location\_id | The current zone where the Redis endpoint is placed. |
| host | The IP address of the instance. |
| id | The memorystore instance ID. |
| port | The port number of the exposed Redis endpoint. |
| region | The region the instance lives in. |


