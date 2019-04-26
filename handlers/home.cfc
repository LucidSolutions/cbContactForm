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
			if(formSuccess){
				sendMail(event,cForm);				
			}
			cbMessageBox.info(contactFormData.successMessage);
		}
		setNextEvent(url=rc._returnTo&'?cbCache=true');
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
		var mailBody='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
						<html xmlns="http://www.w3.org/1999/xhtml">
							<head>
							    <meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
							    <title></title>
							    <!--[if gte mso 6]>
							      <style>
							          table.kmButtonBarContent {width:100% !important;}
							      </style>
							    <![endif]-->
							    <style type="text/css">
							        @media only screen and (max-width: 480px) {
							            body, table, td, p, a, li, blockquote {
							                -webkit-text-size-adjust: none !important;
							            }
							            body{
							                width: 100% !important;
							                min-width: 100% !important;
							            }
							            td[id=bodyCell] {
							                padding: 10px !important;
							            }
							            table[class=kmTextContentContainer] {
							                width: 100% !important;
							            }
							            table[class=kmBoxedTextContentContainer] {
							                width: 100% !important;
							            }
							            td[class=kmImageContent] {
							                padding-left: 0 !important;
							                padding-right: 0 !important;
							            }
							            img[class=kmImage] {
							                width:100% !important;
							            }
							            table[class=kmSplitContentLeftContentContainer],
							            table[class=kmSplitContentRightContentContainer],
							            table[class=kmColumnContainer] {
							                width:100% !important;
							            }
							            table[class=kmSplitContentLeftContentContainer] td[class=kmTextContent],
							            table[class=kmSplitContentRightContentContainer] td[class=kmTextContent],
							            table[class="kmColumnContainer"] td[class=kmTextContent] {
							                padding-top:9px !important;
							            }
							            td[class="rowContainer kmFloatLeft"],
							            td[class="rowContainer kmFloatLeft firstColumn"],
							            td[class="rowContainer kmFloatLeft lastColumn"] {
							                float:left;
							                clear: both;
							                width: 100% !important;
							            }
							            table[id=templateContainer],
							            table[class=templateRow],
							            table[id=templateHeader],
							            table[id=templateBody],
							            table[id=templateFooter] {
							                max-width:600px !important;
							                width:100% !important;
							            }

							            h1 {
							                font-size:24px !important;
							                line-height:100% !important;
							            }


							            h2 {
							                font-size:20px !important;
							                line-height:100% !important;
							            }


							            h3 {
							                font-size:18px !important;
							                line-height:100% !important;
							            }


							            h4 {
							                font-size:16px !important;
							                line-height:100% !important;
							            }

							            td[class=rowContainer] td[class=kmTextContent] {
							                font-size:18px !important;
							                line-height:100% !important;
							                padding-right:18px !important;
							                padding-left:18px !important;
							            }


							            td[class=headerContainer] td[class=kmTextContent] {
							                font-size:18px !important;
							                line-height:100% !important;
							                padding-right:18px !important;
							                padding-left:18px !important;
							            }


							            td[class=bodyContainer] td[class=kmTextContent] {
							                font-size:18px !important;
							                line-height:100% !important;
							                padding-right:18px !important;
							                padding-left:18px !important;
							            }


							            td[class=footerContent] {
							                font-size:18px !important;
							                line-height:100% !important;
							            }

							            td[class=footerContent] a {
							                display:block !important;
							            }
							        }
							    </style>
							</head>
							<body style="margin: 0; padding: 0; background-color: ##EAEAEA">
								<center>
								    <table align="center" border="0" cellpadding="0" cellspacing="0" id="bodyTable" width="100%" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; padding: 0; background-color: ##EAEAEA; height: 100%; margin: 0; width: 100%">
								        <tbody>
								            <tr>
								                <td align="center" id="bodyCell" valign="top" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; padding-top: 20px; padding-left: 20px; padding-bottom: 20px; padding-right: 20px; border-top: 0; height: 100%; margin: 0; width: 100%">
								                    <table border="0" cellpadding="0" cellspacing="0" id="templateContainer" width="600" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; border: 1px solid ##CCC; background-color: ##F4F4F4; border-radius: 0">
								                        <tbody>
								                            <tr>
								                                <td align="center" valign="top" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0">
								                                    <h2 style="margin-top:20px;">Contact Details</h2>
												                    <table cellpadding="3" cellspacing="3">
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
																			<tr>
																				<td><strong>Subscribe:</strong> </td>
																				<td>#cForm.getIsSubscribe()#</td>
																			</tr>
															            </tbody>
															        </table>
								                                </td>
								                            </tr>
								                            <tr>
								                                <td align="center" valign="top" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0">
								                                    <table border="0" cellpadding="0" cellspacing="0" class="templateRow" width="100%" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0">
								                                        <tbody>
								                                            <tr>
								                                                <td class="rowContainer kmFloatLeft" valign="top" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0;padding-top:10px;">
								                                                    <!-- Footer -->
								                                                    <div style="text-align: center; border-top: 1px dotted gray; margin: 20px; padding-top: 20px">
								                                                        <img alt="contentbox" href="#event.getHTMLBaseURL()#/modules/contentbox/email_templates/images/contentbox-horizontal.png" class="kmImage" src="contentbox-horizontal.png" style="border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; max-width: 100%; padding-bottom: 0; display: inline; vertical-align: bottom" />

								                                                        <br><br>

								                                                        <cfoutput>
								                                                        <small style="color: gray">
								                                                            You are receiving this email because of your account on
								                                                            <a href="#event.getHTMLBaseURL()#">
								                                                                <em>#settings.cb_site_name#</em>
								                                                            </a>
								                                                            <br>
								                                                            If you like to receive fewer emails, you can adjust your notification settings.
								                                                        </small>
								                                                        </cfoutput>
								                                                    </div>

								                                                </td>
								                                            </tr>
								                                        </tbody>
								                                    </table>
								                                </td>
								                            </tr>
								                        </tbody>
								                    </table>
								                </td>
								            </tr>
								        </tbody>
								    </table>
								</center>
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