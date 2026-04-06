/**
* Field entity
*/
component
	persistent="true"
	entityname="cbContactForm"
	table     ="cb_contactform"
	batchsize ="25"
	extends   ="contentbox.models.BaseEntity"
	cachename ="cbContactForm"
	cacheuse  ="read-write"
{

	// Primary Key
	property
		name     ="contactID"
		column   ="contactID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		ormtype  ="string"
		update   ="false";

	// Properties
	property name="firstname" notnull="true" length="200" index="idx_fname";
	property name="contactEmail" notnull="true" length="100" index="idx_cemail";
	property name="contactPhone" notnull="true" length="10" index="idx_cphone";
	property name="contactSubject" notnull="true" index="idx_csubject";
	property name="contactMessage" notnull="true" length="2000";
	property name="contactStatus" ormtype="boolean" notnull="true" default="false" index="idx_read";


	this.pk = "contactID";

	this.memento = {
		// Default properties to serialize
		defaultIncludes : [
			"firstName",
			"contactEmail",
			"contactPhone",
			"contactSubject",
			"contactMessage",
			"contactStatus"
		],
		defaultExcludes : [ "" ]
	};
	this.constraints ={
		"firstName" 		: { required=true, size="1..200" },
		"contactEmail" 		: { required=true, size="1..100", type="email"  },
		"contactPhone" 		: { required=true, size="1..10",type="numeric"},
		"contactMessage" 	: { required=true, size="1..2000" },
		"contactSubject"	: { required=true}
	};


	// Constructor
	function init(){

		super.init();
		return this;
	}


}