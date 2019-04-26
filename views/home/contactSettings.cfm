<cfoutput>
<form id="contact-form" method="post" action="#prc.xehContactSetting#" role="form">
    <input type="hidden" name="_returnTo" value="#cb.linkSelf()#">
    #getModel( "messagebox@cbMessagebox" ).renderit()#
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3><i class="fa fa-address-book-o fa-lg"></i> Contact Form Settings</h3>
        </div>
        <div class="panel-body">
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="formHeading">Contact Form Heading</label>
                        <input id="formHeading" type="text" name="formHeading" class="form-control" placeholder="Contact Form Heading" value="#event.getValue('formHeading')#">
                    </div>
                </div>
                <div class="col-md-6">                
                    <div class="form-group">
                        <label for="submitLabel">Button Label</label>
                        <input id="submitLabel" type="text" name="submitLabel" class="form-control" placeholder="Button Label" value="#event.getValue('submitLabel')#">
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="firstNameLabel">Firstname Label</label>
                        <input id="firstNameLabel" type="text" name="firstNameLabel" class="form-control" placeholder="Firstname Label" value="#event.getValue('firstNameLabel')#">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="firstNamePlaceholder">Firstname Placeholder</label>
                        <input id="firstNamePlaceholder" type="text" name="firstNamePlaceholder" class="form-control" placeholder="Firstname Placeholder" value="#event.getValue('firstNamePlaceholder')#">
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="phoneLabel">Phone Label</label>
                        <input id="phoneLabel" type="text" name="phoneLabel" class="form-control" placeholder="Phone Label" value="#event.getValue('phoneLabel')#">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="phonePlaceholder">Phone Placeholder</label>
                        <input id="phonePlaceholder" type="text" name="phonePlaceholder" class="form-control" placeholder="Phone Placeholder" value="#event.getValue('phonePlaceholder')#">
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="emailLabel">Email Label</label>
                        <input id="emailLabel" type="text" name="emailLabel" class="form-control" placeholder="Email Label" value="#event.getValue('emailLabel')#">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="emailPlaceholder">Email Placeholder</label>
                        <input id="emailPlaceholder" type="text" name="emailPlaceholder" class="form-control" placeholder="Email Placeholder" value="#event.getValue('emailPlaceholder')#">
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="messageLabel">Message Label</label>
                        <input id="messageLabel" type="text" name="messageLabel" class="form-control" placeholder="Message Label" value="#event.getValue('messageLabel')#">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="messagePlaceholder">Message Placeholder</label>
                        <input id="messagePlaceholder" type="text" name="messagePlaceholder" class="form-control" placeholder="Message Placeholder" value="#event.getValue('messagePlaceholder')#">
                    </div>
                </div>
            </div>
            <div class="row">            
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="subjectLabel">Subject Label</label>
                        <input id="subjectLabel" type="text" name="subjectLabel" class="form-control" placeholder="Subject Label" value="#event.getValue('subjectLabel')#">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="subscribeText">Subscribe Text</label>
                        <input id="subscribeText" type="text" name="subscribeText" class="form-control" placeholder="Subscribe Text" value="#event.getValue('subscribeText')#">
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="form-group">
                        <label for="emailList">Email List</label>
                        <small>To specify multiple email, separate the email with comma (,).</small>
                        <textarea id="emailList" name="emailList" class="form-control" placeholder="Subject List" rows="4" required="required">#event.getValue('emailList')#</textarea>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="form-group">
                        <label for="emailSubject">Email Subject</label>
                        <input id="emailSubject" name="emailSubject" class="form-control" placeholder="Subject List" required="required" value="#event.getValue('emailSubject')#"/>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="form-group">
                        <label for="successMessage">Success Message</label>
                        <input id="successMessage" type="text" name="successMessage" class="form-control" placeholder="Success Message" value="#event.getValue('successMessage')#">
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                <div class="form-group">
                    <label for="subjectList">Subject List</label>
                    <small>To specify multiple subjects, separate the subjects with pipe (|).</small>
                    <textarea id="subjectList" name="subjectList" class="form-control" placeholder="Subject List" rows="4" required="required">#event.getValue('subjectList')#</textarea>
                </div>

            </div>
            </div>
            <div class="row">            
                <div class="col-md-12">
                    <input type="submit" class="btn btn-success btn-send" value="Submit">
                </div>
            </div>
        </div>
    </div>
</form>
</cfoutput>