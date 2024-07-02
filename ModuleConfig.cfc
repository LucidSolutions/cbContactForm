component {

	// Module Properties
	this.title 				= "Contact Form";
	this.author 			= "Lucid Outsourcing Solutions";
	this.webURL 			= "https://lucidoutsourcing.com/";
	this.description 		= "This is an awesome Contact Form module";
	this.version			= "2.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbContactForm";

	function configure(){

		// parent settings
		parentSettings = {

		};

		// module settings - stored in modules.name.settings
		settings = {
			firstNameLabel='First Name',
			firstNamePlaceholder='Please Enter Your First Name',
			phoneLabel='Phone Number',
			phonePlaceholder='Please Enter Your Phone Number',
			emailLabel='Email Address',
			emailPlaceholder='Please Enter Your Email',
			messageLabel='Message',
			messagePlaceholder='Please Enter Your Message',
			submitLabel='Send',
			formHeading='Contact Us',
			subjectLabel='Subject',
			subjectList='General Information|Request for Support|Other',
			subscribeText='',
			emailList='',
			emailSubject='',
			successMessage='Request submitted !!'
		};

		// SES Routes
		routes = [
			// Module Entry Point
			{pattern="/", handler="home",action="index"},
			// Convention Route
			{pattern="/:handler/:action?"}
		];

		// Binder Mappings
		// binder.map( "Alias" ).to( "#moduleMapping#.model.MyService" );
		binder.map("ContactService@cbContactForm").to("#moduleMapping#.models.ContactService");


	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// Let's add ourselves to the main menu in the Modules section
		var menuService = controller.getWireBox().getInstance( "AdminMenuService@contentbox" );
		// Add Menu Contribution
		menuService.addSubMenu(topMenu=menuService.MODULES,name="cbContactForm",label="Contact Form",href="#menuService.buildModuleLink('cbContactForm','home')#" );
	}

	/**
	* Fired when the module is activated by ContentBox
	*/
	function onActivate(){
		var settingService = controller.getWireBox().getInstance("SettingService@contentbox");
		// store default settings
		var findArgs = {name="cb_cbContactForm"};
		var setting = settingService.findWhere(criteria=findArgs);
		if( isNull(setting) ){
			var args = {name="cb_cbContactForm", value=serializeJSON( settings )};
			var cFormSettings = settingService.new(properties=args);
			settingService.save( cFormSettings );
		}

	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		// Let's remove ourselves to the main menu in the Modules section
		var menuService = controller.getWireBox().getInstance( "AdminMenuService@contentbox" );
		// Remove Menu Contribution
		menuService.removeSubMenu(topMenu=menuService.MODULES,name="cbContactForm" );
	}

	/**
	* Fired when the module is deactivated by ContentBox
	*/
	function onDeactivate(){
		var settingService = controller.getWireBox().getInstance("SettingService@contentbox");
		var args = {name="cb_cbContactForm"};
		var setting = settingService.findWhere(criteria=args);
		if( !isNull(setting) ){
			settingService.delete( setting );
		}

	}

}