<?php
declare(strict_types=1);

use Symfony\Component\Dotenv\Dotenv;

if (PHP_VERSION_ID < 70200) {
    echo 'Your PHP version is ' . phpversion() . "." . PHP_EOL;
    echo 'You need a least PHP version 7.2.0';
    exit(1);
}

require(dirname(__DIR__) . "/vendor/autoload.php");

(new Dotenv())->loadEnv(dirname(__DIR__).'/.env');
