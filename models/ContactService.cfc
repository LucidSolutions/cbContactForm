component extends="modules.contentbox.modules.contentbox-deps.modules.cborm.models.VirtualEntityService" singleton{


	public ContactService function init(){
		// init super class
		super.init(entityName="ContactForm");
		return this;
	}

	function search(
		string searchTerm="",
		numeric max=0,
		numeric offset=0,
		boolean asQuery=false,
		string sortOrder="firstname",
		string permissionGroups,
		string twoFactorAuth
	){
		var results = {};
		var c = newCriteria();
		// Search
		if( len( arguments.searchTerm ) ){
			c.$or(
				c.restrictions.like( "firstname","%#arguments.searchTerm#%" ),
				c.restrictions.like( "contactEmail", "%#arguments.searchTerm#%" ),
				c.restrictions.like( "contactPhone", "%#arguments.searchTerm#%" )
			);
		}
		// isDeleted filter
		if( structKeyExists( arguments, "isDeleted" ) AND arguments.isDeleted NEQ "any" ){
			c.eq( "isDeleted", javaCast( "boolean", arguments.isDeleted ) );
		}
		// contactStatus filter
		if( structKeyExists( arguments, "contactStatus" ) AND arguments.contactStatus NEQ "any" ){
			c.eq( "contactStatus", javaCast( "boolean", arguments.contactStatus ) );
		}
		// contactSubject filter
		if( structKeyExists( arguments, "contactSubject" ) AND arguments.contactSubject NEQ "any" ){
			c.eq( "contactSubject", arguments.contactSubject );
		}
		results.count 	= c.count( "contactID" );
		results.contacts = c.resultTransformer( c.DISTINCT_ROOT_ENTITY )
			.list(
				offset    	= arguments.offset,
				max       	= arguments.max,
				sortOrder 	= arguments.sortOrder,
				asQuery   	= arguments.asQuery
			);
		return results;
	}

	function subjectList(){
		var c = newCriteria();				
		var filterSubList = c.withProjections( distinct="contactSubject" ).list();
		return filterSubList;
	}
}	