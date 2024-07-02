<cfoutput>
<table name="contacts" id="contacts" class="table table-striped table-hover table-condensed" width="100%">
	<thead>
		<tr>
			<th>First Name</th>
			<th>Email</th>
			<th>Subject</th>
			<th>Phone Number</th>
			<th>Created Date</th>
			<!--- <th>Subscribe</th> --->
			<th class="{sorter:false} ">Action</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.contacts#" index="cont">
		<tr
		<cfif #cont.getisDeleted()# EQ 1>
			class="danger"
		<cfelseif #cont.getisDeleted()# EQ 1 AND #cont.getcontactStatus()# EQ 0>
			class="danger"
		</cfif>
		<cfif #cont.getcontactStatus()# EQ 0>
				style="font-weight:bold;" class="warning"
		</cfif> >
			<td>	
				<a title="View Contact Details" href="#prc.xehContactView#/contactID/#cont.getContactID()#">#cont.getfirstname()#</a>
				
			</td>
			
			<td>
				#cont.getcontactEmail()#
			</td>

			<td>
				#cont.getcontactSubject()#
			</td>

			<td>
				#cont.getcontactPhone()#
			</td>

			<td>
				
				#DateTimeFormat(#cont.getcreatedDate()#, 'medium')# 
			</td>
			<!--- <td style="text-align:center;">
				<p style="display:none;">#cont.getIsSubscribe()#</p>
				<cfif cont.getIsSubscribe()>
					<i class="fa fa-check-circle" title="Yes" style="color:green;"></i>
				<cfelse>
					<i class="fa fa-times-circle" title="No" style="color:red;"></i>
				</cfif>
			</td> --->
			<td class="btn-group btn-group-sm">
				<a title="View Contact" href="#prc.xehContactView#/contactID/#cont.getContactID()#" class="btn btn-sm btn-info" data-title="<i class='fa fa-eye'></i> View Contact">
					<i id="view_#cont.getContactID()#" class="fa fa-eye fa-lg"></i> 
				</a>
				<cfif #cont.getisDeleted()# EQ 0>
					<a title="Delete Contact" onclick="return removeContact( '#cont.getContactID()#' );" class="btn btn-sm btn-danger" data-title="<i class='fa fa-trash-o'></i> Delete Contact?">
						<i id="delete_#cont.getContactID()#" class="fa fa-trash-o fa-lg"></i> 
					</a>
				</cfif>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>
<!--- Paging --->
<cfif !rc.showAll>
	#prc.oPaging.renderit(foundRows=prc.contactCount, link=prc.pagingLink, asList=true)#
<cfelse>
	<span class="label label-info">Total Records: #prc.contactCount#</span>
</cfif>

</cfoutput>