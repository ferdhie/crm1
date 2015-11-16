<?php
/***********************************************************************************************
** The contents of this file are subject to the Vtiger Module-Builder License Version 1.3
 * ( "License" ); You may not use this file except in compliance with the License
 * The Original Code is:  Technokrafts Labs Pvt Ltd
 * The Initial Developer of the Original Code is Technokrafts Labs Pvt Ltd.
 * Portions created by Technokrafts Labs Pvt Ltd are Copyright ( C ) Technokrafts Labs Pvt Ltd.
 * All Rights Reserved.
**
*************************************************************************************************/

class ModuleBuilder_Uninstall_View extends Vtiger_Index_View {

	function checkPermission(Vtiger_Request $request) {
		$currentUserModel = Users_Record_Model::getCurrentUserModel();
		if(!$currentUserModel->isAdminUser()) {
			throw new AppException(vtranslate('LBL_PERMISSION_DENIED', 'Vtiger'));
		}
	}

	/**
	 * Function to pre process module ui diplay event for instializing default parameters
	 */
	public function preProcess(Vtiger_Request $request, $display = true) {
		global $log;
		$log->debug("Entering preProcess(request array()) method....");

		$currentUser = Users_Record_Model::getCurrentUserModel();
		$viewer = $this->getViewer($request);
		parent::preProcess($request, false);
		$viewer->assign('MODULE_NAME', $request->getModule());
		$viewer->assign('PARENT_MODULE', $request->get('parent'));
		$viewer->assign('PAGETITLE', $this->getPageTitle($request));
		$viewer->assign('SCRIPTS',$this->getHeaderScripts($request));
		$viewer->assign('STYLES',$this->getHeaderCss($request));
		$viewer->assign('SKIN_PATH', Vtiger_Theme::getCurrentUserThemePath());
		$viewer->assign('CURRENT_USER_MODEL', Users_Record_Model::getCurrentUserModel());
		$viewer->assign('LANGUAGE_STRINGS', Vtiger_Language_Handler::export($request->getModule(), 'jsLanguageStrings'));
		$viewer->assign('LANGUAGE', $currentUser->get('language'));

		$log->debug("Exiting preProcess(request array()) method....");
		if($display) {
			$this->preProcessDisplay($request);
		}
	}
	
	/**
	 * Function to get preprcess TPL name
	 */
	protected function preProcessTplName(Vtiger_Request $request) {
		global $log;
		$log->debug("Entering preProcessTplName(request array()) method....");
		$log->debug("Exiting preProcessTplName(request array()) method....");
		return 'UninstallPreProcess.tpl';
	}

	public function postProcess(Vtiger_Request $request) {
		$moduleName = $request->getModule();
		$viewer = $this->getViewer($request);
		$viewer->view('UninstallPostProcess.tpl', $moduleName);

		parent::postProcess($request);
	}

	/**
	 * Function to get process UI dispaly and Paramets for display the UI
	 */
	public function process(Vtiger_Request $request) {
		global $log;
		$log->debug("Entering process(request array()) method....");
		$module = $request->getModule();
		$viewer = $this->getViewer($request);
		$MBModuleModel = Vtiger_Module_Model::getInstance($module);	
		$viewer->assign('USER_MODEL', Users_Record_Model::getCurrentUserModel());
		$log->debug("Exiting process(request array()) method....");
		$viewer->view('Uninstall.tpl', $module );
	}
}