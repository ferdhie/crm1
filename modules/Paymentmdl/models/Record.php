<?php

/* 
 * Copyright (c) Herdian Ferdianto <herdian-at-ferdianto.com>
 * 
 * Everyone is permitted to copy and distribute verbatim or modified 
 * copies of this license document, and changing it is allowed as long 
 * as the name is changed. 
 * 
 */

class Paymentmdl_Record_Model extends Vtiger_Record_Model {
    
	public function getPDF() {
		$recordId = $this->getId();
		$moduleName = $this->getModuleName();
                
		$controller = new Vtiger_InventoryPDFController($moduleName);
		$controller->loadRecord($recordId);

                $fileName = $this->get('paymentmdlno');
		$controller->Output($fileName.'.pdf', 'D');
	}
    
	public function getExportPDFUrl() {
		return "index.php?module=".$this->getModuleName()."&view=Detail&mode=showDetailForPDF&record=".$this->getId();
	}
        
        public function getNewPaymentURL() {
		return "index.php?module=".$this->getModuleName()."&view=Edit&salesorder_id=".$this->get('salesorder_id');
        }
        
        public function getSalesOrderDetailUrl() {
                return "index.php?module=SalesOrder&view=Detail&record=".$this->get('salesorder_id');
        }
}