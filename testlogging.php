<?php

require 'vendor/autoload.php';
use Maxbanton\Cwh\Handler\CloudWatch;
use Monolog\Logger;
use Monolog\Formatter\LineFormatter;
use Monolog\Formatter\JsonFormatter;
use Monolog\Handler\SyslogHandler;
use Aws\CloudWatchLogs\CloudWatchLogsClient;
use Aws\Credentials\CredentialProvider;

$provider = CredentialProvider::defaultProvider();

$cwClient = new CloudWatchLogsClient([
  'region'      => 'eu-west-1',
  'version'     => '2014-03-28',
  'credentials' => $provider
]);

$cwGroupAudit = 'test-audit-development';
$cwGroupFront = 'test-frontendapp-development';
$cwStreamNameClients = 'deleted-clients';
$cwStreamNameDefault = "default";
$cwRetentionDays = 90;

$cwHandlerNotice = new CloudWatch($cwClient, $cwGroupAudit, $cwStreamNameClients, $cwRetentionDays, 10000, [ 'application' => 'test-audit-development' ],Logger::NOTICE);
$cwHandlerError = new CloudWatch($cwClient, $cwGroupFront, $cwStreamNameDefault, $cwRetentionDays, 10000, [ 'application' => 'test-frontendapp-development' ],Logger::ERROR);

$logger = new Logger('PHP Logging');
$formatter = new JsonFormatter();

$cwHandlerNotice->setFormatter($formatter);
$cwHandlerError->setFormatter($formatter);

$logger->pushHandler($cwHandlerNotice);
$logger->pushHandler($cwHandlerError);

$logger->notice('Application Auth Event: ',[ 'function'=>'login-action','result'=>'login-failure' ]);
$logger->error('Application ERROR: System Error');
