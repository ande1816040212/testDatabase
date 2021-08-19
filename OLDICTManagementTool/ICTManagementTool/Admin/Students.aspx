<%@ Page Title="Student Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Students.aspx.cs" Inherits="ICTManagementTool.Admin.Students" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script src="/Scripts/angular.js"></script>
    <h2>Students</h2>

    <div class="row" data-ng-app="myApp" data-ng-controller="myController">
        <div class="col-md-12" data-ng-show="students.length">
            <label>Filter:</label>


            <input class="form-control" id="studentFilter" type="text" data-ng-model="studentName" placeholder="..." />
        </div>

        <div style="height: 10px;" class="col-md-12" data-ng-show="students.length">
        </div>

        <div class="col-md-12" data-ng-show="students.length">
            <table class="table table-striped table-hover">
                <thead class="thead-inverse">
                    <tr>
                        <th class="col-md-3">
                            <a href="#" data-ng-click="orderByField='studentName'; reverseSort = !reverseSort">Student Name<span data-ng-show="orderByField == 'studentName'"><span data-ng-show="!reverseSort">▲</span><span data-ng-show="reverseSort">▼</span></span></a>
                        </th>
                        <th class="col-md-3">
                            <a href="#" data-ng-click="orderByField='s.uniUserName'; reverseSort = !reverseSort">University Username<span data-ng-show="orderByField == 's.uniUserName'"><span data-ng-show="!reverseSort">▲</span><span data-ng-show="reverseSort">▼</span></span></a>
                        </th>
                        <th class="col-md-3">
                            <a href="#" data-ng-click="orderByField='s.uniStudentID'; reverseSort = !reverseSort">Student ID<span data-ng-show="orderByField == 's.uniStudentID'"><span data-ng-show="!reverseSort">▲</span><span data-ng-show="reverseSort">▼</span></span></a>
                        </th>
                        <th class="col-md-3">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr data-ng-repeat="s in students | filter:studentName | orderBy:orderByField:reverseSort">
                        <td>{{ s.studentName }}</td>
                        <td>{{ s.s.uniUserName }}</td>
                        <td>{{ s.s.uniStudentID }}</td>
                        <td>

                            <a class="btn btn-primary" href="Student.aspx?studentID={{ s.s.studentID }}">View</a>
                            <button type="button" data-ng-click="deleteStudent(s)" class="btn btn-danger">Delete</button>

                        </td>
                    </tr>
                </tbody>

            </table>
        </div>

        <div class="col-md-12" data-ng-hide="students.length">

            <label>The database contains no students.</label>
        </div>
    </div>

    <div>
    </div>

    <style>
        /* 
            this stops the scroll bar from changing the width of the page
            this helps when the search returns no entries
        */
        html {
            overflow-y: scroll;
        }
    </style>
    <script>
        //this is needed to prevent postback on enter press
        //https://stackoverflow.com/questions/21579724/how-to-prevent-postback-while-pressing-enter-key-from-inside-html-input-textbox
        $('input[type="text"]').keydown(function (event) {
            if (event.keyCode == 13) {
                event.preventDefault();
                return false;
            }
        });


        var myApp = angular.module("myApp", []);
        var myController = myApp.controller("myController", function ($scope, $http) {



            $http.get("/api/AdminStudents").then(function success(response) {
                $scope.students = response.data;

                $scope.orderByField = 'studentName';
                $scope.reverseSort = false;
            }, error);


            $scope.deleteStudent = function (student) {
                $http.delete("/api/AdminStudents?personId=" + student.personID + "&studentId=" + student.s.studentID).then(function (response) {
                    $scope.students.splice($scope.students.indexOf(student), 1);
                });

            }

        });


        function error(response) {
            alert(response.status + " " + response.statusText);
        };




    </script>
</asp:Content>
