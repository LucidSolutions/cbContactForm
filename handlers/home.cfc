component {
	property name="ContactService"		inject="id:ContactService@cbContactForm";
	property name="paging"					inject="id:paging@cb";
	property name="settingService"		inject="id:settingService@cb";
   	property name="CBHelper"			inject="id:CBHelper@cb";
   	property name="cbMessagebox" 	inject="messagebox@cbmessagebox";

	function index(event,rc,prc){
		prc.xehContactTable	= CBHelper.buildModuleLink("cbContactForm","home.indexTable");
		prc.xehContactRemove = CBHelper.buildModuleLink("cbContactForm","home.remove");
		prc.xehContactsearch = CBHelper.buildModuleLink("cbContactForm","home");
		prc.xehContactForm = CBHelper.buildModuleLink("cbContactForm","home.contactFormSettings");
		var mylist = ContactService.subjectList();

		var args 	= { name="cb_cbContactForm" };
		var allsettings = settingService.findWhere( criteria=args );

		if(!isNull(allsettings)){
			var pairs = deserializeJSON(allsettings.getValue());
			if(structKeyExists(pairs,"subjectList") AND listlen(pairs.subjectList,"|") GT 0){
					mylist.addAll(listToArray(pairs.subjectList,"|"));
			}
		}
		prc.subjectList = listToArray(listRemoveDuplicates(arrayToList(mylist)));
		event.setView(view= "home/index" ,module="cbContactForm");
	}

	function render(event,rc,prc){
		prc.xehformsubmit = "cbContactForm.home.submitContactForm";
		prc.csettings = {
			firstNameLabel=''
			,firstNamePlaceholder=''
			,phoneLabel=''
			,phonePlaceholder=''
			,emailLabel=''
			,emailPlaceholder=''
			,messageLabel=''
			,messagePlaceholder=''
			,submitLabel=''
			,formHeading=''
			,subjectLabel=''
			,subjectList=''
			};
		
		var args 	= { name="cb_cbContactForm" };
		var allsettings = settingService.findWhere( criteria=args );

		if(!isNull(allsettings)){
			var pairs=deserializeJSON(allsettings.getValue());
			for( var key in pairs ){
				prc.csettings[key]=pairs[key];
			}
		}
		return renderview(view="home/render", module="cbContactForm");
	}

	function indexTable( event, rc, prc ){
		prc.xehContactView = CBHelper.buildModuleLink("cbContactForm","home.viewContact");
		// paging
		event.paramValue( "page", 1 )
			.paramValue( "showAll", false )
			.paramValue( "searchAuthors", "" )
			.paramValue( "isFiltering", false, true )
			.paramValue( "dStatus", "false" )
			.paramValue( "rStatus", "any" )
			.paramValue( "sStatus", "any" )
			.paramValue( "sortOrder", "firstname" );
		 	
		// prepare paging object
		 prc.oPaging 	= variables.paging;
		 prc.paging 		= prc.oPaging.getBoundaries();
		 prc.pagingLink 	= 'javascript:contentPaginate( @page@ )';

		// is Filtering?
		if( rc.dStatus neq "false" 
			OR rc.rStatus neq "any"
			OR rc.sStatus neq "any"
			OR rc.showAll 
		){
			prc.isFiltering = true;
		}

		// Determine Sort Order internally to avoid XSS
		var sortOrder = "firstname";

		// Get all contact or search
		 var maxrow = settingService.getSetting( "cb_paging_maxrows",0);
		 var results = ContactService.search(
			searchTerm 			= rc.searchAuthors,
			offset    			= ( rc.showAll ? 0 : prc.paging.startRow-1 ),
			max       			= ( rc.showAll ? 0 : maxrow ),
			sortOrder 			= sortOrder,
			isDeleted  			= rc.dStatus,
			contactStatus   	= rc.rStatus,
			contactSubject   	= rc.sStatus
		);
		prc.contacts 		= results.contacts;
		prc.contactCount 	= results.count;

		// View
		event.setView( view="home/indexTable", layout="ajax" ,module="cbContactForm");
	}

	function submitContactForm(event,rc,prc) {
		var cForm = ContactService.new();
		populateModel( cForm );
		var vResults = validateModel( target=cForm);
		if( vResults.hasErrors() ){
			cbMessageBox.warn(messageArray=vResults.getAllErrors());
		} else {
			cForm.setCreatedDate(Now());
			cForm.setModifiedDate(Now());
			ContactService.save(cForm);
			cbMessageBox.info("Your request has been sent to Administrator");
		}
		setNextEvent(url=rc._returnTo);
	}

	function viewContact(event,rc,prc) {
		prc.xehContactTable	= CBHelper.buildModuleLink("cbContactForm","home.index");
		var contact_id  = event.getValue('contactID',0);
		prc.contactDetails	= ContactService.get( contact_id );
		prc.contactDetails.setModifiedDate(Now());
		prc.contactDetails.setcontactStatus(1);
		ContactService.save(prc.contactDetails);
		event.setView( view="home/viewContactDetails",module="cbContactForm");
	}

	function contactFormSettings(event,rc,prc) {
		prc.xehContactSetting	= CBHelper.buildModuleLink("cbContactForm","home.saveSettings");

		event.paramValue( "firstNameLabel", "" );
		event.paramValue( "firstNamePlaceholder", "" );
		event.paramValue( "phoneLabel", "" );
		event.paramValue( "phonePlaceholder", "" );
		event.paramValue( "emailLabel", "" );
		event.paramValue( "emailPlaceholder", "" );
		event.paramValue( "messageLabel", "" );
		event.paramValue( "messagePlaceholder", "" );
		event.paramValue( "submitLabel", "" );
		event.paramValue( "formHeading", "" );
		event.paramValue( "subjectLabel", "" );
		event.paramValue( "subjectList", "" );
		
		var args 	= { name="cb_cbContactForm" };
		var allsettings = settingService.findWhere( criteria=args );

		if(!isNull(allsettings)){
			var pairs=deserializeJSON(allsettings.getValue());
			for( var key in pairs ){
				event.setValue(key,pairs[key] );
			}
		}
		event.setView( view="home/contactSettings",module="cbContactForm");
	}

	function saveSettings( event, rc, prc ){
		// Get settings
		var csettings = {
			firstNameLabel=''
			,firstNamePlaceholder=''
			,phoneLabel=''
			,phonePlaceholder=''
			,emailLabel=''
			,emailPlaceholder=''
			,messageLabel=''
			,messagePlaceholder=''
			,submitLabel=''
			,formHeading=''
			,subjectLabel=''
			,subjectList=''
			};
		// iterate over settings
		for( var key in csettings ){
			// save only sent in setting keys
			if( structKeyExists( rc, key ) ){
				csettings[ key ] = rc[ key ];
			}
		}
		// Save settings
		var args 	= { name="cb_cbContactForm" };
		var setting = settingService.findWhere( criteria=args );
		if( isNull( setting ) ){
			setting = settingService.new( properties=args );
		}
		
		setting.setValue( serializeJSON( csettings ) );
		settingService.save( setting );
		settingService.flushSettingsCache();
		// Messagebox
		cbMessageBox.info("Settings Saved & Updated!");
		// Relocate via CB Helper
		CBHelper.setNextModuleEvent( "cbContactForm", "home.contactFormSettings" );
	}

	
	function remove( event, rc, prc ){
		event.paramValue( "targetContactID", 0 );
		var contactDelete	= ContactService.get( rc.targetContactID );
		if( isNull( contactDelete ) ){
			cbMessageBox.warn("Invalid contact request!");
		}else{
			contactDelete.setisDeleted(1);
			ContactService.save( contactDelete );
			cbMessageBox.info("Contact info removed!");
		}
		CBHelper.setNextModuleEvent("cbContactForm","home.index");
	}

}