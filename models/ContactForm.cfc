/**
* Field entity
*/
component persistent="true" table="cb_contactform"{

	// Primary Key
	property name="contactID" fieldtype="id" column="contactID" generator="identity" setter="false";

	// Properties
	property name="firstname" notnull="true" length="200" index="idx_fname";
	property name="contactEmail" notnull="true" length="100" index="idx_cemail";
	property name="contactPhone" notnull="true" length="10" index="idx_cphone";
	property name="contactSubject" notnull="true" index="idx_csubject";
	property name="contactMessage" notnull="true" length="2000";
	property name="contactStatus" ormtype="boolean" notnull="true" default="false" index="idx_read";
	property name="createdDate" type="date" ormtype="timestamp" notnull="true" update="false" index="idx_createDate";
	property name="modifiedDate" type="date" ormtype="timestamp" notnull="true" index="idx_modifiedDate";
	property name="isDeleted" ormtype="boolean" notnull="true" default="false" index="idx_deleted";


	this.pk = "contactID";

	this.constraints ={
		"firstName" 		= { required=true, size="1..200" },
		"contactEmail" 		= { required=true, size="1..100", type="email"  },
		"contactPhone" 		= { required=true, size="1..10",type="numeric"},
		"contactMessage" 	= { required=true, size="1..2000" },
		"contactSubject"	= { required=true}
	};


	// Constructor
	function init(){

		return this;
	}

	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getFieldID() );
	}

}