<?php

/* 
 * Copyright (c) Herdian Ferdianto <herdian-at-ferdianto.com>
 * 
 * Everyone is permitted to copy and distribute verbatim or modified 
 * copies of this license document, and changing it is allowed as long 
 * as the name is changed. 
 * 
 */

class Paymentmdl_DetailView_Model extends Vtiger_DetailView_Model {

	public function getDetailViewLinks($linkParams) {
		$linkModelList = parent::getDetailViewLinks($linkParams);
		$recordModel = $this->getRecord();
		$moduleName = $recordModel->getModuleName();

		if(Users_Privileges_Model::isPermitted($moduleName, 'DetailView', $recordModel->getId())) {
			$createNewPayment = array( 
                                        'linklabel' => 'Create New Payment', 
                                        'linkurl' => $recordModel->getNewPaymentURL(), 
                                        'linkicon' => '' 
                        ); 
                        $linkModelList['DETAILVIEW'][] = Vtiger_Link_Model::getInstanceFromValues($createNewPayment ); 
                        
			$detailViewLinks = array( 
                                        'linklabel' => 'Cetak', 
                                        'linkurl' => $recordModel->getExportPDFURL(), 
                                        'linkicon' => '' 
                        ); 
                        $linkModelList['DETAILVIEW'][] = Vtiger_Link_Model::getInstanceFromValues($detailViewLinks); 
                        
			$salesOrderViewLinks = array( 
                                        'linklabel' => 'View Sales Order', 
                                        'linkurl' => $recordModel->getSalesOrderDetailUrl(), 
                                        'linkicon' => '' 
                        ); 
                        $linkModelList['DETAILVIEW'][] = Vtiger_Link_Model::getInstanceFromValues($salesOrderViewLinks); 
		}
                
                return $linkModelList;
	}
    
}