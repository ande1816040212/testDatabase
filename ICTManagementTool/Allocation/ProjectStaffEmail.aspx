<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProjectStaffEmail.aspx.cs" Inherits="ICTManagementTool.Allocation.ProjectStaffEmail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Use this page to email people</h2>
    <div class="row">
        <div class="col-md-9">
            <div class="form-group">
                Subject:
        [project code]<asp:TextBox runat="server" ID="TBSubject" Text=" ICT Project Detail"></asp:TextBox>
                <br />
                ReplyTo:
                <asp:TextBox ID="TBReplyTo" runat="server"></asp:TextBox>
            </div>
            <div class="form-group">
                Body Intro:
        <textarea class="form-control" id="TBBody" name="TBBody" rows="5"> 
        </textarea>
            </div>
            <div class="form-group pull-right">
                <asp:Button runat="server" ID="BSendEmail" OnClick="BSendEmail_Click" Text="Send" />
            </div>

        </div>
        <div class="col-md-3">
            <h3>Projects</h3>
            <div style="max-height: 480px; overflow-y: scroll">
                <asp:Repeater runat="server" EnableViewState="false" ID="RProjectList" SelectMethod="RProjectList_GetData" ItemType="ICTManagementTool.Allocation.ProjectStaffEmail+StaffProjectDetail">
                    <ItemTemplate>
                        <div class="form-group">
                            <h6><%# Item.project.projectCode %>: <%# Item.project.projectTitle %> </h6>
                            <ul>
                                <li><b>Students:</b> <%# Item.studentCount %></li>
                                <li><b>Staff:</b> <%# Item.staff %></li>
                                <li><b>Staff Emailed:</b> <%# Item.staffEmailed ? "Yes" : "No" %></li>
                                <li><b>Email now:</b>
                                    <input type="checkbox" value='<%# Item.project.projectID %>' name="projectIDs" /></li>
                            </ul>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>



    <script src="/Scripts/tinymce/tinymce.js"></script>
    <script>
        var text = '<p>Hi Everyone and welcome to ICT Projects for [year]. </p>';
        text += '<p>You are receiving this email because you have been assigned the role of Academic Supervisor to the ICT Project listed below. ';
        text += 'The students will be notified of their project groups by next Monday.</p> ';
        text += '<p>As an academic supervisor your role is to meet with your students for an hour each week. '; 
        text += 'You will be asked to provide professional advice and act as a mentor for the group. ';
        text += 'As part of the hour meeting students must show their product back log activities for the week. ';
        text += 'Please check that the hours reported seem reasonable for the activity. ';
        text += 'This should represent ~15 hours of solid work per student. ';
        text += 'If students aren’t meeting this workload please let me know as soon as possible (stem-ictproject@unisa.edu.au).</p> ';
        text += '<hr />';
        text += '[project]';
        text += '[client]';
        text += '[staff]';
        text += '[student]';
        text += '[document]';
        text += '<p>Regards<br />';
        text += 'David Harris - ICT Coordinator <br />';
        text += 'Nicole King - ICT Admin Support</p> ';


        $('#TBBody').html(text);

        tinymce.init({
            selector: '#TBBody',
            height: 360,
            menubar: false,
            plugins: [
                "advlist autolink autosave link image lists charmap print preview hr anchor pagebreak",
                "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
                "table contextmenu directionality emoticons template textcolor paste fullpage textcolor colorpicker textpattern"
            ],
            toolbar1: "newdocument fullpage | bold italic underline strikethrough | alignleft aligncenter alignright alignjustify | styleselect formatselect fontselect fontsizeselect",
            toolbar2: "cut copy paste | searchreplace | bullist numlist | outdent indent blockquote | undo redo | link unlink anchor image media code | insertdatetime preview | forecolor backcolor",
            toolbar3: "table | hr removeformat | subscript superscript | charmap emoticons | print fullscreen | ltr rtl | visualchars visualblocks nonbreaking template pagebreak restoredraft",
            content_css: [
                '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i',
                '//www.tinymce.com/css/codepen.min.css'],

            menubar: false,
            toolbar_items_size: 'small',

            style_formats: [{
                title: 'Bold text',
                inline: 'b'
            }, {
                title: 'Red text',
                inline: 'span',
                styles: {
                    color: '#ff0000'
                }
            }, {
                title: 'Red header',
                block: 'h1',
                styles: {
                    color: '#ff0000'
                }
            }, {
                title: 'Example 1',
                inline: 'span',
                classes: 'example1'
            }, {
                title: 'Example 2',
                inline: 'span',
                classes: 'example2'
            }, {
                title: 'Table styles'
            }, {
                title: 'Table row 1',
                selector: 'tr',
                classes: 'tablerow1'
            }],

            templates: [{
                title: 'Test template 1',
                content: 'Test 1'
            }, {
                title: 'Test template 2',
                content: 'Test 2'
            }],

            init_instance_callback: function () {
                window.setTimeout(function () {
                    $("#div").show();
                }, 1000);
            }
        });
    </script>
</asp:Content>

