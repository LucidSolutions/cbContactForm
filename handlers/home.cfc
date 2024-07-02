component {
	property name="ContactService"		inject="id:ContactService@cbContactForm";
	property name="paging"					inject="id:paging@contentbox";
	property name="settingService"		inject="id:settingService@contentbox";
   	property name="CBHelper"			inject="id:CBHelper@contentbox";
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
			,subscribeText=''
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
        var settings 	= settingService.getAllSettings( asStruct=true );
		var contactFormData = deserializeJSON(settings.cb_cbContactForm);
		populateModel( cForm );
		var vResults = contactValid(rc);
		if( arrayLen(vResults) GT 0 ){
			cbMessageBox.warn(messageArray=vResults);
		} else {
			cForm.setCreatedDate(Now());
			cForm.setModifiedDate(Now());
			if(structKeyExists(rc,"subscribe") and rc.subscribe EQ 'on'){
				cForm.setIsSubscribe(true);
			}
			var formSuccess = ContactService.save(cForm);
			if(!formSuccess.getIsDeleted() && structKeyExists(settings, 'emailList') && len(settings.emailList) > 0){
				sendMail(event, cForm);				
			}
			cbMessageBox.info(contactFormData.successMessage);
		}
		relocate(URL= rc._returnTo&'?cbCache=true');
		// setNextEvent(url=rc._returnTo&'?cbCache=true');
	}

	function contactValid(formData){
		try{
			var validationData = {
				firstName = {required=true, requiredMessage="Name is required.", maxlength=100,maxlengthMessage = "Name must be no more than 100 characters."},
				contactMessage = {required=true, requiredMessage="Message is required.", maxlength=2000,maxlengthMessage = "Message must be no more than 2000 characters."},
				contactSubject = {required=true, requiredMessage="Subject is required.", maxlength=100,maxlengthMessage = "Subject must be no more than 100 characters."},
				contactEmail = {required=true, requiredMessage="Email is required.",type='email', typeMessage="Invalid Email address format", maxlength=100,maxlengthMessage = "Email must be no more than 100 characters."},
				contactPhone = {required=true, requiredMessage="Phone is required.",type='numeric', typeMessage="Invalid Phone address format",leneq=10, leneqMessage="Phone should be 10 digits."}		
			};

			var errorArray = arrayNew(1);
			for (key in validationData) {
				if(NOT structKeyExists(arguments.formData,key) OR len(trim(arguments.formData[key])) EQ 0){
					arrayAppend(errorArray,validationData[key].requiredMessage);
				}else if(structKeyExists(arguments.formData,key) AND structKeyExists(validationData[key],'type') AND NOT isValid(validationData[key].type,arguments.formData[key])){
					arrayAppend(errorArray,validationData[key].typeMessage);
				}else if(structKeyExists(arguments.formData,key) AND structKeyExists(validationData[key],'leneq') AND len(trim(arguments.formData[key])) NEQ validationData[key].leneq){
					arrayAppend(errorArray,validationData[key].leneqMessage);
				}else if(structKeyExists(arguments.formData,key) AND structKeyExists(validationData[key],'maxlength') AND len(trim(arguments.formData[key])) GT validationData[key].maxlength){
					arrayAppend(errorArray,validationData[key].maxlengthMessage);
				}  
			}
			return errorArray;
		}catch(Any e){
			writeDump(e);abort;
		}	
	}
	function sendMail(event,cForm) {
		var cForm = arguments.cForm;
		var settings 	= settingService.getAllSettings( asStruct=true );
		var contactFormData = deserializeJSON(settings.cb_cbContactForm);
		var mailBody='<html>
						<head></head>
						<body>
					        <h2>Contact Details</h2>
					        <table>
					            <tbody>
					                <tr>
					                    <td><strong>First Name:</strong></td>
					                    <td>#cForm.getfirstname()#</td>
					                </tr>
					                <tr>
					                    <td><strong>Subject:</strong></td>
					                    <td>#cForm.getcontactSubject()#</td>
					                </tr>
					                <tr>
					                    <td><strong>Phone:</strong></td>
					                    <td>#cForm.getcontactPhone()#</td>
					                </tr>
					                <tr>
					                    <td><strong>Email:</strong></td>
					                    <td>#cForm.getcontactEmail()#</td>
					                </tr>
					                <tr>
										<td><strong>Created Date:</strong> </td>
										<td> #DateTimeFormat(#cForm.getcreatedDate()#, 'long')# </td>
									</tr>
									<tr>
										<td><strong>Message:</strong></td>
										<td>#cForm.getcontactMessage()# </td>
									</tr>
					            </tbody>
					        </table>
						</body>
					</html>';
		var mailerService = new mail(); 
		mailerService.setTo(contactFormData.emailList); 
		mailerService.setFrom(settings.cb_site_outgoingEmail); 
		mailerService.setSubject(contactFormData.emailSubject); 
		mailerService.setType("html"); 
		mailerService.setBody(mailBody); 
		mailerService.send();
		return true;
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
		event.paramValue( "subscribeText", "" );
		event.paramValue( "emailList", "" );
		event.paramValue( "successMessage", "" );
		event.paramValue( "emailSubject", "" );
		
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
			,subscribeText=''
			,emailList=''
			,successMessage=''
			,emailSubject=''
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