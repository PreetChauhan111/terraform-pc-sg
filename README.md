# pc-sg-wrapper

Wrapper module for AWS EC2 Security Groups.

## Source

This wrapper uses the upstream module from [`terraform-aws-modules/security-group/aws`](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest) version ~> 5.3 and adds local naming, common tags (Owner=pc, GitHubRepo), region/environment defaults.

## Usage

```hcl
module "example_sg" {
  source = "./pc-sg-wrapper"

  region    = "ap-south-1"
  environment = "dev"
  
  vpc_id = "vpc-12345678"
  name   = "my-security-group"
  
  ingress_rules = ["http-80-tcp", "https-443-tcp"]
  egress_rules  = ["all-all"]
  
  tags = {
    Purpose = "web-server"
  }
}
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `create` | Whether to create security group and all rules | `bool` | `true` |
| `create_sg` | Whether to create security group | `bool` | `true` |
| `security_group_id` | ID of existing security group whose rules we will manage | `string` | `null` |
| `vpc_id` | ID of the VPC where to create security group | `string` | `null` |
| `name` | Name of security group - not required if create_sg is false. Auto-generated as pc-<env>-<region>-sg if empty | `string` | `null` |
| `use_name_prefix` | Whether to use name_prefix or fixed name. Should be true to able to update security group name after initial creation | `bool` | `false` |
| `description` | Description of security group | `string` | `"Security Group managed by Terraform"` |
| `revoke_rules_on_delete` | Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself. Enable for EMR. | `bool` | `false` |
| `tags` | A mapping of tags to assign to security group. Merged with common tags | `map(string)` | `{}` |
| `create_timeout` | Time to wait for a security group to be created | `string` | `"10m"` |
| `delete_timeout` | Time to wait for a security group to be deleted | `string` | `"15m"` |
| `ingress_rules` | List of ingress rules to create by name | `list(string)` | `[]` |
| `ingress_with_self` | List of ingress rules to create where &#39;self&#39; is defined | `list(map(string))` | `[]` |
| `ingress_with_cidr_blocks` | List of ingress rules to create where &#39;cidr_blocks&#39; is used | `list(map(string))` | `[]` |
| `ingress_with_ipv6_cidr_blocks` | List of ingress rules to create where &#39;ipv6_cidr_blocks&#39; is used | `list(map(string))` | `[]` |
| `ingress_with_source_security_group_id` | List of ingress rules to create where &#39;source_security_group_id&#39; is used | `list(map(string))` | `[]` |
| `ingress_cidr_blocks` | List of IPv4 CIDR ranges to use on all ingress rules | `list(string)` | `[]` |
| `ingress_ipv6_cidr_blocks` | List of IPv6 CIDR ranges to use on all ingress rules | `list(string)` | `[]` |
| `ingress_prefix_list_ids` | List of prefix list IDs (for allowing access to VPC endpoints) to use on all ingress rules | `list(string)` | `[]` |
| `ingress_with_prefix_list_ids` | List of ingress rules to create where &#39;prefix_list_ids&#39; is used only | `list(map(string))` | `[]` |
| `computed_ingress_rules` | List of computed ingress rules to create by name | `list(string)` | `[]` |
| `number_of_computed_ingress_rules` | Number of computed ingress rules to create by name | `number` | `0` |
<!-- Abbreviated table for brevity; full list in variables.tf: all egress variants similar structure. See module source for full. --> |
| `egress_rules` | List of egress rules to create by name | `list(string)` | `[]` |
| `egress_cidr_blocks` | List of IPv4 CIDR ranges to use on all egress rules | `list(string)` | `["0.0.0.0/0"]` |
| `egress_ipv6_cidr_blocks` | List of IPv6 CIDR ranges to use on all egress rules | `list(string)` | `["::/0"]` |
| `region` | AWS Region | `string` | `"ap-south-1"` |
| `environment` | Deployment environment | `string` | `"Dev"` |
| `putin_khuylo` | Fun var | `bool` | `true` |

Full inputs: see [variables.tf](variables.tf).

## Outputs

| Name | Description |
|------|-------------|
| `security_group_arn` | The ARN of the security group |
| `security_group_id` | The ID of the security group |
| `security_group_vpc_id` | The VPC ID |
| `security_group_owner_id` | The owner ID |
| `security_group_name` | The name of the security group |
| `security_group_description` | The description of the security group |

## Notes

- Auto-generates name as `pc-<environment>-<region>-sg` if `name` empty.
- Merges user `tags` with common tags: `{Environment, Owner=pc, GitHubRepo=pc-sg-wrapper, Name}`.
- Default region `ap-south-1`, environment `Dev`.
- Supports existing SG management (`security_group_id`, `create_sg=false`).
- Includes [rules.tf](rules.tf) and [update_groups.sh](update_groups.sh) for additional functionality.
- Requires `putin_khuylo=true` (non-propagating).

