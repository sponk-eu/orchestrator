#!/bin/sh
if [ -z "${ORC_CONSUL_ADDRESS}" ]; then
    ORC_CONSUL_ADDRESS="$(/sbin/ip route|awk '/default/ { print $3 }'):8500"
fi

if [ ! -e /etc/orchestrator.conf.json ] ; then
cat <<EOF > /etc/orchestrator.conf.json
{
    "Debug": true,
    "ListenAddress": ":3000",
    "MySQLTopologyUser":                        "${ORC_TOPOLOGY_USER:-orchestrator}",
    "MySQLTopologyPassword":                    "${ORC_TOPOLOGY_PASSWORD:-orchestrator}",
    "MySQLTopologyUseMutualTLS":                "${ORC_TOPOLOGY_USE_MUTUAL_TLS:-true}",
    "MySQLTopologySSLSkipVerify":               "${ORC_TOPOLOGY_SSL_SKIP_VERIFY:-true}",
    "MySQLOrchestratorHost":                    "${ORC_DB_HOST:-db}",
    "MySQLOrchestratorPort":                     ${ORC_DB_PORT:-3306},
    "MySQLOrchestratorDatabase":                "${ORC_DB_NAME:-orchestrator}",
    "MySQLOrchestratorUser":                    "${ORC_USER:-orc_server_user}",
    "MySQLOrchestratorPassword":                "${ORC_PASSWORD:-orc_server_password}",
    "MySQLOrchestratorCredentialsConfigFile":   "${ORC_DB_CREDENTIAL_FILE}",
    "MySQLOrchestratorSSLPrivateKeyFile":       "${ORC_SSL_PRIVATE_KEY}",
    "MySQLOrchestratorSSLCertFile":             "${ORC_SSL_PUBLIC_CERTIFICATE}",
    "MySQLOrchestratorSSLCAFile":               "${ORC_SSL_CA}",
    "MySQLOrchestratorSSLSkipVerify":            ${ORC_SSL_SKIP_VERIFY:-true},
    "MySQLOrchestratorUseMutualTLS":             ${ORC_USE_MUTUAL_TLS:-false},
    "DetectClusterAliasQuery":                  "${ORC_DETECT_CLUTER_ALIAS:-SELECT SUBSTRING_INDEX(@@hostname, '.', 1)}",
    "DetectClusterDomainQuery":                 "${ORC_DETECT_CLUTER_DOMAIN}",
    "DetectDataCenterQuery":                    "${ORC_DETECT_DATACENTER}",
    "AutoPseudoGTID":                            ${ORC_AUTO_PSEUDOGTID:-false},

    "MySQLHostnameResolveMethod":                "${ORC_HOSTNAME_RESOLVE_METHOD:-@@hostname}",
    "ClusterNameToAlias":                        {${ORC_CLUSTER_NAME_TO_ALIAS}},
    "RecoveryPeriodBlockSeconds":                 ${ORC_RECOVER_PERIOD_BLOCK_SECOND:-3600},
    "RecoverMasterClusterFilters":              [${ORC_RECOVER_MASTER_CLUSTER_FILTER:-"*"}],
    "RecoverIntermediateMasterClusterFilters":  [${ORC_RECOVER_INTERMEDIATE_CLUSTER_FILTER:-"*"}],
    "PostGracefulTakeoverProcesses":            [${ORC_POAT_GRACEFUL_TAKEOVER_PROCESSES:-"echo 'Planned takeover complete' >> /tmp/recovery.log"}],
    "DetachLostSlavesAfterMasterFailover":        ${ORC_DETACH_LOST_AFTER_MASTER_FAILOVER:-true},
    "ApplyMySQLPromotionAfterMasterFailover":     ${ORC_APPLY_MYSQL_PROMOTION_AFTER_MASTER_FAILOVER:-false},
    "MasterFailoverLostInstancesDowntimeMinutes": ${ORC_MASTER_FAILOVER_LOST_INSTANCES_DOWNTIME_MINUTE:-0},
    "ConsulAddress":                             "${ORC_CONSUL_ADDRESS}",
    "KVClusterMasterPrefix":                     "${ORC_CONSUL_KV_PREFIX}",
    "ConsulAclToken":                            "${ORC_CONSUL_ACL_TOKEN}",

    "SkipMaxScaleCheck":                          ${ORC_SKIP_MAX_SCALE_CHECK:-true},
    "RemoveTextFromHostnameDisplay":             "${ORC_REMOVE_TEXT_FROM_HOSTNAME_DISPLAY:-:3306}",
    "AccessTokenUseExpirySeconds":                ${ORC_ACCESS_TOKEN_USER_EXPIRY_SECOND:-60},
    "AccessTokenExpiryMinutes":                   ${ORC_ACCESS_TOKEN_EXPIRY_MINUTE:-1440}
}
EOF
fi

exec /usr/local/orchestrator/orchestrator http
