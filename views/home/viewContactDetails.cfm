<cfoutput>
<div class="col-md-12">
	<div class="panel panel-default">
		<div class="panel-heading">
			<h3 class="panel-title">
				<i class="fa fa-file-text-o fa-lg"> </i> #prc.contactDetails.getfirstname()#
			</h3>
			<div class="actions">
				<p class="text-center">
					<cfif #prc.contactDetails.getisDeleted()# EQ 0>
						<a class="btn btn-sm btn-primary" href="mailto:#prc.contactDetails.getcontactEmail()#?subject=#prc.contactDetails.getcontactSubject()#&body=#prc.contactDetails.getcontactMessage()#" target="_top"><i class="fa fa-envelope-o"></i> Send Mail</a>
					</cfif>
					<button class="btn btn-sm btn-info" onclick="return to('#prc.xehContactTable#')">
						<i class="fa fa-reply"></i> Back To Listing
					</button>
				</p>
			</div>
		</div>
	    <div class="panel-body">
	    	<table name="settings" id="settings" class="table table-hover table-striped">
				<tbody>
					<tr>
						<th>
							First Name
						</th>
						<th>#prc.contactDetails.getfirstname()#</th>
					</tr>
					<tr>
						<th>Subject</th>
						<th>#prc.contactDetails.getcontactSubject()#</th>
					</tr>
					<tr>
						<th>Phone</th>
						<th>#prc.contactDetails.getcontactPhone()#</th>
					</tr>
					<tr>
						<th>Email</th>
						<th>#prc.contactDetails.getcontactEmail()#</th>
					</tr>
					<tr>
						<th>Created Date </th>
						<th> #DateTimeFormat(#prc.contactDetails.getcreatedDate()#, 'long')# </th>
					</tr>
					<tr>
						<th>Message</th>
						<th>#prc.contactDetails.getcontactMessage()# </th>
					</tr>
					<tr>
						<th>Subscribe </th>
						<th>
							<cfif prc.contactDetails.getIsSubscribe()>
								<i class="fa fa-check-circle" title="Yes" style="color:green;"></i>
							<cfelse>
								<i class="fa fa-times-circle" title="No" style="color:red;"></i>
							</cfif>
						</th>
					</tr>
				</tbody>
			</table>
	    </div>
	</div>
</div>
</cfoutput>