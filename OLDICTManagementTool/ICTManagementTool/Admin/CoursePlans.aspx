<%@ Page Title="Course Plans" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CoursePlans.aspx.cs" Inherits="ICTManagementTool.Admin.CoursePlans" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script src="/Scripts/angular.js"></script>
    <div class="row" data-ng-app="app" data-ng-controller="cont">
        <h2>Link Courses To Plans</h2>

        <div class="col-md-5">
            <div class="row">
                <select class="form-control" id="ddlPlans" data-ng-model="selectedPlan" data-ng-options="item as item.planName for item in plans">
                </select>
            </div>

            <div class="row">
                <div class="col-md-12">
                    <h4>Courses for {{selectedPlan.planName}}:</h4>

                    <div data-ng-hide="selectedPlan.PlanCourses.length">No courses.</div>

                    <div class="row" data-ng-repeat="c in selectedPlan.PlanCourses">
                        <div class="col-md-6">{{c.courseName}}</div>
                        <div class="col-md-3">{{c.courseId}}</div>
                        <div class="col-md-3">
                            <input type="button" class="form-control btn btn-danger" value="Remove" data-ng-click="removeCourse(selectedPlan.planId,c.courseId)" />
                        </div>

                    </div>
                </div>
            </div>
        </div>



        <div class="col-md-5">
            <select class="form-control" id="ddlCourses" data-ng-model="selectedCourse" data-ng-options="item as item.courseName for item in courses">
            </select>
        </div>

        <div class="col-md-2">
            <input type="button" class="form-control btn btn-success" value="Add course to plan" data-ng-click="addCourse(selectedPlan.planId, selectedCourse.courseId)" />
        </div>
    </div>

    <script>


        var app = angular.module("app", []);

        app.controller("cont", function ($scope, $http) {
            
            $scope.selectedPlan = null;
            $scope.plans = [];

            $http({
                method: 'GET',
                url: '/api/PlanCourses'
            }).then(function successCallback(response) {
                $scope.plans = response.data[0];
                $scope.courses = response.data[1];
                $scope.selectedPlan = $scope.plans[0];
                $scope.selectedCourse = $scope.courses[0];

                console.log($scope.plans);
            }, error);


            function error(response) {
                console.log(response.status + " " + response.statusText);
            };

            $scope.removeCourse = function (planId, courseId) {
                $http.delete("/api/PlanCourses?planId=" + planId + "&courseId=" + courseId).then(function (response) {
                    
                    $scope.reloadData();
                });
            };

            $scope.addCourse = function (planId, courseId) {
                $http({
                    method: "PUT",
                    url: "/api/PlanCourses?id=a&planId=" + planId + "&courseId=" + courseId,
                    headers: {
                        "Content-Type": "application/json"
                    }

                }).then(function (response) {
                    $scope.reloadData();

                });
            };

            $scope.reloadData = function () {
                $http({
                    method: 'GET',
                    url: '/api/PlanCourses'
                }).then(function successCallback(response) {
                    $scope.plans = response.data[0];
                    $scope.courses = response.data[1];
                    $scope.selectedCourse = $scope.courses[0]; // hack
                    $scope.selectedPlan = $scope.plans[0]; // grab the 1st thing in the list to show
                    // TODO, remove selected item.
                }, error);
            };
        });

    </script>
</asp:Content>
