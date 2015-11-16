<?php

/* 
 * Copyright (c) Herdian Ferdianto <herdian-at-ferdianto.com>
 * 
 * Everyone is permitted to copy and distribute verbatim or modified 
 * copies of this license document, and changing it is allowed as long 
 * as the name is changed. 
 * 
 */

class Paymentmdl_Detail_View extends Vtiger_Detail_View {
	function __construct() {
		parent::__construct();
		$this->exposeMethod('showDetailForPDF');
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
            $paymentNo = $recordModel->get('paymentmdlno');
            
            ob_start();
            $viewer = $this->getViewer($request);
            $viewer->assign("TITLE", ($subject ? $subject : "Payment ") . "#$paymentNo");
            $viewer->assign("CONTENT", "$detail");
            $viewer->view('HeaderPrint.tpl', 'Paymentmdl');
            $content = ob_get_contents();
            ob_end_clean();
            
            $tmpDir = "/tmp";
            $tmpfile = tempnam("/tmp", "payment") . ".html";
            $pdfFile = $tmpDir . "/$paymentNo.pdf";
            
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
    
	function preProcess(Vtiger_Request $request) {
		$viewer = $this->getViewer($request);
		$viewer->assign('NO_SUMMARY', true);
                if ($request->get('mode') != 'showDetailForPDF' && $request->get('mode') != 'testTest')
                    parent::preProcess($request);
	}
        
        function postProcess(Vtiger_Request $request) {
            if ($request->get('mode') != 'showDetailForPDF' && $request->get('mode') != 'testTest')
                parent::postProcess($request);
        }

        function showModuleDetailView(Vtiger_Request $request) {
		echo parent::showModuleDetailView($request);
                echo $this->showLineItemDetails($request);
	}

        function showDetailViewByMode(Vtiger_Request $request) {
		return $this->showModuleDetailView($request);
	}

	function showModuleBasicView($request) {
		return $this->showModuleDetailView($request);
	}

        function showLineItemDetails(Vtiger_Request $request) {
		$record = $request->get('record');
		$moduleName = $request->getModule();

		$recordModel = Vtiger_Record_Model::getInstanceById($record, $moduleName);
                $salesOrderId = $recordModel->get('salesorder_id');
                
                $parentRecordModel = Vtiger_Record_Model::getInstanceById($salesOrderId, 'SalesOrder');
                $relatedProducts = $parentRecordModel->getProducts();
                $payments = $parentRecordModel->getPayments();
                $totalBayar=0;
                foreach($payments as $payment) {
                    $totalBayar+=$payment['paymentmdl_tks_biayauangmuka'];
                }
                $recordModel->set('paymentmdl_tks_totalbayar', $totalBayar);
                $sisaPinjaman = $relatedProducts[1]['final_details']['totalbayar'] - $totalBayar;
                
                $arrPayment=array();
                foreach($payments as $p) {
                    $termin = $p['paymentmdl_tks_termin'];
                    $termin = intval($termin);
                    if (!$termin) $termin=1;
                    $jenis_bayar = $p['paymentmdl_tks_jenispembayaran'];
                    if ($jenis_bayar == 'Pembayaran Angsuran') {
                        $termin = 1;
                        if (empty($arrPayment[$jenis_bayar][$termin]))
                            $arrPayment[$jenis_bayar][$termin]=0;
                        $arrPayment[$jenis_bayar][$termin] += $p['paymentmdl_tks_biayauangmuka'];
                    } else {
                        $arrPayment[$jenis_bayar][$termin] = $p['paymentmdl_tks_biayauangmuka'];
                    }
                }
                
                //formatting
                foreach($arrPayment as $k => $v) {
                    foreach($v as $k2 => $v2) {
                        $arrPayment[$k][$k2]=Vtiger_Currency_UIType::transformDisplayValue($v2);
                    }
                }

                //##Final details convertion started
		$finalDetails = $relatedProducts[1]['final_details'];

		//Final tax details convertion started
		$taxtype = $finalDetails['taxtype'];
		if ($taxtype == 'group') {
			$taxDetails = $finalDetails['taxes'];
			$taxCount = count($taxDetails);
			for($i=0; $i<$taxCount; $i++) {
				$taxDetails[$i]['amount'] = Vtiger_Currency_UIType::transformDisplayValue($taxDetails[$i]['amount'], null, true);
			}
			$finalDetails['taxes'] = $taxDetails;
		}
		//Final tax details convertion ended

		$currencyFieldsList = array('adjustment', 'grandTotal', 'hdnSubTotal', 'preTaxTotal', 'tax_totalamount',
                    'shtax_totalamount', 'discountTotal_final', 'discount_amount_final', 'shipping_handling_charge', 'totalAfterDiscount','nup','bookingfee','um1','um2','um3','jamsostek','pinjaman','totalbayar');
		foreach ($currencyFieldsList as $fieldName) {
			$finalDetails[$fieldName] = Vtiger_Currency_UIType::transformDisplayValue($finalDetails[$fieldName], null, true);
		}
                
                foreach( $finalDetails['uangmuka'] as $i => $uangmuka ) {
                    $finalDetails['uangmuka'][$i]['um'] = Vtiger_Currency_UIType::transformDisplayValue($uangmuka['um'], null, true);
                }

		$relatedProducts[1]['final_details'] = $finalDetails;
		//##Final details convertion ended

		//##Product details convertion started
		$productsCount = count($relatedProducts);
		for ($i=1; $i<=$productsCount; $i++) {
			$product = $relatedProducts[$i];

			//Product tax details convertion started
			if ($taxtype == 'individual') {
				$taxDetails = $product['taxes'];
				$taxCount = count($taxDetails);
				for($j=0; $j<$taxCount; $j++) {
					$taxDetails[$j]['amount'] = Vtiger_Currency_UIType::transformDisplayValue($taxDetails[$j]['amount'], null, true);
				}
				$product['taxes'] = $taxDetails;
			}
			//Product tax details convertion ended

			$currencyFieldsList = array('taxTotal', 'netPrice', 'listPrice', 'unitPrice', 'productTotal',
										'discountTotal', 'discount_amount', 'totalAfterDiscount');
			foreach ($currencyFieldsList as $fieldName) {
				$product[$fieldName.$i] = Vtiger_Currency_UIType::transformDisplayValue($product[$fieldName.$i], null, true);
			}

			$relatedProducts[$i] = $product;
		}
		//##Product details convertion ended

		$viewer = $this->getViewer($request);
		$viewer->assign('RELATED_PRODUCTS', $relatedProducts);
                
		$viewer->assign('RECORD', $recordModel);
		$viewer->assign('MODULE_NAME',$moduleName);
		$viewer->assign('TERBAYAR', Vtiger_Currency_UIType::transformDisplayValue($totalBayar));
		$viewer->assign('SISA_PINJAMAN', Vtiger_Currency_UIType::transformDisplayValue($sisaPinjaman));
                $viewer->assign("PAYMENTS", $arrPayment);
                
		$viewer->assign('SO_RECORD', $parentRecordModel);

		$viewer->view('LineItemsDetail.tpl', $moduleName);
	}
        
	function getHeaderScripts(Vtiger_Request $request) {
		$headerScriptInstances = parent::getHeaderScripts($request);
		return $headerScriptInstances;
	}
}