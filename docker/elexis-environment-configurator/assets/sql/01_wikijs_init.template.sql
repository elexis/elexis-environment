INSERT IGNORE INTO `analytics` (`key`, `isEnabled`, `config`) VALUES ('azureinsights',0,'{\"instrumentationKey\": \"\"}');
INSERT IGNORE INTO `analytics` (`key`, `isEnabled`, `config`) VALUES ('countly',0,'{\"appKey\": \"\", \"serverUrl\": \"\"}');
INSERT IGNORE INTO `analytics` (`key`, `isEnabled`, `config`) VALUES ('elasticapm',0,'{\"serverUrl\": \"http://apm.example.com:8200\", \"environment\": \"\", \"serviceName\": \"wiki-js\"}');
INSERT IGNORE INTO `analytics` (`key`, `isEnabled`, `config`) VALUES ('fathom',0,'{\"host\": \"\", \"siteId\": \"\"}');
INSERT IGNORE INTO `analytics` (`key`, `isEnabled`, `config`) VALUES ('fullstory',0,'{\"org\": \"\"}');
INSERT IGNORE INTO `analytics` (`key`, `isEnabled`, `config`) VALUES ('google',0,'{\"propertyTrackingId\": \"\"}');
INSERT IGNORE INTO `analytics` (`key`, `isEnabled`, `config`) VALUES ('gtm',0,'{\"containerTrackingId\": \"\"}');
INSERT IGNORE INTO `analytics` (`key`, `isEnabled`, `config`) VALUES ('hotjar',0,'{\"siteId\": \"\"}');
INSERT IGNORE INTO `analytics` (`key`, `isEnabled`, `config`) VALUES ('matomo',0,'{\"siteId\": 1, \"scriptUrl\": \"//cdn.matomo.cloud/EXAMPLE.matomo.cloud/matomo.js\", \"serverHost\": \"https://example.matomo.cloud\"}');
INSERT IGNORE INTO `analytics` (`key`, `isEnabled`, `config`) VALUES ('newrelic',0,'{\"appId\": \"\", \"licenseKey\": \"\"}');
INSERT IGNORE INTO `analytics` (`key`, `isEnabled`, `config`) VALUES ('statcounter',0,'{\"projectId\": \"\", \"securityToken\": \"\"}');
INSERT IGNORE INTO `analytics` (`key`, `isEnabled`, `config`) VALUES ('yandex',0,'{\"tagNumber\": \"\"}');

INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('auth0',0,'{\"domain\": \"\", \"clientId\": \"\", \"clientSecret\": \"\"}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('azure',0,'{\"clientId\": \"\", \"entryPoint\": \"\"}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('cas',0,'{\"ssoBaseURL\": \"\", \"serverBaseURL\": \"\"}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('discord',0,'{\"clientId\": \"\", \"clientSecret\": \"\"}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('dropbox',0,'{\"clientId\": \"\", \"clientSecret\": \"\"}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('facebook',0,'{\"clientId\": \"\", \"clientSecret\": \"\"}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('firebase',0,'{}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('github',0,'{\"clientId\": \"\", \"clientSecret\": \"\", \"useEnterprise\": false, \"enterpriseDomain\": \"\", \"enterpriseUserEndpoint\": \"https://api.github.com/user\"}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('gitlab',0,'{\"baseUrl\": \"https://gitlab.com\", \"clientId\": \"\", \"clientSecret\": \"\"}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('google',0,'{\"clientId\": \"\", \"clientSecret\": \"\"}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('ldap',0,'{\"url\": \"ldap://serverhost:389\", \"bindDn\": \"cn=\'root\'\", \"mappingUID\": \"uid\", \"searchBase\": \"o=users,o=example.com\", \"tlsEnabled\": false, \"tlsCertPath\": \"\", \"mappingEmail\": \"mail\", \"searchFilter\": \"(uid={{username}})\", \"mappingPicture\": \"jpegPhoto\", \"bindCredentials\": \"\", \"mappingDisplayName\": \"displayName\"}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('local',1,'{}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('microsoft',0,'{\"clientId\": \"\", \"clientSecret\": \"\"}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('oauth2',0,'{\"clientId\": \"\", \"tokenURL\": \"\", \"clientSecret\": \"\", \"authorizationURL\": \"\"}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('oidc',0,'{\"issuer\": \"\", \"clientId\": \"\", \"tokenURL\": \"\", \"emailClaim\": \"\", \"userInfoUrl\": \"\", \"clientSecret\": \"\", \"usernameClaim\": \"\", \"authorizationURL\": \"\"}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('okta',0,'{\"idp\": \"\", \"audience\": \"\", \"clientId\": \"\", \"clientSecret\": \"\"}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('saml',0,'{\"cert\": \"\", \"issuer\": \"\", \"audience\": \"\", \"entryPoint\": \"\", \"forceAuthn\": false, \"mappingUID\": \"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier\", \"privateCert\": \"\", \"authnContext\": \"urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport\", \"mappingEmail\": \"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress\", \"providerName\": \"wiki.js\", \"decryptionPvk\": \"\", \"mappingPicture\": \"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/picture\", \"identifierFormat\": \"urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress\", \"mappingDisplayName\": \"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name\", \"signatureAlgorithm\": \"sha1\", \"acceptedClockSkewMs\": -1, \"authnRequestBinding\": \"HTTP-POST\", \"skipRequestCompression\": false, \"disableRequestedAuthnContext\": false}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('slack',0,'{\"team\": \"\", \"clientId\": \"\", \"clientSecret\": \"\"}',0,'{\"v\": []}','{\"v\": []}');
INSERT IGNORE INTO `authentication` (`key`, `isEnabled`, `config`, `selfRegistration`, `domainWhitelist`, `autoEnrollGroups`) VALUES ('twitch',0,'{\"clientId\": \"\", \"clientSecret\": \"\"}',0,'{\"v\": []}','{\"v\": []}');

INSERT IGNORE INTO `editors` (`key`, `isEnabled`, `config`) VALUES ('markdown',1,'{}');
INSERT IGNORE INTO `editors` (`key`, `isEnabled`, `config`) VALUES ('wysiwyg',0,'{}');

INSERT IGNORE INTO `groups` (`id`, `name`, `permissions`, `pageRules`, `isSystem`, `createdAt`, `updatedAt`) VALUES (1,'Administrators','[\"manage:system\"]','[]',1,'${NOW_ISO}','${NOW_ISO}');
INSERT IGNORE INTO `groups` (`id`, `name`, `permissions`, `pageRules`, `isSystem`, `createdAt`, `updatedAt`) VALUES (2,'Guests','[\"read:pages\", \"read:assets\", \"read:comments\"]','[{\"id\": \"guest\", \"deny\": false, \"path\": \"\", \"match\": \"START\", \"roles\": [\"read:pages\", \"read:assets\", \"read:comments\"], \"locales\": []}]',1,'2019-08-23T10:53:19.984Z','2019-08-23T10:53:19.984Z');

INSERT IGNORE INTO `locales` (`code`, `strings`, `isRTL`, `name`, `nativeName`, `createdAt`, `updatedAt`, `availability`) VALUES ('en','{}',0,'English','English','${NOW_ISO}','2000-01-01T10:53:23.243Z',0);
INSERT IGNORE INTO `locales` (`code`, `strings`, `isRTL`, `name`, `nativeName`, `createdAt`, `updatedAt`, `availability`) VALUES ('de','{}',0,'German','Deutsch','${NOW_ISO}','2000-01-01T10:53:23.243Z',0);

INSERT IGNORE INTO `loggers` (`key`, `isEnabled`, `level`, `config`) VALUES ('airbrake',0,'warn','{}');
INSERT IGNORE INTO `loggers` (`key`, `isEnabled`, `level`, `config`) VALUES ('bugsnag',0,'warn','{\"key\": \"\"}');
INSERT IGNORE INTO `loggers` (`key`, `isEnabled`, `level`, `config`) VALUES ('disk',0,'info','{}');
INSERT IGNORE INTO `loggers` (`key`, `isEnabled`, `level`, `config`) VALUES ('eventlog',0,'warn','{}');
INSERT IGNORE INTO `loggers` (`key`, `isEnabled`, `level`, `config`) VALUES ('loggly',0,'warn','{\"token\": \"\", \"subdomain\": \"\"}');
INSERT IGNORE INTO `loggers` (`key`, `isEnabled`, `level`, `config`) VALUES ('logstash',0,'warn','{}');
INSERT IGNORE INTO `loggers` (`key`, `isEnabled`, `level`, `config`) VALUES ('newrelic',0,'warn','{}');
INSERT IGNORE INTO `loggers` (`key`, `isEnabled`, `level`, `config`) VALUES ('papertrail',0,'warn','{\"host\": \"\", \"port\": 0}');
INSERT IGNORE INTO `loggers` (`key`, `isEnabled`, `level`, `config`) VALUES ('raygun',0,'warn','{}');
INSERT IGNORE INTO `loggers` (`key`, `isEnabled`, `level`, `config`) VALUES ('rollbar',0,'warn','{\"key\": \"\"}');
INSERT IGNORE INTO `loggers` (`key`, `isEnabled`, `level`, `config`) VALUES ('sentry',0,'warn','{\"key\": \"\"}');
INSERT IGNORE INTO `loggers` (`key`, `isEnabled`, `level`, `config`) VALUES ('syslog',0,'warn','{}');

INSERT IGNORE INTO `migrations` (`id`, `name`, `batch`, `migration_time`) VALUES (1,'2.0.0-beta.1.js',1,'2019-08-23 08:48:14');
INSERT IGNORE INTO `migrations` (`id`, `name`, `batch`, `migration_time`) VALUES (2,'2.0.0-beta.11.js',1,'2019-08-23 08:48:14');
INSERT IGNORE INTO `migrations` (`id`, `name`, `batch`, `migration_time`) VALUES (3,'2.0.0-beta.38.js',1,'2019-08-23 08:48:14');
INSERT IGNORE INTO `migrations` (`id`, `name`, `batch`, `migration_time`) VALUES (4,'2.0.0-beta.99.js',1,'2019-08-23 08:48:14');
INSERT IGNORE INTO `migrations` (`id`, `name`, `batch`, `migration_time`) VALUES (5,'2.0.0-beta.127.js',1,'2019-08-23 08:48:14');
INSERT IGNORE INTO `migrations` (`id`, `name`, `batch`, `migration_time`) VALUES (6,'2.0.0-beta.148.js',1,'2019-08-23 08:48:14');
INSERT IGNORE INTO `migrations` (`id`, `name`, `batch`, `migration_time`) VALUES (7,'2.0.0-beta.205.js',1,'2019-08-23 08:48:14');
INSERT IGNORE INTO `migrations` (`id`, `name`, `batch`, `migration_time`) VALUES (8,'2.0.0-beta.217.js',1,'2019-08-23 08:48:14');

INSERT IGNORE INTO `navigation` (`key`, `config`) VALUES ('site','[{\"id\": \"841c1c41-6d0c-4f26-837a-70097706a779\", \"icon\": \"home\", \"kind\": \"link\", \"label\": \"Home\", \"target\": \"/\", \"targetType\": \"home\"}]');

INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('htmlAsciinema',0,'{}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('htmlBlockquotes',1,'{}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('htmlCodehighlighter',1,'{}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('htmlCore',1,'{}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('htmlMathjax',0,'{}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('htmlMediaplayers',1,'{}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('htmlMermaid',0,'{}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('htmlPlantuml',0,'{}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('htmlSecurity',1,'{\"stripJS\": false, \"filterBadWords\": false}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('htmlTwemoji',1,'{}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('markdownAbbr',1,'{}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('markdownCore',1,'{\"quotes\": \"English\", \"linkify\": true, \"allowHTML\": true, \"linebreaks\": true, \"typographer\": false}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('markdownEmoji',1,'{}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('markdownExpandtabs',1,'{\"tabWidth\": 4}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('markdownFootnotes',1,'{}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('markdownImsize',1,'{}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('markdownMathjax',0,'{}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('markdownSupsub',1,'{\"subEnabled\": true, \"supEnabled\": true}');
INSERT IGNORE INTO `renderers` (`key`, `isEnabled`, `config`) VALUES ('markdownTasklists',1,'{}');

INSERT IGNORE INTO `searchEngines` (`key`, `isEnabled`, `config`) VALUES ('algolia',0,'{\"appId\": \"\", \"apiKey\": \"\", \"indexName\": \"wiki\"}');
INSERT IGNORE INTO `searchEngines` (`key`, `isEnabled`, `config`) VALUES ('aws',0,'{\"domain\": \"\", \"region\": \"us-east-1\", \"endpoint\": \"\", \"accessKeyId\": \"\", \"secretAccessKey\": \"\", \"AnalysisSchemeLang\": \"en\"}');
INSERT IGNORE INTO `searchEngines` (`key`, `isEnabled`, `config`) VALUES ('azure',0,'{\"adminKey\": \"\", \"indexName\": \"wiki\", \"serviceName\": \"\"}');
INSERT IGNORE INTO `searchEngines` (`key`, `isEnabled`, `config`) VALUES ('db',1,'{}');
INSERT IGNORE INTO `searchEngines` (`key`, `isEnabled`, `config`) VALUES ('elasticsearch',0,'{\"hosts\": \"\", \"indexName\": \"wiki\", \"apiVersion\": \"6.x\", \"sniffOnStart\": false, \"sniffInterval\": 0}');
INSERT IGNORE INTO `searchEngines` (`key`, `isEnabled`, `config`) VALUES ('manticore',0,'{}');
INSERT IGNORE INTO `searchEngines` (`key`, `isEnabled`, `config`) VALUES ('postgres',0,'{\"dictLanguage\": \"english\"}');
INSERT IGNORE INTO `searchEngines` (`key`, `isEnabled`, `config`) VALUES ('solr',0,'{\"core\": \"wiki\", \"host\": \"solr\", \"port\": 8983, \"protocol\": \"http\"}');
INSERT IGNORE INTO `searchEngines` (`key`, `isEnabled`, `config`) VALUES ('sphinx',0,'{}');

INSERT IGNORE INTO `settings` (`key`, `value`, `updatedAt`) VALUES ('auth','{\"audience\": \"urn:wiki.js\", \"tokenRenewal\": \"14d\", \"tokenExpiration\": \"30m\"}','${NOW_ISO}');
INSERT IGNORE INTO `settings` (`key`, `value`, `updatedAt`) VALUES ('certs','{\"jwk\": {\"e\": \"AQAB\", \"n\": \"zIVXA40WnW6wOhE_2kWmxh3WmUhXJF3yEIbhqiLGQtTJPYIJBGqAaMBPckUkv6OY_hnhauFH_4mFmKFhMH950xwm3iLsG86G3WLBCa0YhR8XL_GV91JsYYSSipVTd-QGNLrRe98G4UmtFu_fNnIAZFfwi0uNVPOvMhG9d0DJrLsg4Klamlp_mIq5vvHTabG7PMty0zeNzWl4XEjZlfLkUigmCJhssX9MBrKIW6tt8ShUu4WvuTabVQn8Tneg-Onn_IfYxtLNk1DCkMNbqq7dHVSqhpv13T0Xsx6BVkP-w_vd5zWbvsDUDs9H0c7NPJjYQWC8ylmY6ZNW8olPN7ZEWw\", \"kty\": \"RSA\"}, \"public\": \"-----BEGIN RSA PUBLIC KEY-----\\nMIIBCgKCAQEAzIVXA40WnW6wOhE/2kWmxh3WmUhXJF3yEIbhqiLGQtTJPYIJBGqA\\naMBPckUkv6OY/hnhauFH/4mFmKFhMH950xwm3iLsG86G3WLBCa0YhR8XL/GV91Js\\nYYSSipVTd+QGNLrRe98G4UmtFu/fNnIAZFfwi0uNVPOvMhG9d0DJrLsg4Klamlp/\\nmIq5vvHTabG7PMty0zeNzWl4XEjZlfLkUigmCJhssX9MBrKIW6tt8ShUu4WvuTab\\nVQn8Tneg+Onn/IfYxtLNk1DCkMNbqq7dHVSqhpv13T0Xsx6BVkP+w/vd5zWbvsDU\\nDs9H0c7NPJjYQWC8ylmY6ZNW8olPN7ZEWwIDAQAB\\n-----END RSA PUBLIC KEY-----\\n\", \"private\": \"-----BEGIN RSA PRIVATE KEY-----\\nProc-Type: 4,ENCRYPTED\\nDEK-Info: AES-256-CBC,E2D2ADEBD3F7F7966AB8C67AACD0CD5A\\n\\nrIAXOj/IJ7O5fVM3SU0mEH8+LYDdSUYbpKhAhoQsRtBJL7J1R9//mZVnanoQV/AO\\ncDVn0/D4WuAm978dMvIPCsdttPcpoW3JhN0ME2K1HICdxHZFzLqiA7JPVqQ20JYB\\nHYrQr2Td7FXfBzHVEkoxbw9aF5Lm7z2HVAzuhiA/IefhI0LxmxcfHqNcBZdrGJcy\\nCTT4BDqKHzN1qf7keCHvXdKbu2yAJ6BSzmiZu17+YOQ5qzpYL98KZ43lSCwQrJqf\\nj6mF76zf6kmjFkfxbhiczYfy/64uHt+v+2YryJxB3X00LAej093CyZckb3VnZD+w\\nmE59tS28+tuX6BnRjO1Os0nwtOaLftw32LqWhed0RNWLSntNvqgUBl+o/QSBWAXt\\nohx17jeQEQOOnEsWDXrSXyFvCUZ5vnbQ1rUSiavplwI0YeHEs17IcmmmrJh++s5V\\nWVQkoISuNVWpWmtTZBTRGyFV/xbuZLiAc5VOiA09/XqBmAl9mPmqdV9je36PpenD\\nuLBpvKo6/ow++1EL6yLQgqW/3iIhtDxvRApeZCZM12JUdFpOWcAkQByCAs58l5uQ\\njeW6vgIScjDAQP+uJiRpUbR9Ozl43ebvsQa9izMawYbpNGJMXDJgV4TT6rrBmjAL\\nrb3inR80vtJQ2cfINzNzEOwdNkaSeiMP0K4ecP9gu+hvkurpaaA9DI2XbrrwLfIc\\nRjUr//zr/TmKJ8QqYR1zI8OAE0rxwa38HnApTJPBNyd08JL15f4v5XoX5JQxmqJg\\n6Mg4LkQfnEAy/eCMjJwP57PU3TyaIaDaDuGhyDslbb8URRYl/5fwcZUK/1r+W0d3\\nCZvuUety/bQlFKNn5JXMlyveVXFZfV5N5KTeiShrJB98xvgGNSo57YkxFwra7Hk2\\nzKGNnP+qNvY6MFTRztaXq0uCasbYi3VU9pnKiAUbuS1Vk55+0IBd3ZZh7qLOe9ip\\n5LSEMhF5U4N5NICJGGEtUZsFS81KsMTLQcsl8BTi71R4dit8HKr1bZTT3Hzw+LGZ\\nW5l0EqKn2E8Aq5IRaDSn4JN6INN8TVZUp3tNnidUmto3hEk84hcmhBfEfP3GpqSI\\nRRN/Ws4JqgjIZNyLGI8iRGEu64UZZVOfEFmuNUAPQ1Dp2Gh/6fWLK5dJvp6uVmsk\\nwJ8+zQHNeJkPDfpm67wsQuixhIW2wdov06bwHPPibVj0f3FG4MmhkKEuWTM1sATo\\nAetRW3K+z8CNP3Uo1pDuN2JuyrmaOGrsq/mTsqp+xwTz6uOlPGmgXQuvv8tifPNZ\\nO/XPmGe4FFgdN9lFjIuEl0rkQ9R7PRaIdyeSLCNesfW4G4iPOYSlUP/bIrJdgUny\\n1EMrKETpxHKtaaeBiAr+b6rVVIbWGN94hXrCdtUzH21HqQbgGdst5NBK87SkFDRs\\n6dcG2Nz2q5yGj8zp5dcFRciRuQDMIu6z/Sx3cFZg73SqWACCBuxt+vgFPhVsx0vU\\nmKui+oFcQyGlTDIKQ2qKja+B+6Y6wCQjaf4hye1j+lcSaxlNdR7bZrrImD4C7B7j\\n44SLzUzEBgRS62HkfkFYjp33kRmqWrNFu7Odhu2NWkwFtPtsBZh7wMHtrcGZEgOH\\n-----END RSA PRIVATE KEY-----\\n\"}','2019-08-23T10:53:19.933Z');
INSERT IGNORE INTO `settings` (`key`, `value`, `updatedAt`) VALUES ('company','{\"v\": \"\"}','${NOW_ISO}');
INSERT IGNORE INTO `settings` (`key`, `value`, `updatedAt`) VALUES ('features','{\"featurePageRatings\": true, \"featurePageComments\": true, \"featurePersonalWikis\": true}','${NOW_ISO}');
INSERT IGNORE INTO `settings` (`key`, `value`, `updatedAt`) VALUES ('graphEndpoint','{\"v\": \"https://graph.requarks.io\"}','${NOW_ISO}');
INSERT IGNORE INTO `settings` (`key`, `value`, `updatedAt`) VALUES ('host','{\"v\": \"http://\"}','${NOW_ISO}');
INSERT IGNORE INTO `settings` (`key`, `value`, `updatedAt`) VALUES ('lang','{\"code\": \"en\", \"autoUpdate\": true, \"namespaces\": [], \"namespacing\": false}','${NOW_ISO}');
INSERT IGNORE INTO `settings` (`key`, `value`, `updatedAt`) VALUES ('logo','{\"hasLogo\": false, \"logoIsSquare\": false}','${NOW_ISO}');
INSERT IGNORE INTO `settings` (`key`, `value`, `updatedAt`) VALUES ('mail','{\"host\": \"\", \"pass\": \"\", \"port\": 465, \"user\": \"\", \"secure\": true, \"useDKIM\": false, \"senderName\": \"\", \"senderEmail\": \"\", \"dkimDomainName\": \"\", \"dkimPrivateKey\": \"\", \"dkimKeySelector\": \"\"}','${NOW_ISO}');
INSERT IGNORE INTO `settings` (`key`, `value`, `updatedAt`) VALUES ('seo','{\"robots\": [\"index\", \"follow\"], \"analyticsId\": \"\", \"description\": \"\", \"analyticsService\": \"\"}','${NOW_ISO}');
INSERT IGNORE INTO `settings` (`key`, `value`, `updatedAt`) VALUES ('sessionSecret','{\"v\": \"af76481fad4e9913625a24eb37903b406f4a9d209ba03e405f2bc343e69d9228\"}','${NOW_ISO}');
INSERT IGNORE INTO `settings` (`key`, `value`, `updatedAt`) VALUES ('telemetry','{\"clientId\": \"bfae5114-d776-425f-88ec-6dcb42cb2539\", \"isEnabled\": false}','${NOW_ISO}');
INSERT IGNORE INTO `settings` (`key`, `value`, `updatedAt`) VALUES ('theming','{\"theme\": \"default\", \"darkMode\": false}','${NOW_ISO}');
INSERT IGNORE INTO `settings` (`key`, `value`, `updatedAt`) VALUES ('title','{\"v\": \"Wiki.js\"}','${NOW_ISO}');

INSERT IGNORE INTO `storage` (`key`, `isEnabled`, `mode`, `config`, `syncInterval`, `state`) VALUES ('azure',0,'push','{\"container\": \"\", \"accountKey\": \"\", \"accountName\": \"\"}','P0D','{\"status\": \"pending\", \"message\": \"\", \"lastAttempt\": null}');
INSERT IGNORE INTO `storage` (`key`, `isEnabled`, `mode`, `config`, `syncInterval`, `state`) VALUES ('box',0,'push','{\"clientId\": \"\", \"rootFolder\": \"\", \"clientSecret\": \"\"}','P0D','{\"status\": \"pending\", \"message\": \"\", \"lastAttempt\": null}');
INSERT IGNORE INTO `storage` (`key`, `isEnabled`, `mode`, `config`, `syncInterval`, `state`) VALUES ('digitalocean',0,'push','{\"region\": \"nyc3\", \"spaceId\": \"\", \"accessKeyId\": \"\", \"secretAccessKey\": \"\"}','P0D','{\"status\": \"pending\", \"message\": \"\", \"lastAttempt\": null}');
INSERT IGNORE INTO `storage` (`key`, `isEnabled`, `mode`, `config`, `syncInterval`, `state`) VALUES ('disk',0,'push','{\"path\": \"\", \"createDailyBackups\": false}','P0D','{\"status\": \"pending\", \"message\": \"\", \"lastAttempt\": null}');
INSERT IGNORE INTO `storage` (`key`, `isEnabled`, `mode`, `config`, `syncInterval`, `state`) VALUES ('dropbox',0,'push','{\"appKey\": \"\", \"appSecret\": \"\"}','P0D','{\"status\": \"pending\", \"message\": \"\", \"lastAttempt\": null}');
INSERT IGNORE INTO `storage` (`key`, `isEnabled`, `mode`, `config`, `syncInterval`, `state`) VALUES ('gdrive',0,'push','{\"clientId\": \"\", \"clientSecret\": \"\"}','P0D','{\"status\": \"pending\", \"message\": \"\", \"lastAttempt\": null}');
INSERT IGNORE INTO `storage` (`key`, `isEnabled`, `mode`, `config`, `syncInterval`, `state`) VALUES ('git',0,'sync','{\"branch\": \"master\", \"repoUrl\": \"\", \"authType\": \"ssh\", \"verifySSL\": true, \"defaultName\": \"John Smith\", \"defaultEmail\": \"name@company.com\", \"basicPassword\": \"\", \"basicUsername\": \"\", \"gitBinaryPath\": \"\", \"localRepoPath\": \"./data/repo\", \"sshPrivateKeyMode\": \"path\", \"sshPrivateKeyPath\": \"\", \"sshPrivateKeyContent\": \"\"}','PT5M','{\"status\": \"pending\", \"message\": \"\", \"lastAttempt\": null}');
INSERT IGNORE INTO `storage` (`key`, `isEnabled`, `mode`, `config`, `syncInterval`, `state`) VALUES ('onedrive',0,'push','{\"clientId\": \"\", \"clientSecret\": \"\"}','P0D','{\"status\": \"pending\", \"message\": \"\", \"lastAttempt\": null}');
INSERT IGNORE INTO `storage` (`key`, `isEnabled`, `mode`, `config`, `syncInterval`, `state`) VALUES ('s3',0,'push','{\"bucket\": \"\", \"region\": \"\", \"accessKeyId\": \"\", \"accessSecret\": \"\"}','P0D','{\"status\": \"pending\", \"message\": \"\", \"lastAttempt\": null}');
INSERT IGNORE INTO `storage` (`key`, `isEnabled`, `mode`, `config`, `syncInterval`, `state`) VALUES ('scp',0,'push','{\"host\": \"\", \"port\": 22, \"basePath\": \"~\", \"username\": \"\", \"privateKeyPath\": \"\"}','P0D','{\"status\": \"pending\", \"message\": \"\", \"lastAttempt\": null}');

INSERT IGNORE INTO `users` (`id`, `email`, `name`, `providerId`, `password`, `tfaIsActive`, `tfaSecret`, `jobTitle`, `location`, `pictureUrl`, `timezone`, `isSystem`, `isActive`, `isVerified`, `createdAt`, `updatedAt`, `providerKey`, `localeCode`, `defaultEditor`) 
VALUES (1,'${ADMIN_EMAIL}','${ADMIN_USERNAME}',NULL,'${ENCRYPTED_PASS}',0,NULL,'','',NULL,'Europe/Zurich',0,1,1,'${NOW_ISO}','${NOW_ISO}','local','en','markdown');
INSERT IGNORE INTO `users` (`id`, `email`, `name`, `providerId`, `password`, `tfaIsActive`, `tfaSecret`, `jobTitle`, `location`, `pictureUrl`, `timezone`, `isSystem`, `isActive`, `isVerified`, `createdAt`, `updatedAt`, `providerKey`, `localeCode`, `defaultEditor`) 
VALUES (2,'guest@example.com','Guest',NULL,'',0,NULL,'','',NULL,'America/New_York',1,1,1,'${NOW_ISO}','${NOW_ISO}','local','en','markdown');

INSERT IGNORE INTO `userGroups` (`id`, `userId`, `groupId`) VALUES (1,1,1);
INSERT IGNORE INTO `userGroups` (`id`, `userId`, `groupId`) VALUES (2,2,2);