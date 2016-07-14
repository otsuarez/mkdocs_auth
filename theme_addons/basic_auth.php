<?php
/*
 * http://php.net/manual/es/features.http-auth.php
 */

$dominio = 'Authorization required';

if (empty($_SERVER['PHP_AUTH_DIGEST'])) {
    header('HTTP/1.1 401 Unauthorized');
    header('WWW-Authenticate: Digest realm="'.$dominio.
           '",qop="auth",nonce="'.uniqid().'",opaque="'.md5($dominio).'"');
    die('You click on the Cancel button.');
}


// Analizar la variable PHP_AUTH_DIGEST
if (!($datos = analizar_http_digest($_SERVER['PHP_AUTH_DIGEST'])) ||
    !isset($users[$datos['username']]))
    die('Incorrect credentials');


// Generate a valid reply
$A1 = md5($datos['username'] . ':' . $dominio . ':' . $users[$datos['username']]);
$A2 = md5($_SERVER['REQUEST_METHOD'].':'.$datos['uri']);
$valid_reply = md5($A1.':'.$datos['nonce'].':'.$datos['nc'].':'.$datos['cnonce'].':'.$datos['qop'].':'.$A2);

if ($datos['response'] != $valid_reply)
{
    //die('Credenciales incorrectas');
    header('HTTP/1.1 401 Unauthorized');
    header('WWW-Authenticate: Digest realm="'.$dominio.
           '",qop="auth",nonce="'.uniqid().'",opaque="'.md5($dominio).'"');
		die('You click on the Cancel button');
}
function analizar_http_digest($txt)
{
    // Avod missing data
    $partes_necesarias = array('nonce'=>1, 'nc'=>1, 'cnonce'=>1, 'qop'=>1, 'username'=>1, 'uri'=>1, 'response'=>1);
    $datos = array();
    $claves = implode('|', array_keys($partes_necesarias));

    preg_match_all('@(' . $claves . ')=(?:([\'"])([^\2]+?)\2|([^\s,]+))@', $txt, $coincidencias, PREG_SET_ORDER);

    foreach ($coincidencias as $c) {
        $datos[$c[1]] = $c[3] ? $c[3] : $c[4];
        unset($partes_necesarias[$c[1]]);
    }
    return $partes_necesarias ? false : $datos;
}
