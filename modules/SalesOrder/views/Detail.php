<?php
/*+***********************************************************************************
 * The contents of this file are subject to the vtiger CRM Public License Version 1.0
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
 *************************************************************************************/

class SalesOrder_Detail_View extends Inventory_Detail_View {
    
	function __construct() {
		parent::__construct();
		$this->exposeMethod('showDetailForPDF');
	}
        
	function preProcess(Vtiger_Request $request) {
                if ($request->get('mode') != 'showDetailForPDF' && $request->get('mode') != 'testTest')
                    parent::preProcess($request);
	}
        
        function postProcess(Vtiger_Request $request) {
            if ($request->get('mode') != 'showDetailForPDF' && $request->get('mode') != 'testTest')
                parent::postProcess($request);
        }

        function showDetailForPDF(Vtiger_Request $request) {
            ob_start();
            $this->showModuleDetailView($request);
            $detail = ob_get_contents();
            ob_end_clean();
            
            $record = $request->get('record');
            $moduleName = $request->getModule();
            $recordModel = Vtiger_Record_Model::getInstanceById($record, $moduleName);
            $subject = $recordModel->get('subject');
            
            ob_start();
            $viewer = $this->getViewer($request);
            $viewer->assign("TITLE", ($subject ? $subject : "Sales Order ") . "#$record");
            $viewer->assign("CONTENT", "$detail");
            $viewer->view('HeaderPrint.tpl', 'SalesOrder');
            $content = ob_get_contents();

            ob_end_clean();
            
            $tmpDir = "/tmp";
            $tmpfile = tempnam("/tmp", "salesorder") . ".html";
            $pdfFile = $tmpDir . "/salesorder-$record.pdf";
            
            $tmpfile = str_replace("\\","/", $tmpfile);
            
            file_put_contents($tmpfile, $content);
            if ( is_file($tmpfile) )
            {
                if ( stristr(PHP_OS, 'WIN') !== false )
                {
                    $cmd = "\"C:\\Program Files\\wkhtmltopdf\\bin\\wkhtmltopdf.exe\" --disable-javascript -q \"$tmpfile\" \"$pdfFile\"";
                }
                else
                {
                    $cmd = "/usr/local/bin/wkhtmltopdf --disable-javascript -q \"$tmpfile\" $pdfFile";
                }
                
                exec($cmd);

                if (is_file($pdfFile))
                {
                    $fileName = basename($pdfFile);
                    header("Content-type: application/pdf");
                    header("Content-disposition: inline; filename=\"$fileName\"");
                    readfile($pdfFile);
                    unlink($pdfFile);
                    unlink($tmpfile);
                    exit;
                }
            }

            die('<center>Generate PDF Failed</center>');
            
            //$root_url = "http://$_SERVER[HTTP_HOST]". str_replace("\\", "/", dirname($_SERVER['SCRIPT_NAME']));
            //$root_url = rtrim($root_url, "/");
            //header("Location: $root_url/generate.php?file=".basename($tmpfile));
        }
    
	function showModuleDetailView(Vtiger_Request $request) {
		$recordId = $request->get('record');
		$moduleName = $request->getModule();

		if(!$this->record){
                    $this->record = Vtiger_DetailView_Model::getInstance($moduleName, $recordId);
		}
		$recordModel = $this->record->getRecord();
		$recordStrucure = Vtiger_RecordStructure_Model::getInstanceFromRecordModel($recordModel, Vtiger_RecordStructure_Model::RECORD_STRUCTURE_MODE_DETAIL);
		$structuredValues = $recordStrucure->getStructure();

                $moduleModel = $recordModel->getModule();

		$viewer = $this->getViewer($request);
		$viewer->assign('RECORD', $recordModel);
		$viewer->assign('RECORD_STRUCTURE', $structuredValues);
                $blockList = $moduleModel->getBlocks();
                if ( isset($blockList['Recurring Invoice Information']) )
                    unset($blockList['Recurring Invoice Information']);
                
                $viewer->assign('BLOCK_LIST', $blockList);
		$viewer->assign('USER_MODEL', Users_Record_Model::getCurrentUserModel());
		$viewer->assign('MODULE_NAME', $moduleName);
		$viewer->assign('IS_AJAX_ENABLED', $this->isAjaxEnabled($recordModel));
                
                $payments = $recordModel->getPayments();
                $totalBayar=0;
                foreach($payments as $payment) {
                    $totalBayar+=$payment['paymentmdl_tks_biayauangmuka'];
                }
                $this->totalBayar = $totalBayar;

		echo $viewer->view('DetailViewFullContents.tpl',$moduleName,true);
		$this->showLineItemDetails($request);
	}

}
