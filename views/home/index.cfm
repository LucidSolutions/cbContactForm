<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1"><i class="fa fa-wpforms"></i> Contacts List</h1>
    </div>
</div>
<div class="row">
    <div class="col-md-9">
        #getInstance( "messagebox@cbMessagebox" ).renderit()#
        <form id="contactform" method="post" action="#prc.xehContactRemove#" role="form">
            <input type="hidden" name="targetContactID" id="targetContactID" value="" />
            <div class="panel panel-default">

                <div class="panel-heading">
                    <div class="row">
                        <!--- Quick Search --->
                        <div class="col-md-6">
                            <div class="form-group form-inline no-margin">
                                #html.textField(
                                    name        = "userSearch",
                                    class       = "form-control",
                                    placeholder = "Quick Search"
                                )#
                            </div>
                        </div>
                        <div class="col-md-6">
                            <!--- Actions Bar --->
                            <div class="pull-right">
                                <a type="button" class="btn btn-sm btn-info" href="#prc.xehContactForm#"><i class="fa fa-cogs"></i> Contact Form Settings</a>
                                <button type="button" class="btn btn-sm btn-primary" onclick="javascript:contentShowAll();"><i class="fa fa-list"></i> Show All</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel-body">
                    <!--- container --->
                    <div id="contactTableContainer">
                        <p class="text-center">
                            <i id="userLoader" class="fa fa-spinner fa-spin fa-lg icon-4x"></i>
                        </p>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <!--- Sidebar Filters --->
    <div class="col-md-3">

        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-filter"></i> Filters</h3>
            </div>

            <div class="panel-body">
                <div id="filterBox">
                    #html.startForm( name="filterForm", action=prc.xehContactSearch, class="form-vertical",role="form" )#
                        <div class="form-group">
                            <label for="dStatus" class="control-label">Deleted Status: </label>
                            <select name="dStatus" id="dStatus" class="form-control input-sm">
                                <option value="any">Any</option>
                                <option value="true">Yes</option>
                                <option value="false" selected="selected">No</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="rStatus" class="control-label">Read Status: </label>
                            <select name="rStatus" id="rStatus" class="form-control input-sm">
                                <option value="any" selected="selected">Any</option>
                                <option value="true">Read</option>
                                <option value="false">Unread</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="sStatus" class="control-label">Subject: </label>
                            <select name="sStatus" id="sStatus" class="form-control input-sm">
                                <option value="any" selected="selected">Any</option>
                                <cfloop array="#prc.subjectList#" index="u" item="idx">
                                    <option value="#trim(idx)#">#trim(idx)#</option>
                                </cfloop>                         
                            </select>
                        </div>
                        <a class="btn btn-info btn-sm" href="javascript:contentFilter()">Apply Filters</a>
                        <a class="btn btn-sm btn-default" href="javascript:resetFilter( true )">Reset</a>
                    #html.endForm()#
                </div>
            </div>
        </div>

            <div class="panel panel-primary">
                <!--- Info Box --->
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <i class="fa fa-question"></i> Help
                    </h3>
                </div>
                <div class="panel-body">
                    <p>Contact us for is essential for every site, this plugin lets you create one without effort.</p>
                </div>
            </div>

            <div class="panel panel-primary">
        <!--- Info Box --->
        <div class="panel-heading">
            <h3 class="panel-title">
                <i class="fa fa-medkit"></i> Need Assistance?
            </h3>
        </div>
        <div class="panel-body">
            <p><a href="https://lucidsolutions.in" target="_blank" title="Lucid Outsourcing Solutions Pvt Ltd">
                <div class="center">
                    <img src="https://lucidsolutions.in/images/banner.png" alt="Lucid Outsourcing Solutions Pvt Ltd" border="0" />
                </div>
            </a></p>

            <p>
                <strong>Lucid Outsourcing Solutions Pvt. Ltd. </strong>
                have a team of exceptional ColdFusion/Lucee developers who spcialize in ColdBox and ContentBox. Please <a href="mailto:info@lucidsolutions.in">contact us</a> for details.
            </p>
        </div>
    </div>
    </div>
</div>
</cfoutput>