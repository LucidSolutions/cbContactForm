component extends="contentbox.models.ui.BaseWidget" singleton{

	ContactForm function init(required any controller){
		// super init
		super.init( arguments.controller );

		// Widget Properties
		setName("ContactForm");
		setVersion("1.0");
		setDescription("A widget that renders a contact form.");
		setAuthor("Lucid Outsourcing Solutions");
		setAuthorURL("http://lucidsolutions.in/");
		setForgeBoxSlug("cbContactForm");
		setIcon("wpforms");
		setCategory("Content")
		return this;
	}


	any function renderIt(){
		var content = runEvent(event='cbContactForm:home.render',eventArguments=arguments);
		if( !isNull(content) ){
			return content;
		}
		return;
	}

}