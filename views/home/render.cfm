<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1"><i class="fa fa-address-book-o fa-lg"></i> #prc.csettings.FORMHEADING#</h1>
        #getInstance("messageBox@cbMessageBox").renderit()#
    </div>
</div>
<form id="contact-form" method="post" action="#event.buildLink(linkTo='#prc.xehformsubmit#')#" role="form">
    <input type="hidden" name="_returnTo" value="#cb.linkSelf()#">
    <div class="controls">
        <div class="row">
            <div class="col-md-6">
                <div class="form-group">
                    <label for="form_name">#prc.csettings.FIRSTNAMELABEL# *</label>
                    <input id="firstName" type="text" name="firstName" class="form-control" placeholder="#prc.csettings.FIRSTNAMEPLACEHOLDER# *" required="required" data-error="Firstname is required.">
                    <div class="help-block with-errors"></div>
                </div>
            </div>
            <div class="col-md-6">                
                <div class="form-group">
                    <label for="contactSubject">#prc.csettings.SUBJECTLABEL# *</label>
                    <cfset arr = listToArray (#prc.csettings.SUBJECTLIST#, "|") />
                    <select class="form-control" id="contactSubject" name="contactSubject" required="required">
                        <cfloop from="1" to="#Arraylen(arr)#" index="idx" >
                            <option value="#trim(arr[idx])#">#trim(arr[idx])#</option>
                        </cfloop>
                    </select>
                    <div class="help-block with-errors"></div>
                </div>
            </div>
        </div>
        <div class="row"> 
            <div class="col-md-6">
                <div class="form-group">
                    <label for="contactEmail">#prc.csettings.EMAILLABEL# *</label>
                    <input id="contactEmail" type="email" name="contactEmail" class="form-control" placeholder="#prc.csettings.EMAILPLACEHOLDER# *" required="required" data-error="Valid email is required.">
                    <div class="help-block with-errors"></div>
                </div>
            </div> 
            <div class="col-md-6">                
                <div class="form-group">
                    <label for="contactPhone">#prc.csettings.PHONELABEL# *</label>
                    <input id="contactPhone" type="tel" required="required" name="contactPhone" class="form-control" placeholder="#prc.csettings.PHONEPLACEHOLDER# *">
                    <div class="help-block with-errors"></div>
                </div>
            </div>         
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="form-group">
                    <label for="contactMessage">#prc.csettings.MESSAGELABEL# *</label>
                    <textarea id="contactMessage" name="contactMessage" class="form-control" placeholder="#prc.csettings.MESSAGEPLACEHOLDER# *" required="required" rows="4" data-error="Please,leave us a message."></textarea>
                    <div class="help-block with-errors"></div>
                </div>
            </div>
            <div class="col-md-12">
                <input type="submit" class="btn btn-success btn-send" value="#prc.csettings.SUBMITLABEL#">
            </div>
        </div>
    </div>
</form>
</cfoutput>