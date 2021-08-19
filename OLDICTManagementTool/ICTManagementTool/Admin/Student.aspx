<%@ Page Title="Student" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="True" CodeBehind="Student.aspx.cs" Inherits="ICTManagementTool.Admin.Student" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">



    <div runat="server" class="form-horizontal row DivForm" id="DivForm">
        <h2>Student Detail</h2>
        <div class="col-md-3">

            <asp:FormView ID="FVStudent" runat="server" ItemType="ICTManagementTool.Models.Students"
                SelectMethod="FVStudent_GetItem"
                InsertMethod="FVStudent_InsertItem"
                UpdateMethod="FVStudent_UpdateItem"
                DeleteMethod="FVStudent_DeleteItem"
                DataKeyNames="studentID"
                RenderOuterTable="False" OnPreRender="FVStudent_PreRender">

                <ItemTemplate>

                    <h4>Student Information</h4>
                    <div class="form-group row">
                        <div class="col-md-12">
                            <label class="control-label">Uni User Name</label>
                        </div>
                        <div class="col-md-12"><%# Item.uniUserName %></div>
                    </div>

                    <div class="form-group row">
                        <div class="col-md-12">
                            <label class="control-label">Uni Student ID</label>
                        </div>
                        <div class="col-md-12"><%# Item.uniStudentID %></div>
                    </div>
                    <div class="form-group row">
                        <div class="col-md-12">
                            <label class="control-label">PlanId</label>
                        </div>
                        <div class="col-md-12"><%# Item.planId %></div>
                    </div>
                    <div class="form-group row">
                        <div class="col-md-12">
                            <label class="control-label">GPA</label>
                        </div>
                        <div class="col-md-12"><%# Item.gpa %></div>
                    </div>
                    <div class="form-group row">
                        <div class="col-md-12">
                            <label class="control-label">Year</label>
                        </div>
                        <div class="col-md-12"><%# Item.year %></div>
                    </div>
                    <div class="form-group row">
                        <div class="col-md-12">
                            <label class="control-label">Semester</label>
                        </div>
                        <div class="col-md-12"><%# Item.semester %></div>
                    </div>
                    


                </ItemTemplate>




            </asp:FormView>
        </div>


        <div class="col-md-9">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h4 class="panel-title">Student Comments</h4>
                </div>
                <div class="panel-body">
                    <asp:Repeater ID="RepeaterComments" runat="server" ItemType="ICTManagementTool.Admin.CommentsDetail">
                        <HeaderTemplate>
                                <div class="form-group row">
                                    <div class="col-md-3">
                                        <label class="control-label">Comment Date</label>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="control-label">Comment By</label>
                                    </div>
                                    <div class="col-md-5">
                                        <label class="control-label">Comment</label>
                                    </div>
                                    <div class="col-md-1">
                                        <label class="control-label">Flag</label>
                                    </div>
                                </div>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <div class="form-group row">
                                    <div class="col-md-3"><%# Item.comments.commentDate %></div>
                                    <div class="col-md-3"><%# Item.personName %></div>
                                    <div class="col-md-5"><%# Item.comments.comment %></div>
                                    <div class="col-md-1"><%# Item.comments.flag %></div>
                                </div>
                            </ItemTemplate>
                        <SeparatorTemplate>
                            <hr />
                        </SeparatorTemplate>

                    </asp:Repeater>
                    <label class="control-label" visible="false" id="LabelNoComments" runat="server">This student has no comments</label>
                </div>
            </div>
        <input type="button" class="btn btn-primary" value="Add Comment" />
        </div>
    </div>
    <div class="form-group">
                        <a href="Students.aspx" class="btn btn-default">View Students</a>
                        <a class="btn btn-danger" onclick="alert('Function not implemented yet.');">Delete Student</a>
                    </div>
</asp:Content>
