#These need to come from terraform
AWS_PRIVATE_SUBNET_ID: ${priv_subnet_a}
AWS_PRIVATE_SUBNET_ID_1: ${priv_subnet_b}
AWS_PRIVATE_SUBNET_ID_2: ${priv_subnet_c}
AWS_PUBLIC_SUBNET_ID: ${pub_subnet_a}
AWS_PUBLIC_SUBNET_ID_1: ${pub_subnet_b}
AWS_PUBLIC_SUBNET_ID_2: ${pub_subnet_c}
AWS_REGION: ${region}
AWS_VPC_ID: ${vpc_id}
AWS_NODE_AZ: ${region}a
AWS_NODE_AZ_1: ${region}b
AWS_NODE_AZ_2: ${region}c
AWS_SSH_KEY_NAME: ${kp_name}
CLUSTER_NAME: ${cluster_name}

#Everything below here doesn't change
CLUSTER_PLAN: prod
NAMESPACE: default
CNI: antrea
IDENTITY_MANAGEMENT_TYPE: none
AWS_LOAD_BALANCER_SCHEME_INTERNAL: true

AWS_PRIVATE_NODE_CIDR: ""
AWS_PRIVATE_NODE_CIDR_1: ""
AWS_PRIVATE_NODE_CIDR_2: ""
AWS_PUBLIC_NODE_CIDR: ""
AWS_PUBLIC_NODE_CIDR_1: ""
AWS_PUBLIC_NODE_CIDR_2: ""
AWS_VPC_CIDR: ""
BASTION_HOST_ENABLED: "false"
CLUSTER_CIDR: 100.96.0.0/11
CONTROL_PLANE_MACHINE_TYPE: t2.large
ENABLE_AUDIT_LOGGING: ""
ENABLE_CEIP_PARTICIPATION: "true"
ENABLE_MHC: "true"
INFRASTRUCTURE_PROVIDER: aws
LDAP_BIND_DN: ""
LDAP_BIND_PASSWORD: ""
LDAP_GROUP_SEARCH_BASE_DN: ""
LDAP_GROUP_SEARCH_FILTER: ""
LDAP_GROUP_SEARCH_GROUP_ATTRIBUTE: ""
LDAP_GROUP_SEARCH_NAME_ATTRIBUTE: cn
LDAP_GROUP_SEARCH_USER_ATTRIBUTE: DN
LDAP_HOST: ""
LDAP_ROOT_CA_DATA_B64: ""
LDAP_USER_SEARCH_BASE_DN: ""
LDAP_USER_SEARCH_FILTER: ""
LDAP_USER_SEARCH_NAME_ATTRIBUTE: ""
LDAP_USER_SEARCH_USERNAME: userPrincipalName
NODE_MACHINE_TYPE: t2.large
NODE_MACHINE_TYPE_1: t2.large
NODE_MACHINE_TYPE_2: t2.large
OIDC_IDENTITY_PROVIDER_SCOPES: email
OIDC_IDENTITY_PROVIDER_USERNAME_CLAIM: email
OIDC_IDENTITY_PROVIDER_GROUPS_CLAIM: groups
OIDC_IDENTITY_PROVIDER_CLIENT_ID: ""
OIDC_IDENTITY_PROVIDER_CLIENT_SECRET: ""
OIDC_IDENTITY_PROVIDER_ISSUER_URL: ""
OIDC_IDENTITY_PROVIDER_NAME: ""
OS_ARCH: amd64
OS_NAME: ubuntu
OS_VERSION: "20.04"
SERVICE_CIDR: 100.64.0.0/13
TKG_HTTP_PROXY_ENABLED: "false"
