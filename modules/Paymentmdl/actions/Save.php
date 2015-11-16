<?php

/* 
 * Copyright (c) Herdian Ferdianto <herdian-at-ferdianto.com>
 * 
 * Everyone is permitted to copy and distribute verbatim or modified 
 * copies of this license document, and changing it is allowed as long 
 * as the name is changed. 
 * 
 */

class Paymentmdl_Save_Action extends Vtiger_Save_Action {
    
    
    public function saveRecord($request) {
        $salesorder_id = $request->get('salesorder_id');
        $recordId = $request->get('record');
        $termin = $request->get('paymentmdl_tks_termin');
        $jenis_bayar = $request->get('paymentmdl_tks_jenispembayaran');
        $recordId = intval($recordId);
        $jumlah_bayar = $request->get('paymentmdl_tks_biayauangmuka');
        
        $where_id = $recordId ?" AND vtiger_paymentmdl.paymentmdlid <> {$recordId}" : "";
        $where_termin = $jenis_bayar == "Pembayaran Uang Muka" || $jenis_bayar == "Pembayaran Angsuran" ? " AND vtiger_paymentmdl.paymentmdl_tks_termin	= '$termin'" : "";

        if ($salesorder_id && $jenis_bayar) {
            global $adb;
            $result=array();
            $sql = "SELECT vtiger_paymentmdl.* FROM "
                    . "vtiger_paymentmdl,vtiger_crmentity "
                    . "WHERE vtiger_paymentmdl.paymentmdlid = vtiger_crmentity.crmid "
                        . "AND vtiger_paymentmdl.salesorder_id = ? AND vtiger_crmentity.deleted=0 "
                        . "AND vtiger_paymentmdl.paymentmdl_tks_jenispembayaran	= ? "
                        . "$where_termin "
                        . "$where_id";
            
            $query = $adb->pquery($sql, array( $salesorder_id, $jenis_bayar, $termin ));
            $rows=array();
            while($row = $adb->getNextRow($query)) {
                $rows[]=$row;
            }
            
            if (!empty($rows)) {
                die("Pembayaran utk jenis pembayaran {$jenis_bayar} termin ke {$termin} sudah ada");
            }
            
        } else {
            die("Invalid request");
        }
        
        parent::saveRecord($request);
        
        
    }
    
    
}