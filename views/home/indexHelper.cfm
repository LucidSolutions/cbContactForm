﻿<cfoutput>
<script>
$( document ).ready( function(){
	// Setup view
	setupView( { 
		tableContainer	: $( "##contactTableContainer" ), 
		tableURL		: '#prc.xehContactTable#',
		searchField 	: $( "##userSearch" ),
		searchName		: 'searchAuthors',
		contentForm 	: $( "##contactform" ),
		filters 		: [
			{ name : "dStatus",     defaultValue : "false" },
			{ name : "rStatus", 	defaultValue : "any" },
			{ name : "sStatus", 	defaultValue : "any" }
		],
		sortOrder 		: $( "##sortOrder" )
	} );

	// load content on startup
	contentLoad( {} );
} );
// Setup the view with the settings object
function setupView( settings ){
	// setup model properties
	$tableContainer = settings.tableContainer;
	$tableURL		= settings.tableURL;
	$searchField 	= settings.searchField;
	$searchName		= settings.searchName;
	$contentForm	= settings.contentForm;
	$filterBox		= settings.filterBox;
	$sortOrder 		= settings.sortOrder;

	// setup filters
	$filters 		= settings.filters;
	
	// quick search binding
	$searchField.keyup( 
		_.debounce(
			function(){
				var $this = $( this );
				var clearIt = ( $this.val().length > 0 ? false : true );
				// ajax search
				contentLoad( { search : $this.val() } );
			},
			300
		)
	);
}
// show all content
function contentShowAll(){
	resetFilter();
	contentLoad ( { showAll: true } );
}
// Content filters
function contentFilter(){
	// discover if we are filtering
	var filterArgs 	= {};
	var isFiltering = false;
	// check for active filters
	for( var thisFilter in $filters ){
		var thisValue = $( "##" + $filters[ thisFilter ].name ).val();
		if( thisValue != $filters[ thisFilter ].defaultValue ){
			isFiltering = true;
			break;
		}
	}
	contentLoad( {} );
}
// reset filters
function resetFilter( reload ){
	// reset filters to default values
	for( var thisFilter in $filters ){
		$( "##" + $filters[ thisFilter ].name ).val( $filters[ thisFilter ].defaultValue );
	}
	// reload check
	if( reload ){ contentLoad( {} ); }
}
// content paginate
function contentPaginate(page){
	// paginate with kept searches and filters.
	contentLoad( {
		search: $searchField.val(),
		page: page
	} );
}
// Content load
function contentLoad( criteria ){
	// default checks
	if( criteria == undefined ){ criteria = {}; }
	
	// default criteria matches
	if( !( "search" in criteria ) ){ criteria.search = ""; }
	if( !( "page" in criteria ) ){ criteria.page = 1; }
	if( !( "showAll" in criteria ) ){ criteria.showAll = false; }
	// loading effect
	$tableContainer.css( 'opacity', .60 );
	// setup ajax arguments
	var args = {  
		page 	: criteria.page, 
		showAll : criteria.showAll
	};
	// do we have filters, if so apply them to arguments
	for( var thisFilter in $filters ){
		args[ $filters[ thisFilter ].name ] = $( "##" + $filters[ thisFilter ].name ).val();
	}
	// Add dynamic search key name
	args[ $searchName ] = criteria.search;
	// Add sort order
	args[ 'sortOrder' ] = $sortOrder.val();
	// load content
	$tableContainer.load( 
		$tableURL, 
		args, 
		function(){
			$tableContainer.css( 'opacity', 1 );
			$( this ).fadeIn( 'fast' );
		}
	);
}
//Remove Contact
function removeContact( contactID ){
	$( "##delete_"+ contactID ).removeClass( "fa fa-trash-o" ).addClass( "fa fa-spinner fa-spin" );
	var r = confirm('Are you sure? you want delete');
	if(r==true){
		$( "##targetContactID" ).val( contactID );
		$( "##contactform" ).submit();
	}else{
		$( "##delete_"+ contactID ).removeClass( "fa fa-spinner fa-spin" ).addClass( "fa fa-trash-o" );
	}
	return r;
}
</script>
</cfoutput>