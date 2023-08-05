# Rotate Customer Managed AWS KMS Keys

AWS offers two types of KMS keys-
- Customer-managed Keys
- AWS Managed Keys
  
In case of a compromise of the customer-managed key (CMK), it is the responsibility of the customer to disable the previous key and create a new one.
1. This script helps you create a new customer-managed key and attach the policy of the existing key to the new one.
2. It also attaches the `Alias` of the key to the new one so that consumers are not impacted in any way.
3. Once the key is generated and the alias has been moved to the new key, it disabled the previous key as well.

## Maintainer
This repo is maintained by `Inderpal Singh` and the project was created to automate similar requirements.


