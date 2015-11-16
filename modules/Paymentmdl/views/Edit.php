<?php

/* 
 * Copyright (c) Herdian Ferdianto <herdian-at-ferdianto.com>
 * 
 * Everyone is permitted to copy and distribute verbatim or modified 
 * copies of this license document, and changing it is allowed as long 
 * as the name is changed. 
 * 
 */

class Paymentmdl_Edit_View extends Vtiger_Edit_View {
    
	public function process(Vtiger_Request $request) {
            //debug_trace();
                //copas dari berbagai classes, ngga ngerti isinya sama sekali
            
		$viewer = $this->getViewer ($request);
		$moduleName = $request->getModule();
		$record = $request->get('record');
                
                if(!empty($record) && $request->get('isDuplicate') == true) {
                    $recordModel = $this->record?$this->record:Vtiger_Record_Model::getInstanceById($record, $moduleName);
                    $viewer->assign('MODE', '');

                    //While Duplicating record, If the related record is deleted then we are removing related record info in record model
                    $mandatoryFieldModels = $recordModel->getModule()->getMandatoryFieldModels();
                    foreach ($mandatoryFieldModels as $fieldModel) {
                            if ($fieldModel->isReferenceField()) {
                                    $fieldName = $fieldModel->get('name');
                                    if (Vtiger_Util_Helper::checkRecordExistance($recordModel->get($fieldName))) {
                                            $recordModel->set($fieldName, '');
                                    }
                            }
                    }  
                }else if(!empty($record)) {
                    $recordModel = $this->record?$this->record:Vtiger_Record_Model::getInstanceById($record, $moduleName);
                    $viewer->assign('RECORD_ID', $record);
                    $viewer->assign('MODE', 'edit');
                } else {
                    $recordModel = Vtiger_Record_Model::getCleanInstance($moduleName);
                    $viewer->assign('MODE', '');
                }
                
                if(!$this->record){
                    $this->record = $recordModel;
                }
        
		$moduleModel = $recordModel->getModule();
		$fieldList = $moduleModel->getFields();
                
                $salesOrderId = $request->get('salesorder_id', $this->record->get('salesorder_id'));
                if ($salesOrderId) {
                        $parentRecordModel = Vtiger_Record_Model::getInstanceById($salesOrderId, 'SalesOrder');
                        
                        $payments = $parentRecordModel->getPayments();
                        $totalBayar=0;
                        foreach($payments as $payment) {
                            $totalBayar+=$payment['paymentmdl_tks_biayauangmuka'];
                        }
                        $this->record->set('paymentmdl_tks_totalbayar', $totalBayar);
                        
                        $currencyInfo = $parentRecordModel->getCurrencyInfo();
                        $taxes = $parentRecordModel->getProductTaxes();
                        $shippingTaxes = $parentRecordModel->getShippingTaxes();
                        $relatedProducts = $parentRecordModel->getProducts();
                        $currencies = Inventory_Module_Model::getAllCurrencies();
                        
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
                        
                        $viewer->assign('SALESORDER_RECORD', $parentRecordModel);
                        $viewer->assign('SALESORDER_ID', $salesOrderId);
                        $viewer->assign('CURRENCY_INFO', $currencyInfo);
                        $viewer->assign('TAXES', $taxes);
                        $viewer->assign('SHIPPING_TAXES', $shippingTaxes);
                        $viewer->assign('RELATED_PRODUCTS', $relatedProducts);
                        $viewer->assign('CURRENCIES', $currencies);
                        $viewer->assign('PAYMENTS', $arrPayment);
                        $viewer->assign('TOTAL_PAYMENTMDL', $totalBayar);
                }
                
		$requestFieldList = array_intersect_key($request->getAll(), $fieldList);
		foreach($requestFieldList as $fieldName=>$fieldValue){
			$fieldModel = $fieldList[$fieldName];
			$specialField = false;
			// We collate date and time part together in the EditView UI handling 
			// so a bit of special treatment is required if we come from QuickCreate 
			if ($moduleName == 'Calendar' && empty($record) && $fieldName == 'time_start' && !empty($fieldValue)) { 
				$specialField = true; 
				// Convert the incoming user-picked time to GMT time 
				// which will get re-translated based on user-time zone on EditForm 
				$fieldValue = DateTimeField::convertToDBTimeZone($fieldValue)->format("H:i"); 
                
			}
                        
			if($fieldModel->isEditable() || $specialField) {
				$recordModel->set($fieldName, $fieldModel->getDBInsertValue($fieldValue));
			}
		}
                
		$recordStructureInstance = Vtiger_RecordStructure_Model::getInstanceFromRecordModel($recordModel, Vtiger_RecordStructure_Model::RECORD_STRUCTURE_MODE_EDIT);
		$picklistDependencyDatasource = Vtiger_DependencyPicklist::getPicklistDependencyDatasource($moduleName);

                $viewer->assign('PICKIST_DEPENDENCY_DATASOURCE',Zend_Json::encode($picklistDependencyDatasource));
		$viewer->assign('RECORD_STRUCTURE_MODEL', $recordStructureInstance);
		$viewer->assign('RECORD_STRUCTURE', $recordStructureInstance->getStructure());
		$viewer->assign('MODULE', $moduleName);
		$viewer->assign('CURRENTDATE', date('Y-n-j'));
		$viewer->assign('USER_MODEL', Users_Record_Model::getCurrentUserModel());

		$isRelationOperation = $request->get('relationOperation');
		$viewer->assign('IS_RELATION_OPERATION', $isRelationOperation);
		if($isRelationOperation) {
			$viewer->assign('SOURCE_MODULE', $request->get('sourceModule'));
			$viewer->assign('SOURCE_RECORD', $request->get('sourceRecord'));
		}

                if ( $request->get('fromajax') && $salesOrderId ) {
                    $viewer->view('LineItemsEdit.tpl', $moduleName);
                } else {
                    $viewer->view('EditView.tpl', $moduleName);
                }
	}
    
}