<?php

/* 
 * Copyright (c) Herdian Ferdianto <herdian-at-ferdianto.com>
 * 
 * Everyone is permitted to copy and distribute verbatim or modified 
 * copies of this license document, and changing it is allowed as long 
 * as the name is changed. 
 * 
 */

class SalesOrder_DetailInfo_Action extends Vtiger_Action_Controller {
    
    
    function checkPermission(Vtiger_Request $request) {
        $moduleName = $request->getModule();
        $recordId = $request->get('record');

        $recordPermission = Users_Privileges_Model::isPermitted($moduleName, 'DetailView', $recordId);
        if(!$recordPermission) {
                throw new AppException('LBL_PERMISSION_DENIED');
        }
        return true;
    }
    
    public function process(Vtiger_Request $request) {
        $recordId = $request->get('record');
        $recordModel = Inventory_Record_Model::getInstanceById($recordId);
        $recordStructure = Vtiger_RecordStructure_Model::getInstanceFromRecordModel($recordModel, Vtiger_RecordStructure_Model::RECORD_STRUCTURE_MODE_DETAIL);
        $structuredValues = $recordStructure->getStructure();
        $relatedProducts = $recordModel->getProducts();
        $moduleModel = $recordModel->getModule();

        $result=array(
            //'blocks' => $moduleModel->getBlocks(),
            'values' => $structuredValues,
            'products' => $relatedProducts,
        );
        
        $response = new Vtiger_Response();
        $response->setResult($result);
        $response->emit();
        
    }

}