<cfoutput>
<script>
$( document ).ready( function(){
	// tables references
	$contacts = $( "##contacts" );
	// datatable
    $contacts.dataTable( {
        "paging": false,
        "info": false,
        "searching": false,
        "columnDefs": [
            { 
                "orderable": false, 
                "targets": '{sorter:false}' 
            }
        ],
        "order": []
    } );
} );
</script>
</cfoutput>