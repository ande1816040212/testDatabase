<%@ Page Title="ProjectAllocations" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProjectAllocations.aspx.cs" Inherits="ICTManagementTool.Allocation.ProjectAllocations" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script src="/Scripts/angular.min.js"></script>
    <script src="/Scripts/angular-drag-and-drop-lists.js"></script>
    <style>
        .student, .client, .staff, .people {
            min-height: 50px;
        }

            .student li:hover, .client li:hover, .staff li:hover, .people div:hover {
                background-color: rgba(255, 153, 102, 0.3);
                transition: all 0.3s;
            }

        .peopleContainer {
            min-height: 200px;
        }

        .individualPerson {
            padding-right: 20px;
        }

            .individualPerson:hover {
                background-color: rgba(255, 153, 102, 0.5);
                transition: all 0.3s;
            }

        .projectRow {
            margin: 2px 0;
            padding: 5px 2px;
            border-top: 1px solid #a2a2a2;
            border-bottom: 1px solid #a2a2a2;
        }

            .projectRow:nth-child(2n+1) {
                background-color: rgb(249, 249, 249);
            }

            .projectRow .staff, .projectRow .student {
                white-space: nowrap;
            }

        .people {
            padding-left: 0px;
            background-color: rgb(249, 249, 249);
        }

        .studentList {
        }

        .staffList {
        }

        .dropZone {
            background-color: green;
        }

        .dndDraggingSource {
            display: none;
        }

        .dndPlaceholder {
            background-color: #ddd;
            display: block;
            min-height: 42px;
        }

        ul {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }

        .projectRow select, .projectRow select option {
            background-color: transparent;
            border-color: #5a5a5a;
            color: #3c3c3c;
        }

        /* Highly important */
        .projectRow.level3 {
            background-color: #ffc991;
        }

        /* important */
        .projectRow.level2 {
            background-color: #ffdab8;
        }

        /* priority over normal */
        .projectRow.level1 {
            background-color: #ffeedf;
        }

        .projectRow.Allocated {
            background-color: #c8e8c8 !important;
        }

        .projectRow.Accepted {
            background-color: #ddf !important;
        }

        .projectRow.Rejected {
            background-color: #faa !important;
        }

        .projectRow .row.detail div > span {
            display: inline-block;
            padding-right: 10px;
        }

        /* 
            this stops the scroll bar from changing the width of the page
            this helps when the search returns no entries
        */
        html {
            overflow-y: scroll;
        }

        .smallFont {
            font-size: 0.8em;
        }

        .studentLink:hover {
            text-decoration: none;
            background-color: rgba(255, 153, 102, 0.7);
            transition: all 0.3s;
        }

        .input-sm {
            padding: 5px;
        }

        .error {
            color: #c00;
            font-weight: bold;
            font-size: 1em;
        }
    </style>

    <div class="row" data-ng-app="app" data-ng-controller="cont">
        <div class="col-md-6 col-sm-6 col-xs-6">
            <h3>Projects</h3>
            <div class="form-group row input-sm">
                <div class="col-md-3 col-sm-3 col-xs-3">
                    <asp:DropDownList runat="server" ID="DDLYear" CssClass="form-control input-sm" data-ng-model="yearFilter"></asp:DropDownList>
                </div>
                <div class="col-md-3 col-sm-3 col-xs-3">
                    <asp:DropDownList runat="server" ID="DDLSemester" CssClass="form-control input-sm" data-ng-model="semesterFilter"></asp:DropDownList>
                </div>
                <div class="col-md-4 col-sm-4 col-xs-4">
                    <select class="form-control input-sm" data-ng-model="statusFilter" data-ng-options="status.StatusId as status.StatusName for status in statusForAll">
                    </select>
                </div>
            </div>
            <div class="row form-group thead-inverse">
                <div class="col-md-6">
                    <h4>Project No - Title</h4>
                </div>
                <div class="col-md-3">
                    <h4>Staff</h4>
                </div>
                <div class="col-md-3">
                    <h4>Students</h4>
                </div>
            </div>
            <div data-ng-hide="(projects  | filter:{projectYear:yearFilter} | filter:{projectSemester:semesterFilter}).length">No projects for selected year/study period</div>
            <div style="max-height: 480px; overflow-y: scroll; overflow-x: hidden">
                <div data-ng-class="[p.statusName, ('level' + p.priorityProjects.priorityLevel)]" class="row projectRow smallFont" data-ng-repeat="p in projects | filter:{projectStatus:statusFilter} | filter:{projectYear:yearFilter} | filter:{projectSemester:semesterFilter}">
                    <div class="col-md-6" title="Double Click to view Project">
                        <div class="row">
                            <div class="col-md-12">
                                {{p.projectID}} - {{p.projectTitle}}
                                <span data-ng-show="p.companyName"><strong>({{p.companyName}})</strong></span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <select class="form-control input-sm ddlStatus"
                                    data-ng-model="p.projectStatus"
                                    data-ng-options="status.statusId as status.statusName for status in statusList"
                                    data-ng-change="statusChange(p.projectID, p.projectStatus, p.statusName, $index)">
                                </select>
                            </div>
                        </div>
                        <div class="row detail" style="margin-top: 5px">
                            <div class="col-md-12">
                                <span data-ng-show="p.honoursUndergrad == 'h'"><strong title="Must be Hons Student(s)">HON</strong></span>
                                <span data-ng-show="p.honoursUndergrad != 'h'" title="Single Semester project">SEM</span>
                                <span data-ng-show="p.austCitizenOnly"><strong title="Must be an Australian Citizen">AUS</strong></span>
                                <span data-ng-show="p.scholarshipAmt" style="color: #cc0000"><strong title="This project has a scholarship attached &#013;{{p.scholarshipDetail}}">${{p.scholarshipAmt.toLocaleString()}}</strong></span>
                                <span data-ng-show="p.clientEmailSentDate" data-ng-attr-title="{{formatDate('Client emailed', p.clientEmailSentDate)}}">&#9993;</span>
                                <span title="Students required: {{p.studentsReq}}"><span data-ng-repeat="student in setStudents(p.studentsReq) track by $index">&#x1f464;
                                </span></span>
                                <span>{{p.projectCode}}</span>
                                <a href="/Partners/Project?Id={{p.Id}}" target="_blank" title="Link to project"></a>

                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <span data-ng-show="!p.staff.length">-</span>

                        <ul class="staff" data-dnd-list="staff" data-dnd-allowed-types="['staffAdd']" data-dnd-drop="staffAllocated(item, p)">
                            <li data-ng-repeat="st in p.staff"
                                data-dnd-draggable="st"
                                data-dnd-moved="staffUnallocated(st, $index, p)"
                                data-dnd-type="'staffRemove'"
                                draggable="true"
                                data-ng-style="{'background-color':(st.allocatedProjectCount>1?'#f7a67b':'')}">{{st.fullName}}
                            </li>
                        </ul>
                        <span data-ng-show="p.staffEmailSentDate" data-ng-attr-title="{{formatDate('Staff emailed', p.staffEmailSentDate)}}">&#9993;</span>

                    </div>
                    <div class="col-md-3">
                        <span data-ng-show="!p.students.length">-</span>

                        <ul class="student" data-dnd-dragover="dragover(event);" data-dnd-list="p.students" data-dnd-allowed-types="['studentAdd']" data-dnd-drop="studentAllocated(item, p)">
                            <li data-ng-repeat="s in p.students"
                                data-dnd-draggable="s"
                                data-dnd-moved="studentUnallocated(s, $index, p)"
                                data-dnd-type="'studentRemove'"
                                draggable="true">
                                <span title="{{(s.genderCode == 'M' ? '&male;' : '&female;')+ ' ' + (s.student.international == 'Y' ? '&#9992;' : '') + ' ' + (s.student.externalStudent ? '&phone;' :'') + ' ' + s.fullName + '\n' + s.planCode + ' (' + s.student.gpa +')' }}">
                                    <span data-ng-class="checkPlan(s, p)" title="Mismatch between project type/duration and student plan">&osol;</span>    <a href="https://my.unisa.edu.au/Staff/Teaching/Students/Program.aspx?sid={{s.student.uniStudentID}}" target="_blank">{{s.fullName}} ({{s.student.gpa}})</a>
                                </span></li>
                        </ul>
                        <span data-ng-show="p.studentEmailSentDate" data-ng-attr-title="{{formatDate('Students emailed', p.studentEmailSentDate)}}">&#9993;</span>

                    </div>
                </div>
            </div>
            <hr />
            <asp:Button runat="server" ID="BProjectCodes" ClientIDMode="static" CssClass="btn btn-primary" Text="Generate Codes" OnClick="BProjectCodes_Click" />
            <asp:Button runat="server" ID="BRemoveProjectCodes" ClientIDMode="static" CssClass="btn btn-danger" Text="Remove Codes" OnClick="BRemoveProjectCodes_Click" />

            <script>
                $('#BProjectCodes').on('click', function (e) {
                    if (!confirm('Are you sure you want to generate the final unique project codes?')) {
                        e.preventDefault();
                    }
                });
            </script>
        </div>
        <div class="col-md-6 col-sm-6 col-xs-6">
            <!-- FILTER/SEARCH AREA -->
            <h3>People</h3>
            <h4>Filter</h4>
            <div class="form-group row">
                <div class="col-md-6">
                    <select id="DDLPeople" class="form-control" onchange="changeList(this.value)">
                        <option value="student">Students</option>
                        <option value="staff">Supervisors</option>
                    </select>
                </div>

                <div class="col-md-6 studentList">
                    <select class="form-control" data-ng-model="planFilter" data-ng-options="item as item.planName for item in plans track by item.planId" data-ng-change="changeCourses()"></select>
                </div>
            </div>
            <div class="form-group row">
                <div class="col-md-6 studentList">
                    <select class="form-control" data-ng-model="gpaDDLValue">
                        <option value="all">All GPAs</option>
                        <option value=">0">Between 0.0 and 1.99</option>
                        <option value=">2">Between 2.0 and 2.99</option>
                        <option value=">3">Between 3.0 and 3.99</option>
                        <option value=">4">Between 4.0 and 4.99</option>
                        <option value=">5">Between 5.0 and 5.99</option>
                        <option value=">6">Between 6.0 and 7.0</option>
                        <option value="none">No GPA on record</option>
                    </select>
                </div>

                <div class="col-md-6">
                    <input name="filter" type="text" placeholder="Search" class="form-control"
                        data-ng-model="searchText" />
                </div>
            </div>
            <div class="row form-group">
                <div class="col-md-12">
                    <input type="checkbox" class="form-group" data-ng-model="showAllocated" checked />
                    Include allocated people
                </div>
            </div>
            <h4>Sort</h4>
            <div class="form-group row">
                <div class="col-md-7">
                    <select class="form-control studentList" data-ng-model="studentSort" data-ng-options="item.sortName for item in sortOptions track by item.value">
                    </select>
                    <select class="form-control staffList" data-ng-model="staffSort">
                        <option value="fullName">Name</option>
                    </select>

                </div>

                <div class="col-md-5">
                    <span data-ng-click="sortOrder(false)" data-ng-class="(!order.reverse) ? 'btn btn-primary' : 'btn btn-default'">ASC</span> <span data-ng-click="sortOrder(true)" data-ng-class="(order.reverse) ? 'btn btn-primary' : 'btn btn-default'">DESC</span>
                </div>
            </div>
            <div class="form-group row staffList">
                <div class="form-group col-md-12">
                    <div class="row" style="font-weight: bold">
                        <div class="col-md-6">
                            Name
                        </div>
                        <div class="col-md-6">
                            Allocated projects
                        </div>
                    </div>
                </div>
                <div style="border: 1px solid #fff; max-height: 300px; overflow-y: scroll;">
                    <div class="form-group peopleContainer" data-dnd-list="staff" data-dnd-allowed-types="['staffRemove']">

                        <div class="form-group col-md-12 individualPerson" data-ng-repeat="st in staff | filter:searchText | filter: (!showAllocated ? {allocated:false} : '') | orderBy: staffSort:order.reverse"
                            data-dnd-draggable="st"
                            data-dnd-type="'staffAdd'">
                            <div class="row" data-ng-style="{'background-color':(st.allocated==true?'#f7a67b':'')}">
                                <div class="col-md-6">
                                    {{st.fullName}}
                                </div>
                                <div class="col-md-6">
                                    {{st.allocatedCount}}
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-group row studentList smallFont">
                <div class="form-group col-md-12">
                    <div class="row" style="font-weight: bold">
                        <div class="col-md-4">
                            <span>Name</span>
                        </div>
                        <span class="col-md-7" style="justify-content: center; display: flex; margin-left: -2%">
                            <span style="flex-grow: 1; flex-basis: 0;" data-ng-repeat="c in shownCourses">
                                <span title="{{c.courseName}}">{{c.courseAbbreviation}}</span>
                            </span>
                        </span>

                        <div class="col-md-1">
                            GPA
                        </div>
                    </div>
                </div>
                <div class="form-group col-md-12 peopleContainer" data-dnd-list="students" data-dnd-allowed-types="['studentRemove']"
                    style="max-height: 300px; overflow-y: scroll;">
                    <div class="row" data-ng-show="filteredStudents.length == 0">
                        No students for selected filters.
                    </div>
                    <div class="form-group individualPerson"
                        data-ng-repeat="s in (filteredStudents = (students | filter:searchText | filter: (!showAllocated ? {allocated:false} : '') | filter: {year:yearFilter} | filter: {semester:semesterFilter} | planFilter:planFilter.planId | gpaFilter:gpaDDLValue | orderBy: customStudentSort:order.reverse))"
                        data-dnd-draggable="s"
                        data-dnd-type="'studentAdd'">
                        <div class="row" data-ng-style="{'background-color':(s.allocated==true?'#f7a67b':'')}">
                            <div class="col-md-4">
                                <span title="{{(s.genderCode == 'M' ? '&male;' : '&female;')+ ' ' + (s.international == 'Y' ? '&#9992;' : '') + ' ' + (s.externalStudent ? '&phone;' :'') + ' ' + s.fullName + '\n' + s.planCode }}">{{s.fullName.length < 17 ? s.fullName : s.fullName.substring(0,20) + '...'}}</span>
                            </div>

                            <a class="col-md-7 studentLink" style="justify-content: space-around; display: flex" href="https://my.unisa.edu.au/Staff/Teaching/Students/Program.aspx?sid={{s.uniStudentID }}" target="_blank" title="click to view student record or drag to allocate project">
                                <span style="flex-grow: 1; flex-basis: 0;" data-ng-repeat="c in shownCourses">{{getStudentCourse(s, c.courseId)}}
                                </span>
                            </a>
                            <div class="col-md-1">
                                <span style="white-space: nowrap" data-ng-show="!s.gpa">-</span>
                                {{s.gpa}}
                            </div>
                        </div>
                    </div>
                </div>
            </div>


        </div>

    </div>
    <script>

        $('.row').on('dblclick', '.projectRow', function () {

            $(this).find('a')[0].click();
        })

        changeList(document.getElementById('DDLPeople').value);

        //changes which people are shown
        //either staff or students
        function changeList(listId) {
            $(".studentList").hide();
            $(".staffList").hide();
            if (listId == "student") {
                $(".studentList").show();
            }
            else if (listId == "staff") {
                $(".staffList").show();
            }
            else {
                console.log("an error has occurred");
            }
        }

        var app = angular.module("app", ["dndLists"]);

        app.controller("cont", function ($scope, $http) {
            //initial values for ng-models
            //a lot of these allow for a value to be selected on page load
            //instead of just a blank option

            var date = new Date();
            var month = date.getMonth();
            var year = date.getFullYear();

            $scope.shownCourses = [];
            $scope.allocatedCheck = true;
            $scope.gpaDDLValue = "all";
            $scope.yearFilter = year.toString();
            $scope.semesterFilter = month < 4 ? "sp2" : "sp5";
            $scope.statusFilter = "all";
            $scope.studentSort = "fullName";
            $scope.staffSort = "fullName";

            //gets all of the projects and a list of all status'
            $http({
                method: 'GET',
                url: '/api/ProjectStatus'
            }).then(function successCallback(response) {
                $scope.statusList = response.data;
            }, error);

            //gets all of the projects in the database
            //basically gets the data for the left side of the page
            $http({
                method: 'GET',
                url: '/api/ProjectPeopleAllocations'
            }).then(function successCallback(response) {
                $scope.projects = response.data;
            }, error);

            $scope.setStudents = function (num) {
                return new Array(num);
            }

            //gets all of the student, staff and plans from the database
            //basically gets the data for the right side of the page
            $http.get("/api/PeopleProjectAllocations/" + $scope.yearFilter + "/" + $scope.semesterFilter).then(function success(response) {
                $scope.students = response.data[0];
                $scope.staff = response.data[1];
                $scope.plans = response.data[2];

                //add/remove from here for the "All Plans" option
                var statusForAll = [
                    { StatusId: '', StatusName: 'All States' },
                    { StatusId: 1, StatusName: 'Pending' },
                    { StatusId: 2, StatusName: 'Expression of Interest' },
                    { StatusId: 3, StatusName: 'Accepted' },
                    { StatusId: 4, StatusName: 'Rejected' },
                    { StatusId: 5, StatusName: 'Allocated' },
                    { StatusId: 6, StatusName: 'Postpone' },
                    { StatusId: 7, StatusName: 'Postgrad' },
                    { StatusId: 8, StatusName: 'UOA / Masters' },
                    { StatusId: 9, StatusName: 'More Info Req.' }
                ];
                //156781 DF
                var coursesForAll = [
                    { courseID: "105295 ", courseAbbreviation: "SDC++", courseName: "Software Development with C++" },
                    { courseID: "105294", courseAbbreviation: "PF", courseName: "Programming Fundamentals" },
                    { courseID: "156783", courseAbbreviation: "WEB", courseName: "Web Development" },
                    { courseID: "012540", courseAbbreviation: "IDIE", courseName: "Interface Desgin, Interaction and Experience" },
                    { courseID: "105284", courseAbbreviation: "AgNET", courseName: "Agile Development with .NET" }
                ];

                $scope.plans.unshift({ planName: "All Plans", planId: -1, planCode: null, courses: coursesForAll });
                $scope.statusForAll = statusForAll;
                $scope.statusFilter = '';
                $scope.planFilter = $scope.plans[0];
                $scope.changeCourses();

                $scope.showAllocated = false;

            }, error);

            function error(response) {
                console.log(response.status + " " + response.statusText);
            };



            //changes the status of a project
            $scope.statusChange = function (projectId, statusId, oldStatus, index) {
                $http({
                    method: "PUT",
                    url: "/api/ProjectManagement?id=1&projectId=" + projectId + "&statusId=" + statusId,
                    headers: {
                        "Content-Type": "application/json"
                    }

                }).then(function (response) {
                    // var ddl = $('.ddlStatus');
                    var newStatus = $.grep($scope.statusForAll, function (e) { return e.StatusId == statusId; })[0];

                    var project = $('.projectRow').eq(index);
                    //alert(JSON.stringify(project));
                    // alert('old: [' + oldStatus + '] New: [' + newStatus.StatusName + '] == ' + index);
                    project.removeClass(oldStatus).addClass(newStatus.StatusName);
                }, error);
            }

            $scope.nameOfStatus = function (id) {
                return $scope.statusList.find(s => s.statusId === id).statusName;
            }


            //adds a student to a project
            $scope.studentAllocated = function (s, p) {
                $http({
                    method: "PUT",
                    url: "/api/PeopleProjectAllocations?id=a&personId=" + s.studentID + "&projectId=" + p.projectID + "&role=student",
                    headers: {
                        "Content-Type": "application/json"
                    }
                }).then(function (response) {
                    $scope.students.splice($scope.students.indexOf(s), 1);
                    $scope.reloadData();
                });
            };

            //deletes a student from a project
            $scope.studentUnallocated = function (s, index, p) {
                $http.delete("/api/PeopleProjectAllocations?userId=" + s.personID + "&projectId=" + p.projectID).then(function (response) {
                    p.students.splice(index, 1);
                    $scope.reloadData();
                });

            };


            //deletes a staff member from a project
            $scope.staffUnallocated = function (s, index, p) {
                $http.delete("/api/PeopleProjectAllocations?userId=" + s.personID + "&projectId=" + p.projectID).then(function (response) {
                    p.staff.splice(index, 1);
                    $scope.reloadData();
                });

            };

            //adds a staff member to a project
            $scope.staffAllocated = function (s, p) {
                $http({
                    method: "PUT",
                    url: "/api/PeopleProjectAllocations?id=a&personId=" + s.staffID + "&projectId=" + p.projectID + "&role=staff",
                    headers: {
                        "Content-Type": "application/json"
                    }
                }).then(function (response) {
                    //$scope.staff.splice($scope.staff.indexOf(s), 1);
                    $scope.reloadData();
                });
            };

            //not currently used
            //dropzones
            $scope.dragover = function (a) {
                //to look into, need to change the background color of the dropzone
                //a.path[1].class = 'dropZone';
                return true;
            };

            //basically just redownloads all of the data for the page
            //this method gets called whenever any person is added/removed from a project
            $scope.reloadData = function () {
                //  alert("here");
                $http.get("/api/PeopleProjectAllocations/" + $scope.yearFilter + "/" + $scope.semesterFilter).then(function success(response) {
                    $scope.students = response.data[0];
                    $scope.staff = response.data[1];
                }, error);
                $http({
                    method: 'GET',
                    url: '/api/ProjectPeopleAllocations'
                }).then(function successCallback(response) {
                    $scope.projects = response.data;
                }, error);
            }

            //this seems overly complicated, but it works
            //but I was too scared to touch it
            $scope.order = {
                reverse: false
            };
            $scope.sortOrder = function (order) {
                $scope.order.reverse = order;
            }


            //gets called each time the plan dropdown is changed
            //it changes what course grades are shown in the student list
            $scope.changeCourses = function () {
                $scope.shownCourses = [];

                //add to this list to add sort options for all plans
                $scope.sortOptions = [{ sortName: "Name", value: "fullName" }, { sortName: "GPA", value: "gpa" }];
                if ($scope.planFilter.courses != null) {
                    for (var i = 0; i < $scope.planFilter.courses.length; i++) {
                        $scope.shownCourses.push({ courseId: $scope.planFilter.courses[i].courseID, courseAbbreviation: $scope.planFilter.courses[i].courseAbbreviation, courseName: $scope.planFilter.courses[i].courseName });
                        $scope.sortOptions.push({ sortName: $scope.planFilter.courses[i].courseName, value: $scope.planFilter.courses[i].courseID });
                    }
                }
                $scope.studentSort = $scope.sortOptions[0];
            }

            //gets the given student's BEST grade for the given course
            //returns "-" if the student hasnt taken the course
            $scope.getStudentCourse = function (student, courseId) {
                var studentCourse = student.courses.filter(c => c.courseID == courseId);

                //checks if there is at least one entry for the given user
                if (studentCourse.length >= 1) {
                    //sorts the list of results based on the scores
                    //returns the first entry in the array
                    //basically returns the best score from the student in the given course
                    return studentCourse.sort(function (a, b) { return b.courseScore - a.courseScore })[0].grade;
                }
                else {
                    return "-";
                }
            }

            //the custom sort method for students
            //this method is needed due to the complexity of student sort
            //sometimes they are sorted easily ie. fullName or gpa
            //but sometimes they are sorted on course scores,
            //which is why this method is needed
            $scope.customStudentSort = function (student) {
                if ($scope.studentSort.value == "fullName") {
                    return student.fullName;
                }
                else if ($scope.studentSort.value == "gpa") {
                    return student.gpa;
                }
                //this else will be reached when the sort option is a course score
                //ie. 105291
                else {
                    var course = student.courses.find(c => c.courseID === $scope.studentSort.value);
                    if (null != course) {
                        return course.courseScore;
                    }
                    else {
                        return null;
                    }
                }
            }


            $scope.formatDate = function (txt, date) {
                if (date) {
                    date = new Date(date);
                    var day = date.getDate();
                    var monthIndex = date.getMonth();
                    var year = date.getFullYear();
                    var weekday = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
                    var hours = date.getHours();
                    var minutes = date.getMinutes();
                    var ampm = hours >= 12 ? 'pm' : 'am';
                    hours = hours % 12;
                    hours = hours ? hours : 12; // the hour '0' should be '12'
                    minutes = minutes < 10 ? '0' + minutes : minutes;
                    var strTime = hours + ':' + minutes + ' ' + ampm;

                    return txt + ' ' + weekday[date.getDay()] + ' ' + date.getDate() + "/" + (date.getMonth() + 1) + "/" + date.getFullYear() + "  " + strTime;
                } else {
                    return null;
                }
                // return day + ' ' + monthNames[monthIndex] + ' ' + year;
            }

            $scope.checkPlan = function (s, p) {
                console.log(s.projectDuration + ' ' + p.projectDuration);
                var hon = p.honoursUndergrad == 'h';

                if (s.projectDuration != p.projectDuration) {
                    return "error";
                }
                else {
                    return "hidden";
                }
            }

        });

        //this custom filter is used to filter people on their gpas
        //this filter is actually called multiple times during filtration
        //so don't get confused while debugging!
        app.filter('gpaFilter', function () {
            return function (items, gpaValue) {
                var filtered = [];
                if (null != items) {
                    for (var i = 0; i < items.length; i++) {
                        var item = items[i];

                        //probably a simpler way to do this
                        //but this works just fine!
                        switch (gpaValue) {
                            case "all":
                                filtered.push(item);
                                break;
                            case ">6":
                                if (item.gpa >= 6)
                                    filtered.push(item);
                                break;
                            case ">5":
                                if (item.gpa >= 5 && item.gpa < 6)
                                    filtered.push(item);
                                break;
                            case ">4":
                                if (item.gpa >= 4 && item.gpa < 5)
                                    filtered.push(item);
                                break;
                            case ">3":
                                if (item.gpa >= 3 && item.gpa < 4)
                                    filtered.push(item);
                                break;
                            case ">2":
                                if (item.gpa >= 2 && item.gpa < 3)
                                    filtered.push(item);
                                break;
                            case ">0":
                                if (item.gpa >= 0 && item.gpa < 2)
                                    filtered.push(item);
                                break;
                            case "none":
                                if (item.gpa == null)
                                    filtered.push(item);
                                break;

                        }
                    }
                }
                return filtered;
            };

        });

        //this custom filter is used to filter people on their plans
        //this filter is actually called multiple times during filtration
        //so don't get confused while debugging!
        app.filter('planFilter', function () {
            return function (items, planId) {
                if (planId == -1) {
                    return items;
                }
                else {
                    var filtered = [];
                    if (null != items) {
                        for (var i = 0; i < items.length; i++) {
                            if (items[i].planId == planId) {
                                filtered.push(items[i]);
                            }
                        }
                    }
                    return filtered;
                }
            };
        });
    </script>


</asp:Content>
