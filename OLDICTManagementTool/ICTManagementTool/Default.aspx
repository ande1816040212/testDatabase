<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ICTManagementTool._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron" style="background-color:#ff7c7c" runat="server" id="messageBox">
        <h2>Error</h2>
        <p id="messageText" runat="server" style="font-size:20px"></p>
    </div>

    <div class="jumbotron">
        <h1>ICT Project Allocation Tool</h1>
        <p class="lead">This project will be used by UniSA Students, Staff and Clients to provide more structured and relevent projects to Students.</p>
    </div>

    <div class="row">
        <div class="col-md-4">
            <h2>C#</h2>
            <p>
                C# is a multi-paradigm programming language encompassing strong typing, imperative, declarative, functional, generic, object-oriented (class-based), and component-oriented programming disciplines<sup>1</sup>.
            </p>
            <p>
                1. <a target="_blank" href="https://en.wikipedia.org/wiki/C_Sharp_(programming_language)">Wikipedia - C Sharp</a>
            </p>
            <p>
                <a target="_blank" class="btn btn-default" href="https://docs.microsoft.com/en-us/dotnet/articles/csharp/programming-guide/">Learn more &raquo;</a>
            </p>
        </div>
        <div class="col-md-4">
            <h2>ASP.NET</h2>
            <p>
                ASP.NET is an open-source server-side web application framework designed for web development to produce dynamic web pages. It was developed by Microsoft to allow programmers to build dynamic web sites, web applications and web services<sup>2</sup>.
            </p>
            <p>
                2. <a target="_blank" href="https://en.wikipedia.org/wiki/ASP.NET">Wikipedia - ASP.NET</a>
            </p>
            <p>
                <a target="_blank" class="btn btn-default" href="https://www.asp.net/">Learn more &raquo;</a>
            </p>
        </div>
        <div class="col-md-4">
            <h2>AngularJS</h2>
            <p>
                AngularJS is a JavaScript-based open-source front-end web application framework used to address many of the challenges encountered in developing single-page applications<sup>3</sup>.
            </p>
            <p>
                3. <a target="_blank" href="https://en.wikipedia.org/wiki/AngularJS">Wikipedia - AngularJS</a>
            </p>
            <p>
                <a target="_blank" class="btn btn-default" href="https://angularjs.org/">Learn more &raquo;</a>
            </p>
        </div>
    </div>

</asp:Content>
