#!/bin/sh
set -e

php -r "
\$cfg = [
  'backend'         => ['frontName' => getenv('MAGENTO_BACKEND_FRONTNAME') ?: 'admin_vaapxp1'],
  'crypt'           => ['key' => getenv('MAGENTO_CRYPT_KEY')],
  'db'              => [
    'table_prefix' => '',
    'connection'   => ['default' => [
      'host'           => getenv('DB_HOST'),
      'dbname'         => getenv('DB_NAME') ?: 'magento',
      'username'       => getenv('DB_USER') ?: 'magento',
      'password'       => getenv('DB_PASSWORD'),
      'model'          => 'mysql4',
      'engine'         => 'innodb',
      'initStatements' => 'SET NAMES utf8;',
      'active'         => '1',
    ]],
  ],
  'resource'        => ['default_setup' => ['connection' => 'default']],
  'x-frame-options' => 'SAMEORIGIN',
  'MAGE_MODE'       => getenv('MAGE_MODE') ?: 'developer',
  'session'         => ['save' => 'files'],
  'cache_types'     => [
    'config'=>1,'layout'=>1,'block_html'=>1,'collections'=>1,'reflection'=>1,
    'db_ddl'=>1,'compiled_config'=>1,'eav'=>1,'customer_notification'=>1,
    'config_integration'=>1,'config_integration_api'=>1,'full_page'=>1,
    'config_webservice'=>1,'translate'=>1,
  ],
  'install'         => ['date' => date('D, d M Y H:i:s T')],
  'search'          => [
    'engine'                 => 'opensearch',
    'opensearch-host'        => getenv('OPENSEARCH_HOST'),
    'opensearch-port'        => 443,
    'opensearch-enable-auth' => 1,
    'opensearch-username'    => getenv('OPENSEARCH_USERNAME') ?: 'magento',
    'opensearch-password'    => getenv('OPENSEARCH_PASSWORD'),
    'opensearch-timeout'     => 15,
  ],
];
file_put_contents(
  '/var/www/html/app/etc/env.php',
  '<?php' . PHP_EOL . 'return ' . var_export(\$cfg, true) . ';' . PHP_EOL
);
echo '[entrypoint] env.php written' . PHP_EOL;
"

# Run DI compile on first boot if generated code is missing
if [ ! -f "/var/www/html/generated/code/Magento/Framework/App/ResourceConnection/Proxy.php" ]; then
    echo "[entrypoint] Running setup:di:compile..."
    php /var/www/html/bin/magento setup:di:compile --no-interaction
    echo "[entrypoint] setup:di:compile done"
fi

exec "$@"
