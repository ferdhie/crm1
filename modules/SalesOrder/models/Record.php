<?php
/*+***********************************************************************************
 * The contents of this file are subject to the vtiger CRM Public License Version 1.0
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
 *************************************************************************************/

/**
 * Inventory Record Model Class
 */
class SalesOrder_Record_Model extends Inventory_Record_Model {
    
        function getPayments() {
            global $adb;
            $result=array();
            $sql = "SELECT vtiger_paymentmdl.* FROM vtiger_paymentmdl,vtiger_crmentity WHERE vtiger_paymentmdl.paymentmdlid = vtiger_crmentity.crmid AND vtiger_paymentmdl.salesorder_id = ? AND vtiger_crmentity.deleted=0";
            $query = $adb->pquery($sql, array( $this->getId() ));
            while($row = $adb->getNextRow($query)) {
                $result[]=$row;
            }
            return $result;
        }

        function getProducts() {
            global $adb;
            $relatedProducts = parent::getProducts();
            
            $uangmuka = array();
            $sql = "SELECT * FROM cms_uangmuka WHERE salesorder_id = ? ORDER BY uangmuka_id";
            $result = $adb->pquery($sql, array( $this->getId() ));
            while($row = $adb->getNextRow($result)) {
                $uangmuka[]=array(
                    'um' => $row['um'],
                    'um_due_date' => $row['um_due_date'],
                );
            }

            $relatedProducts[1]['final_details']['uangmuka'] = $uangmuka;
            return $relatedProducts ; 
            
        }

	function getCreatePaymentUrl() {
		$paymentModuleModel = Vtiger_Module_Model::getInstance('Paymentmdl');
		return "index.php?module=".$paymentModuleModel->getName()."&view=".$paymentModuleModel->getEditViewName()."&salesorder_id=".$this->getId();
	}
        
	function getCreateInvoiceUrl() {
		$invoiceModuleModel = Vtiger_Module_Model::getInstance('Invoice');
		return "index.php?module=".$invoiceModuleModel->getName()."&view=".$invoiceModuleModel->getEditViewName()."&salesorder_id=".$this->getId();
	}

}