@secure()
param apis_owners_path string
param service_apim_krc_001_name string = 'apim-krc-001'

resource service_apim_krc_001_name_resource 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: service_apim_krc_001_name
  location: 'Korea Central'
  sku: {
    name: 'Consumption'
    capacity: 0
  }
  properties: {
    publisherEmail: 'nudbeach@gmail.com'
    publisherName: 'eg001'
    notificationSenderEmail: 'apimgmt-noreply@mail.windowsazure.com'
    hostnameConfigurations: [
      {
        type: 'Proxy'
        hostName: '${service_apim_krc_001_name}.azure-api.net'
        negotiateClientCertificate: false
        defaultSslBinding: true
        certificateSource: 'BuiltIn'
      }
    ]
    customProperties: {
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': 'false'
    }
    virtualNetworkType: 'None'
    apiVersionConstraint: {}
    publicNetworkAccess: 'Enabled'
  }
}

resource service_apim_krc_001_name_owners 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  name: '${service_apim_krc_001_name_resource.name}/owners'
  properties: {
    displayName: 'Owners'
    apiRevision: '1'
    subscriptionRequired: true
    protocols: [
      'http'
      'https'
    ]
    isCurrent: true
    path: apis_owners_path
  }
}

resource service_apim_krc_001_name_backend1 'Microsoft.ApiManagement/service/backends@2021-08-01' = {
  name: '${service_apim_krc_001_name_resource.name}/backend1'
  properties: {
    url: 'https://spc-krc-002-api-gateway.private.azuremicroservices.io'
    protocol: 'http'
    credentials: {
      query: {}
      header: {}
    }
    tls: {
      validateCertificateChain: true
      validateCertificateName: true
    }
  }
}

resource service_apim_krc_001_name_policy 'Microsoft.ApiManagement/service/policies@2021-08-01' = {
  name: '${service_apim_krc_001_name_resource.name}/policy'
  properties: {
    value: '<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - Only the <forward-request> policy element can appear within the <backend> section element.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy position the cursor at the desired insertion point and click on the round button associated with the policy.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n-->\r\n<policies>\r\n  <inbound></inbound>\r\n  <backend>\r\n    <forward-request />\r\n  </backend>\r\n  <outbound></outbound>\r\n</policies>'
    format: 'xml'
  }
}

resource service_apim_krc_001_name_master 'Microsoft.ApiManagement/service/subscriptions@2021-08-01' = {
  name: '${service_apim_krc_001_name_resource.name}/master'
  properties: {
    scope: '${service_apim_krc_001_name_resource.id}/'
    displayName: 'Built-in all-access subscription'
    state: 'active'
    allowTracing: true
  }
}

resource service_apim_krc_001_name_owners_owners 'Microsoft.ApiManagement/service/apis/operations@2021-08-01' = {
  name: '${service_apim_krc_001_name_owners.name}/owners'
  properties: {
    displayName: 'owners'
    method: 'GET'
    urlTemplate: '/api/customer/owners'
    templateParameters: []
    responses: []
  }
  dependsOn: [
    service_apim_krc_001_name_resource
  ]
}

resource service_apim_krc_001_name_owners_policy 'Microsoft.ApiManagement/service/apis/policies@2021-08-01' = {
  name: '${service_apim_krc_001_name_owners.name}/policy'
  properties: {
    value: '<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy, place the cursor at the desired insertion point and select a policy from the sidebar.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Position the <base> element within a section element to inherit all policies from the corresponding section element in the enclosing scope.\r\n    - Remove the <base> element to prevent inheriting policies from the corresponding section element in the enclosing scope.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n    - Comments within policy elements are not supported and may disappear. Place your comments between policy elements or at a higher level scope.\r\n-->\r\n<policies>\r\n  <inbound>\r\n    <base />\r\n  </inbound>\r\n  <backend>\r\n    <base />\r\n  </backend>\r\n  <outbound>\r\n    <base />\r\n  </outbound>\r\n  <on-error>\r\n    <base />\r\n  </on-error>\r\n</policies>'
    format: 'xml'
  }
  dependsOn: [
    service_apim_krc_001_name_resource
  ]
}

resource service_apim_krc_001_name_owners_owners_policy 'Microsoft.ApiManagement/service/apis/operations/policies@2021-08-01' = {
  name: '${service_apim_krc_001_name_owners_owners.name}/policy'
  properties: {
    value: '<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy, place the cursor at the desired insertion point and select a policy from the sidebar.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Position the <base> element within a section element to inherit all policies from the corresponding section element in the enclosing scope.\r\n    - Remove the <base> element to prevent inheriting policies from the corresponding section element in the enclosing scope.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n    - Comments within policy elements are not supported and may disappear. Place your comments between policy elements or at a higher level scope.\r\n-->\r\n<policies>\r\n  <inbound>\r\n    <base />\r\n    <set-backend-service base-url="https://spc-krc-001-api-gateway.azuremicroservices.io" />\r\n  </inbound>\r\n  <backend>\r\n    <base />\r\n  </backend>\r\n  <outbound>\r\n    <base />\r\n  </outbound>\r\n  <on-error>\r\n    <base />\r\n  </on-error>\r\n</policies>'
    format: 'xml'
  }
  dependsOn: [
    service_apim_krc_001_name_owners
    service_apim_krc_001_name_resource
  ]
}