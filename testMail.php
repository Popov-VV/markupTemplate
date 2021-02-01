<?php


if (isset($argv[1])) {
    $to = $argv[1];
} else {
    $to = 'popov.v.viktor@gmail.com';
}

if (isset($_SERVER['argc'][2])) {
    $nameTemplate = $argv[1];
} else {
    $nameTemplate = 'example';
}

$subject = "Письмо с сайта";
$charset = "utf-8";
$headerss ="Content-type: text/html; charset=$charset\r\n";
$headerss.="MIME-Version: 1.0\r\n";
$headerss.="Date: ".date('D, d M Y h:i:s O')."\r\n";

$msg = file_get_contents('./email/' . $nameTemplate . '/resultEmail/' . $nameTemplate . '.html');

try {
    mail($to, $subject, $msg, $headerss);
} catch (Exception $e) {
    echo('Caught exception: ' . $e->getMessage() . "\n");
}

echo($msg);
echo("Сообщение успешно отправлено!");

