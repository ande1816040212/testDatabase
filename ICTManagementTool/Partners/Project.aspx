<%@ Page Title="Project" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Project.aspx.cs" Inherits="ICTManagementTool.Partners.Project" %>

<%@ Register Src="~/Account/OpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script src="/Scripts/angular.js"></script>

    <link href="../Scripts/dropzone/dropzone.css" rel="stylesheet" />
    <script src="../Scripts/dropzone/dropzone.js"></script>

    <style>
        /* a lot of the formatting came from:
            https://www.w3schools.com/howto/tryit.asp?filename=tryhow_css_login_form_modal
        */
        .DivModal {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 1; /* Sit on top */
            left: 0;
            top: 0;
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            overflow: auto; /* Enable scroll if needed */
            background-color: rgb(0,0,0); /* Fallback color */
            background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
            padding-top: 60px;
            padding-bottom: 0px;
        }

        /* Modal Content/Box */
        .DivModalContent {
            background-color: #fefefe;
            margin: 5% auto 15% auto; /* 5% from the top, 15% from the bottom and centered */
            border: 1px solid #888;
            width: 80%; /* Could be more or less, depending on screen size */
            padding: 10px;
        }
    </style>



    <h2>
        <asp:Label runat="server" ID="LAction"> Selected</asp:Label>
        Project</h2>
    <asp:FormView ID="FVProject" runat="server" ItemType="ICTManagementTool.Models.Projects"
        SelectMethod="FVProject_GetItem"
        InsertMethod="FVProject_InsertItem"
        UpdateMethod="FVProject_UpdateItem"
        DeleteMethod="FVProject_DeleteItem"
        DataKeyNames="projectID"
        RenderOuterTable="False"
        OnPreRender="FVProject_PreRender">


        <ItemTemplate>
            <%# Item.projectID + ": " + Item.projectCode %><br />
            <div class="form-group row">
                <div class="col-md-4">
                    <label class="control-label">Title</label>
                </div>
                <div class="col-md-12"><%# isBlank(Item.projectTitle) %></div>
            </div>

            <div class="form-group row">
                <div class="col-md-4">
                    <label class="control-label">Scope</label>
                </div>
                <div class="col-md-12"><%# isBlank(Item.projectScope) %></div>
            </div>
            <div class="form-group row" id="ProjectOwnerDiv" runat="server">
                    <div class="col-md-4">
                        <label class="control-label">
                            Project Owner
                        </label>
                    </div>
                    <div class="col-md-12">
                        <%# getOwner(Item.projectCreatorID) %>
                        </select>
                    </div>
                </div>
            <div class="form-group row">
                <div class="col-md-4">
                    <label class="control-label">Project Outcomes</label>
                </div>
                <div class="col-md-12"><%# isBlank(Item.projectOutcomes) %></div>
            </div>
            <div data-ng-app="app2" data-ng-controller="cont2">
                <div class="form-group row">
                    <div class="col-md-4">
                        <label class="control-label">Project Efforts</label>
                    </div>

                    <div class="col-md-12" data-ng-show="!effortsApplied.length">
                        No efforts applied
                    </div>
                    <div class="col-md-12" data-ng-show="effortsApplied.length">
                        <div class="row" style="font-weight: bold">
                            <div class="col-md-2">
                                Effort description
                            </div>
                            <div class="col-md-2">
                                Effort Hours
                            </div>
                            <div class="col-md-8">
                                Effort comment
                            </div>
                        </div>
                        <div class="row" data-ng-repeat="effort in effortsApplied">

                            <div class="col-md-2">
                                {{ effort.effort.effortDescription }}
                            </div>
                            <div class="col-md-2">
                                {{ effort.hours }}
                            </div>
                            <div class="col-md-8">
                                {{ effort.comment }}
                            </div>

                        </div>
                    </div>

                </div>
                <div class="form-group row">
                    <div class="col-md-4">
                        <label class="control-label">Australian Citizen Requirement</label>
                    </div>
                    <div class="col-md-12">
                        <input type="checkbox" disabled="" name="austCitizenOnly" <%# isChecked(Item.austCitizenOnly) %> />
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-md-4">
                        <label class="control-label">Honours Project</label>
                    </div>
                    <div class="col-md-12">
                        <asp:CheckBox runat="server" disabled="" ID="CBHonsProject" Checked='<%# ("h").Equals(Item.honoursUndergrad) %>' />
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-md-4">
                        <label class="control-label">Students Required</label>
                    </div>
                    <div class="col-md-12">
                        <%# Item.studentsReq %>
                    </div>
                </div>
                <div class="form-group row" runat="server" visible="<%# Item.scholarshipAmt.HasValue %>">
                    <div class="col-md-4">
                        <label class="control-label">Scholarship:</label>
                    </div>
                    <div class="col-md-12">
                        <%# Item.scholarshipAmt.HasValue ? Item.scholarshipAmt.Value.ToString("C") : "" %><br />
                        <%# Item.scholarshipDetail %>
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-md-4">
                        <label class="control-label">Pre-Placement Requirements</label>
                    </div>
                    <div class="col-md-12"><%# isBlank(Item.projectPlacementRequirements) %></div>
                </div>
                <div class="form-group row">
                    <div class="col-md-12">
                        <label class="control-label">Methods Applied</label>
                    </div>
                    <asp:Repeater runat="server" ID="RMethodsApplied" ItemType="ProjectMethodsAppliedDetail">
                        <ItemTemplate>
                            <div class="col-md-4" <%# isUncheckedToHide(Item.isChecked) %>>
                                <input type="checkbox" disabled="" name="methodApplied" <%# isChecked(Item.isChecked) %> />
                                <%# Item.methodDesc %>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <div class="form-group row">
                    <div class="col-md-4">
                        <label class="control-label">Status</label>
                    </div>
                    <div class="col-md-12"><%# statusNameFromId(Item.projectStatus) %></div>
                </div>

                <div class="form-group row">
                    <div class="col-md-4">
                        <label class="control-label">Files</label>
                    </div>
                    <div class="col-md-12">
                        <ul data-ng-repeat="pd in projectDocuments">
                            <li><a data-ng-href="{{pd.filePath}}" data-ng-target="_blank">{{ pd.documentTitle }}</a></li>
                        </ul>
                    </div>
                </div>

                <div class="form-group row">
                    <div class="col-md-4">
                        <label class="control-label">Additional Files</label>
                    </div>
                    <div class="col-md-12">
                        <ul data-ng-repeat="ad in additionalDocuments">
                            <li><a data-ng-href="{{ad.filePath}}" data-ng-target="_blank">{{ ad.documentTitle }}</a></li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <a href="/Partners/ProjectManagement.aspx" class="btn btn-default">View Projects</a>
                <asp:LinkButton runat="server" CommandName="New" CssClass="btn btn-default">Create Project</asp:LinkButton>
                <asp:LinkButton runat="server" CommandName="Edit" CssClass="btn btn-primary">Edit Project</asp:LinkButton>
                <asp:LinkButton runat="server" CommandName="Delete" CssClass="btn btn-danger" formnovalidate="">Delete Project</asp:LinkButton>
            </div>
        </ItemTemplate>
        <EditItemTemplate>
            <div class="form-group row">
                <div class="col-md-4">
                    <label class="control-label">
                        Project Name
                    </label>
                </div>
                <div class="col-md-12">
                    <asp:TextBox runat="server" ID="TBTitle" required="required" Text='<%#BindItem.projectTitle %>' CssClass="form-control" />
                </div>

            </div>

            <div class="form-group row">
                <div class="col-md-4">
                    <label class="control-label">
                        Broad Project Scope
                    </label>
                </div>
                <div class="col-md-12">
                    <asp:TextBox runat="server" ID="TBProjectScope" required="required" TextMode="MultiLine" Rows="10" Text='<%# BindItem.projectScope %>' CssClass="form-control" />
                </div>
            </div>
            <div data-ng-app="app" data-ng-controller="cont" runat="server">
                <div class="form-group row" id="ProjectOwnerDiv" runat="server">
                    <div class="col-md-4">
                        <label class="control-label">
                            Project Owner
                        </label>
                    </div>
                    <div class="col-md-12">
                        <select class="form-control" data-ng-class="selectedOwner.clientID == -1?'btn-danger':''" data-ng-model="selectedOwner" data-ng-options="item.clientName for item in allClients track by item.clientID">
                        </select>
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-md-4">
                        <label class="control-label">
                            Status
                        </label>
                    </div>
                    <div class="col-md-12"><%# Item.projectStatus %></div>
                </div>


                <div class="form-group row">
                    <div class="col-md-12">
                        <label class="control-label">
                            Project Duration and Semester
                        </label>
                    </div>
                    <div class="col-md-2 col-sm-3 col-xs-4">
                        <asp:DropDownList runat="server" ID="DDLDuration" CssClass="form-control" AutoPostBack="False" SelectedValue="<%# BindItem.projectDuration%>">
                            <asp:ListItem Text="4 Month" Value="4" />
                            <asp:ListItem Text="9 Month" Value="9" />
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-2 col-sm-3 col-xs-4">
                        <asp:DropDownList runat="server" ID="DDLSemester" CssClass="form-control" SelectedValue="<%# BindItem.projectSemester%>">
                            <asp:ListItem Text="SP2" Value="SP2" />
                            <asp:ListItem Text="SP5" Value="SP5" />
                        </asp:DropDownList>

                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-md-12">
                        <label class="control-label">
                            Project Outcome
                        </label>
                    </div>
                    <div class="col-md-12">

                        <asp:TextBox runat="server" ID="TBProjectOutcomes" required="required" TextMode="MultiLine" Rows="7" Text='<%# BindItem.projectOutcomes %>' CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-md-4">
                        <label class="control-label">Australian Citizen Requirement</label>
                    </div>
                    <div class="col-md-12">
                        <asp:CheckBox runat="server" ID="CBaustCitizenOnly" Checked='<%# BindItem.austCitizenOnly %>' />
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-md-4">
                        <label class="control-label">Honours Project</label>
                    </div>
                    <div class="col-md-12">
                        <asp:CheckBox runat="server" ID="CBHonsProject" Checked='<%# ("h").Equals(Item.honoursUndergrad) %>' />
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-md-4">
                        <label class="control-label">Scholarship:</label>
                    </div>
                    <div class="col-md-12">
                        <input type="checkbox" id="CBScholarship"  <%# isChecked(Item.scholarshipAmt.HasValue) %>' />
                        <div class="scholarship" <%# isUncheckedToHide(Item.scholarshipAmt.HasValue) %>>
                            Amount: 
                            <asp:TextBox runat="server" ID="TBScholarshipAmt" Text='<%# BindItem.scholarshipAmt %>'></asp:TextBox><br />
                            Detail:
                            <asp:TextBox runat="server" ID="TBScholarshipDetail" TextMode="multiline" Rows="5" Text='<%# BindItem.scholarshipDetail %>'></asp:TextBox>
                        </div>
                        <script>
                            $('#CBScholarship').on('change', function () {
                                var c = $(this).is(':checked');
                                if (c) {
                                    $('.scholarship').show();
                                }
                                else {
                                    $('.scholarship').hide();
                                }
                            })
                        </script>
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-md-4">
                        <label class="control-label">Students Required</label>
                    </div>
                    <div class="col-md-12">
                        <asp:DropDownList runat="server" ID="DDLStudentsRequired" SelectedValue='<%# BindItem.studentsReq %>'>
                            <asp:ListItem>1</asp:ListItem>
                            <asp:ListItem>2</asp:ListItem>
                            <asp:ListItem>3</asp:ListItem>
                            <asp:ListItem>4</asp:ListItem>
                            <asp:ListItem>5</asp:ListItem>
                            <asp:ListItem>6</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-md-12">
                        <label class="control-label">
                            Estimated Project Efforts
                        </label>
                    </div>
                    <div class="col-md-12">
                        <div class="row" style="min-height: 30px; font-weight: bold">

                            <div class="col-md-2">
                                Effort
                            </div>
                            <div class="col-md-2">
                                Hours                           
                            </div>
                            <div class="col-md-4">
                                Comment                           
                            </div>
                            <div class="col-md-1">
                                Action                           
                            </div>

                        </div>
                        <div class="row" data-ng-hide="effortsApplied.length" style="min-height: 50px">
                            <div class="col-md-12">No efforts</div>
                        </div>
                        <div class="row effortsApplied" style="min-height: 50px" data-ng-repeat="e in effortsApplied">

                            <div class="col-md-2">
                                <select class="form-control" data-ng-model="e.effort" data-ng-options="item.effortDescription for item in allEfforts track by item.effortID">
                                </select>
                            </div>
                            <div class="col-md-2">
                                <input type="number" class="form-control" data-ng-model="e.hours" />
                            </div>
                            <div class="col-md-4">
                                <input type="text" class="form-control" data-ng-model="e.comment" />
                            </div>
                            <div class="col-md-1">
                                <input type="button" class="btn btn-warning" value="Remove effort" data-ng-click="removeEffort($index)">
                            </div>
                        </div>

                    </div>
                    <div class="col-md-12">
                        <input type="button" class="btn btn-success" value="Add new effort" data-ng-click="addNewEffort()" />
                    </div>

                </div>

                <div class="form-group row">
                    <div class="col-md-12">
                        <label class="control-label">
                            Pre-Placement Requirements
                        </label>
                    </div>

                    <div class="col-md-12">

                        <asp:TextBox runat="server" ID="TBPrePlacementReq" required="required" Text='<%# BindItem.projectPlacementRequirements %>' CssClass="form-control" />

                    </div>
                </div>

                <div class="form-group row">
                    <div class="col-md-12">
                        <label class="control-label">
                            Methods Applied
                        </label>
                    </div>
                    <asp:Repeater runat="server" ID="RMethodsApplied" ItemType="ProjectMethodsAppliedDetail">
                        <ItemTemplate>
                            <div class="col-md-4">
                                <input title='<%# Item.methodDesc %>' type="checkbox" value='<%# Item.methodID %>' name="methodApplied" <%# isChecked(Item.isChecked) %> />
                                <%# Item.methodDesc %>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <div class="form-group row">
                    <div class="col-md-12">
                        <label class="control-label">
                            Government Legislation
                        </label>
                    </div>
                    <div class="col-md-12">
                        <font size="2">
                    The University of South Australia facilitates student placements on the basis that host employers adhere to the following legislation:
                    <ul>
                        <li>South Australian Work Health and Safety Act 2012</li>
                        <li>Fair Work Act 2009 – <a href="https://www.fairwork.gov.au/pay/unpaid-work">https://www.fairwork.gov.au/pay/unpaid-work</a></li>
                        <li>Equal opportunity laws relevant to South Australia -<a href="http://www.eoc.sa.gov.au/eo-you/discrimination-laws/south-australian-laws"> http://www.eoc.sa.gov.au/eo-you/discrimination-laws/south-australian-laws</a></li>
                        <li>Privacy Act 1998</li> 
                    </ul>

                    </font>
                        <asp:CheckBox ID="CBAgreement" AutoPostBack="False" Text="Yes, I agree to host the student, in line with the above legislation and guidelines." TextAlign="Right" Checked='<%# BindItem.requirementsMet %>' runat="server" />
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-md-12">
                        <label class="control-label">
                            Staff/Client Files
                        </label>
                    </div>

                    <div class="col-md-12">
                        <div id="dZUpload" class="client dropzone">
                            <div class="dz-default dz-message">Drop file here.</div>
                        </div>
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-md-12">
                        <label class="control-label">
                            Additional Files
                        </label>
                    </div>

                    <div class="col-md-12">
                        <div id="dZUploadAdditional" class="additional dropzone">
                            <div class="dz-default dz-message">Drop file here.</div>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <asp:LinkButton runat="server" CommandName="Update" CssClass="btn btn-success" data-ng-click="editPageSubmit()">Save Project</asp:LinkButton>
                    <asp:LinkButton runat="server" CommandName="Cancel" CssClass="btn btn-warning" formnovalidate="">Cancel Changes</asp:LinkButton>
                </div>
            </div>

        </EditItemTemplate>
        <InsertItemTemplate>

            <div class="form-group row">
                <div class="col-md-4">
                    <label class="control-label">
                        Project Name
                    </label>
                </div>

                <div class="col-md-12">
                    <asp:TextBox runat="server" ID="TBTitle" required="required" Text='<%# BindItem.projectTitle %>' CssClass="form-control"> </asp:TextBox>
                </div>
            </div>

            <div class="form-group row">
                <div class="col-md-4">
                    <label class="control-label">
                        Broad Project Scope
                    </label>
                </div>
                <div class="col-md-12">
                    <asp:TextBox runat="server" ID="TBProjectScope" required="required" TextMode="MultiLine" Rows="10" Text='<%# BindItem.projectScope %>' CssClass="form-control" />
                </div>
            </div>

            <div class="form-group">
                <asp:LinkButton runat="server" CommandName="Insert" CausesValidation="true" CssClass="btn btn-success">Save and Continue</asp:LinkButton>
                <a href="ProjectManagement.aspx" class="btn btn-warning">Cancel Project</a>
            </div>

        </InsertItemTemplate>
        <EmptyDataTemplate>
            <div class="alert alert-danger" role="alert">
                <strong>No project selected!</strong>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <asp:LinkButton runat="server" CommandName="New" class="btn btn-default">Create a Project</asp:LinkButton>
                </div>
            </div>
        </EmptyDataTemplate>


    </asp:FormView>
    <div class="form-group row">
        <div class="col-md-4">
            <asp:CheckBoxList runat="server" ID="CheckList"></asp:CheckBoxList>
        </div>

    </div>

    <script>
        Dropzone.options.dZUploadAdditional =
            {
                init: function () {

                    var dZUpload = this;

                    $.getJSON("/api/ProjectDocuments?projectId=" +<%=projectIdForAngular %>).done(function (data) {

                        var projectDocuments = data[1];

                        for (var i = 0; i < projectDocuments.length; i++) {
                            //TODO:
                            //get real size of document
                            //will probably need to be done in the projectDocuments controller
                            console.log(JSON.stringify(projectDocuments[i]));

                            var mockFile = {
                                name: projectDocuments[i].documentTitle,
                                size: projectDocuments[i].size,
                                projectDocumentId: projectDocuments[i].projectDocumentID
                            };

                            // Call the default addedfile event handler
                            dZUpload.emit("addedfile", mockFile);

                            // Make sure that there is no progress bar, etc...
                            dZUpload.emit("complete", mockFile);
                        }
                    });

                    this.on("removedfile", function (file) {
                        $.ajax({
                            url: "/api/ProjectDocuments?projectId=" + <%=projectIdForAngular %>+ "&documentTitle=" + file.name,
                            type: 'DELETE',
                            success: function (result) {
                                // Do something with the result
                            }
                        });
                    });
                }
            };

        Dropzone.options.dZUpload = {


            init: function () {

                var dZUpload = this;


                $.getJSON("/api/ProjectDocuments?projectId=" +<%=projectIdForAngular %>).done(function (data) {

                    var projectDocuments = data[0];

                    for (var i = 0; i < projectDocuments.length; i++) {
                        //TODO:
                        //get real size of document
                        //will probably need to be done in the projectDocuments controller
                        console.log(JSON.stringify(projectDocuments[i]));

                        var mockFile = {
                            name: projectDocuments[i].documentTitle,
                            size: projectDocuments[i].size,
                            projectDocumentId: projectDocuments[i].projectDocumentID
                        };

                        // Call the default addedfile event handler
                        dZUpload.emit("addedfile", mockFile);

                        // Make sure that there is no progress bar, etc...
                        dZUpload.emit("complete", mockFile);
                    }
                });

                this.on("removedfile", function (file) {
                    $.ajax({
                        url: "/api/ProjectDocuments?projectId=" + <%=projectIdForAngular %>+ "&documentTitle=" + file.name,
                        type: 'DELETE',
                        success: function (result) {
                            // Do something with the result
                        }
                    });
                });
            }
        };

        <%--
        Dropzone.options.dZUpload = {
            init: function () {

                var dZUpload = this;
               
                $.getJSON("/api/ProjectDocuments?projectId=" +<%=projectIdForAngular %>).done(function (data) {
                    var projectDocuments = data[0];
                    var projectDocumentsSizes = data[1];
                    for (var i = 0; i < projectDocuments.length; i++) {
                        //TODO:
                        //get real size of document
                        //will probably need to be done in the projectDocuments controller
                        var mockFile = { name: projectDocuments[i].documentTitle, size: projectDocumentsSizes[i], projectDocumentId: projectDocuments[i].projectDocumentID };

                        // Call the default addedfile event handler
                        dZUpload.emit("addedfile", mockFile);

                        // Make sure that there is no progress bar, etc...
                        dZUpload.emit("complete", mockFile);
                    }
                });

                this.on("removedfile", function (file) {
                    $.ajax({
                        url: "/api/ProjectDocuments?projectId=" + <%=projectIdForAngular %>+ "&documentTitle=" + file.name,
                        type: 'DELETE',
                        success: function (result) {
                            // Do something with the result
                        }
                    });
                });
            }
        };
       --%>

        Dropzone.autoDiscover = false;

        //https://codepedia.info/using-dropzone-js-file-image-upload-in-asp-net-webform-c/


        //http://www.dropzonejs.com/#configuration-options
        $(document).ready(function () {

            //Simple Dropzonejs 
            $(".client.dropzone").dropzone({
                url: "ProjectFileUploader.ashx?projectId=" +<%=projectIdForAngular %>,
                addRemoveLinks: true,
                acceptedFiles: "application/pdf, .docx, .doc, .txt, .zip, .png, .jpg",
                success: function (file, response) {
                    var imgName = response;
                    file.previewElement.classList.add("dz-success");
                },
                error: function (file, response) {
                    file.previewElement.classList.add("dz-error");
                }
            });

            $(".additional.dropzone").dropzone({
                url: "ProjectFileUploader.ashx?projectId=" +<%=projectIdForAngular %> + "&docSource=additional",
                addRemoveLinks: true,
                acceptedFiles: "application/pdf, .docx, .doc, .txt, .zip, .xls, .xlsx, .xlsm, .png, .jpg",
                success: function (file, response) {
                    var imgName = response;
                    file.previewElement.classList.add("dz-success");
                },
                error: function (file, response) {
                    file.previewElement.classList.add("dz-error");
                }
            });
        });


        var app = angular.module("app", []);

        app.controller("cont", function ($scope, $http) {

            //some weird way to get the current projectId
            var projectId = '<%=projectIdForAngular %>';

            $http({
                method: 'GET',
                //need to find a way to get the proejctID from the page
                url: '/api/ProjectEfforts?projectId=' + projectId
            }).then(function successCallback(response) {
                $scope.effortsApplied = response.data[0];
                $scope.allEfforts = response.data[1];
                $scope.allClients = response.data[2];

                var currentOwner = $scope.allClients.find(x => x.clientID === response.data[3].clientID);

                if (currentOwner != undefined) {
                    $scope.selectedOwner = currentOwner;
                }
                else {
                    var tempClient = { clientID: -1, clientName: "No client currently assigned", companyName: "" };
                    $scope.allClients.push(tempClient);
                    $scope.selectedOwner = tempClient;
                }


            }, error);

            $scope.addNewEffort = function () {
                $scope.effortsApplied.push({ comment: "", effort: $scope.allEfforts[0], hours: 0 });
            };

            $scope.editPageSubmit = function () {
                for (var i = 0; i < $scope.effortsApplied.length; i++) {
                    $scope.effortsApplied[i].effortID = $scope.effortsApplied[i].effort.effortID;
                }
                var clientId = $scope.selectedOwner.clientID;
                if (clientId == 0 || clientId == null || clientId == undefined) {
                    clientId == -1;
                }

                $http.put("/api/ProjectEfforts?projectId=" + projectId + "&clientId=" + clientId + "&effortsApplied=", $scope.effortsApplied)
                    .then(
                        function (response) {

                        }, error);
            };


            $scope.removeEffort = function (index) {
                $scope.effortsApplied.splice(index, 1);
            };



        });

        function error(response) {
            console.log(response.status + " " + response.statusText);
        };


        var app2 = angular.module("app2", []);

        app2.controller("cont2", function ($scope, $http) {

            //some weird way to get the current projectId
            var projectId = '<%=projectIdForAngular %>';
            $http({
                method: 'GET',
                //need to find a way to get the proejctID from the page
                url: '/api/ProjectEfforts?projectId=' + projectId
            }).then(function successCallback(response) {
                $scope.effortsApplied = response.data[0];
            }, error);

            $http({
                method: 'GET',
                //need to find a way to get the proejctID from the page
                url: '/api/ProjectDocuments?projectId=' + projectId
            }).then(function successCallback(response) {
                $scope.projectDocuments = response.data[0];
                $scope.additionalDocuments = response.data[1];
            }, error);

        });


    </script>


</asp:Content>
