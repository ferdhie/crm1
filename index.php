<?php
/*+**********************************************************************************
 * The contents of this file are subject to the vtiger CRM Public License Version 1.1
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
 ************************************************************************************/

//Overrides GetRelatedList : used to get related query
//TODO : Eliminate below hacking solution
include_once 'include/Webservices/Relation.php';
include_once 'vtlib/Vtiger/Module.php';
include_once 'includes/main/WebUI.php';

//custom function buat dump
function dump($dump) {
    echo '</pre><pre>'; 
    print_r($dump);
    exit;
}

//custom function buat debug trace
function debug_trace() {
    $dirname = dirname(__FILE__);
    echo '</pre><pre>'; foreach(debug_backtrace() as $i => $trace) {
        if ($i==0) continue;
        echo "[" . trim(str_replace($dirname, '', $trace['file']), '\/') . "] (".(empty($trace['object']) ? '':get_class($trace['object'])).") $trace[class]$trace[type]$trace[function]\n";
    }
    exit;
}


$webUI = new Vtiger_WebUI();
$webUI->process(new Vtiger_Request($_REQUEST, $_REQUEST));
