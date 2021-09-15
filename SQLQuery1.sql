/****** Object:  Table [Applications]    Script Date: 4/8/2021 8:54:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applications](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[ApplicationName] [nvarchar](235) NOT NULL,
	[Description] [nvarchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[ApplicationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AspNetRoles]    Script Date: 4/8/2021 8:54:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AspNetUserClaims]    Script Date: 4/8/2021 8:54:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [AspNetUserLogins]    Script Date: 4/8/2021 8:54:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AspNetUserRoles]    Script Date: 4/8/2021 8:54:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AspNetUsers]    Script Date: 4/8/2021 8:54:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[personID] [int] IDENTITY(1,1) NOT NULL,
	[dateCreated] [datetime] NOT NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[title] [nvarchar](25) NULL,
	[firstName] [nvarchar](max) NULL,
	[lastName] [nvarchar](max) NULL,
	[AccountAccepted] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [people_unique] UNIQUE NONCLUSTERED 
(
	[personID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Clients]    Script Date: 4/8/2021 8:54:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Clients](
	[clientID] [int] NOT NULL,
	[companyName] [varchar](100) NULL,
 CONSTRAINT [PK_Table_1] PRIMARY KEY CLUSTERED 
(
	[clientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Course]    Script Date: 4/8/2021 8:54:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Course](
	[courseID] [varchar](10) NOT NULL,
	[courseName] [varchar](150) NULL,
	[courseCode] [varchar](10) NULL,
	[courseAbbreviation] [varchar](6) NULL,
PRIMARY KEY CLUSTERED 
(
	[courseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Memberships]    Script Date: 4/8/2021 8:54:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Memberships](
	[UserId] [uniqueidentifier] NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
	[PasswordFormat] [int] NOT NULL,
	[PasswordSalt] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](256) NULL,
	[PasswordQuestion] [nvarchar](256) NULL,
	[PasswordAnswer] [nvarchar](128) NULL,
	[IsApproved] [bit] NOT NULL,
	[IsLockedOut] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastLoginDate] [datetime] NOT NULL,
	[LastPasswordChangedDate] [datetime] NOT NULL,
	[LastLockoutDate] [datetime] NOT NULL,
	[FailedPasswordAttemptCount] [int] NOT NULL,
	[FailedPasswordAttemptWindowStart] [datetime] NOT NULL,
	[FailedPasswordAnswerAttemptCount] [int] NOT NULL,
	[FailedPasswordAnswerAttemptWindowsStart] [datetime] NOT NULL,
	[Comment] [nvarchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [PeopleComments]    Script Date: 4/8/2021 8:54:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PeopleComments](
	[commentID] [int] IDENTITY(1,1) NOT NULL,
	[personID] [int] NOT NULL,
	[commentDate] [datetime] NOT NULL,
	[commentPersonID] [int] NOT NULL,
	[comment] [varchar](500) NOT NULL,
	[flag] [bit] NOT NULL,
 CONSTRAINT [PK_StudentComments] PRIMARY KEY CLUSTERED 
(
	[commentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [PeopleContacts]    Script Date: 4/8/2021 8:54:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PeopleContacts](
	[personID] [int] NOT NULL,
	[contactMethod] [varchar](15) NOT NULL,
	[contactValue] [varchar](100) NOT NULL,
	[preferred] [bit] NOT NULL,
	[dateCreated] [datetime] NOT NULL,
	[dateEnded] [datetime] NULL,
 CONSTRAINT [PK_PeopleContacts] PRIMARY KEY CLUSTERED 
(
	[personID] ASC,
	[contactMethod] ASC,
	[contactValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [PlanCourses]    Script Date: 4/8/2021 8:54:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PlanCourses](
	[planId] [int] NOT NULL,
	[courseId] [varchar](10) NOT NULL,
	[temp] [nchar](10) NULL,
 CONSTRAINT [PK_PlanCourses] PRIMARY KEY CLUSTERED 
(
	[courseId] ASC,
	[planId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Plans]    Script Date: 4/8/2021 8:54:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Plans](
	[planId] [int] IDENTITY(1,1) NOT NULL,
	[planName] [varchar](100) NULL,
	[planCode] [varchar](25) NULL,
	[durationYears] [int] NULL,
	[projectDuration] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[planId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[planName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [PriorityProjects]    Script Date: 4/8/2021 8:54:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PriorityProjects](
	[projectID] [int] NOT NULL,
	[dateCreated] [datetime] NOT NULL,
	[priorityLevel] [varchar](3) NOT NULL,
	[priorityReason] [varchar](500) NULL,
	[priorityCreatorID] [int] NULL,
 CONSTRAINT [PK_PriorityProjects] PRIMARY KEY CLUSTERED 
(
	[projectID] ASC,
	[dateCreated] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Profiles]    Script Date: 4/8/2021 8:54:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profiles](
	[UserId] [uniqueidentifier] NOT NULL,
	[PropertyNames] [nvarchar](max) NOT NULL,
	[PropertyValueStrings] [nvarchar](max) NOT NULL,
	[PropertyValueBinary] [varbinary](max) NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Program]    Script Date: 4/8/2021 8:54:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Program](
	[programCode] [varchar](30) NOT NULL,
	[programDescription] [varchar](100) NULL,
	[programDirectorName] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[programCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ProjectDocuments]    Script Date: 4/8/2021 8:54:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ProjectDocuments](
	[projectDocumentID] [int] IDENTITY(1,1) NOT NULL,
	[projectID] [int] NOT NULL,
	[documentSource] [varchar](10) NOT NULL,
	[documentLink] [varchar](250) NOT NULL,
	[documentTitle] [varchar](250) NOT NULL,
	[filePath] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[projectDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ProjectEfforts]    Script Date: 4/8/2021 8:54:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ProjectEfforts](
	[effortID] [int] IDENTITY(1,1) NOT NULL,
	[effortDescription] [varchar](100) NOT NULL,
	[effortRankValue] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[effortID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ProjectEffortsApplied]    Script Date: 4/8/2021 8:54:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ProjectEffortsApplied](
	[projectEffortsAppliedID] [int] IDENTITY(1,1) NOT NULL,
	[projectID] [int] NOT NULL,
	[effortID] [int] NOT NULL,
	[comment] [varchar](100) NULL,
	[hours] [int] NULL,
 CONSTRAINT [PK_ProjectEffortsApplied] PRIMARY KEY CLUSTERED 
(
	[projectEffortsAppliedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ProjectMethods]    Script Date: 4/8/2021 8:54:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ProjectMethods](
	[methodID] [int] IDENTITY(1,1) NOT NULL,
	[methodDescription] [varchar](100) NOT NULL,
	[otherDetailFlag] [bit] NOT NULL,
 CONSTRAINT [PK_ProjectMethods] PRIMARY KEY CLUSTERED 
(
	[methodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ProjectMethodsApplied]    Script Date: 4/8/2021 8:54:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ProjectMethodsApplied](
	[projectID] [int] NOT NULL,
	[methodID] [int] NOT NULL,
	[comment] [varchar](100) NULL,
 CONSTRAINT [PK_ProjectMethodsApplied] PRIMARY KEY CLUSTERED 
(
	[projectID] ASC,
	[methodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ProjectPeopleAllocations]    Script Date: 4/8/2021 8:54:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ProjectPeopleAllocations](
	[projectID] [int] NOT NULL,
	[personID] [int] NOT NULL,
	[personRole] [varchar](15) NOT NULL,
	[dateCreated] [datetime] NOT NULL,
	[creatorID] [int] NOT NULL,
	[creatorComment] [varchar](500) NULL,
 CONSTRAINT [PK_ProjectPeopleRoles] PRIMARY KEY CLUSTERED 
(
	[projectID] ASC,
	[personID] ASC,
	[personRole] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Projects]    Script Date: 4/8/2021 8:54:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Projects](
	[Id] [nvarchar](128) NOT NULL,
	[projectID] [int] IDENTITY(1,1) NOT NULL,
	[projectCode] [varchar](15) NULL,
	[projectTitle] [varchar](250) NULL,
	[projectScope] [varchar](max) NULL,
	[projectOutcomes] [varchar](max) NULL,
	[projectDuration] [int] NOT NULL,
	[projectPlacementRequirements] [varchar](500) NULL,
	[projectSponsorAgreement] [bit] NOT NULL,
	[projectStatus] [int] NOT NULL,
	[projectStatusComment] [varchar](500) NULL,
	[projectStatusChangeDate] [datetime] NULL,
	[projectSemester] [char](3) NULL,
	[projectSemesterCode] [varchar](10) NULL,
	[projectYear] [int] NOT NULL,
	[projectSequenceNo] [int] NULL,
	[honoursUndergrad] [varchar](5) NOT NULL,
	[requirementsMet] [bit] NOT NULL,
	[projectCreatorID] [int] NOT NULL,
	[dateCreated] [datetime] NOT NULL,
	[projectEffortRequirements] [char](10) NULL,
	[austCitizenOnly] [bit] NOT NULL,
	[studentsReq] [int] NOT NULL,
	[scholarshipAmt] [int] NULL,
	[scholarshipDetail] [varchar](max) NULL,
	[staffEmailSentDate] [datetime] NULL,
	[clientEmailSentDate] [datetime] NULL,
	[studentEmailSentDate] [datetime] NULL,
 CONSTRAINT [PK_Projects] PRIMARY KEY CLUSTERED 
(
	[projectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [ProjectStatus]    Script Date: 4/8/2021 8:54:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ProjectStatus](
	[ProjectStatusId] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [varchar](30) NOT NULL,
	[StatusDescription] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProjectStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[StatusName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Roles]    Script Date: 4/8/2021 8:54:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Roles](
	[RoleId] [uniqueidentifier] NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[RoleName] [nvarchar](256) NOT NULL,
	[Description] [nvarchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Staff]    Script Date: 4/8/2021 8:54:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staff](
	[staffID] [int] NOT NULL,
	[uniStaffID] [varchar](12) NULL,
	[username] [varchar](12) NULL,
	[dateEnded] [date] NULL,
 CONSTRAINT [PK_Staff] PRIMARY KEY CLUSTERED 
(
	[staffID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [StudentCourses]    Script Date: 4/8/2021 8:54:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StudentCourses](
	[studentCourseID] [int] IDENTITY(1,1) NOT NULL,
	[studentID] [int] NOT NULL,
	[courseID] [varchar](10) NOT NULL,
	[semester] [varchar](5) NULL,
	[year] [int] NULL,
	[grade] [varchar](5) NULL,
	[mark] [decimal](4, 1) NULL,
PRIMARY KEY CLUSTERED 
(
	[studentCourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UC_Student] UNIQUE NONCLUSTERED 
(
	[studentID] ASC,
	[courseID] ASC,
	[semester] ASC,
	[year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [StudentProjectRanking]    Script Date: 4/8/2021 8:54:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StudentProjectRanking](
	[studentID] [int] NOT NULL,
	[projectID] [int] NOT NULL,
	[projectRank] [int] NOT NULL,
 CONSTRAINT [PK_StudentProjectRanking] PRIMARY KEY CLUSTERED 
(
	[studentID] ASC,
	[projectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Students]    Script Date: 4/8/2021 8:54:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Students](
	[studentID] [int] NOT NULL,
	[planId] [int] NOT NULL,
	[uniUserName] [varchar](12) NOT NULL,
	[uniStudentID] [varchar](12) NOT NULL,
	[gpa] [decimal](3, 2) NULL,
	[genderCode] [varchar](5) NULL,
	[international] [varchar](5) NULL,
	[externalStudent] [bit] NOT NULL,
	[studentEmail] [varchar](100) NULL,
	[year] [int] NOT NULL,
	[semester] [char](3) NOT NULL,
	[dateEnded] [date] NULL,
 CONSTRAINT [PK_Students] PRIMARY KEY CLUSTERED 
(
	[studentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UC_uniStudentID] UNIQUE NONCLUSTERED 
(
	[uniStudentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Users]    Script Date: 4/8/2021 8:54:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users](
	[UserId] [uniqueidentifier] NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[IsAnonymous] [bit] NOT NULL,
	[LastActivityDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [UsersInRoles]    Script Date: 4/8/2021 8:54:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UsersInRoles](
	[UserId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AspNetUsers] ADD  CONSTRAINT [DF_AspNetUsers_dateCreated]  DEFAULT (getdate()) FOR [dateCreated]
GO
ALTER TABLE [AspNetUsers] ADD  DEFAULT ((0)) FOR [AccountAccepted]
GO
ALTER TABLE [PeopleComments] ADD  CONSTRAINT [DF_StudentComments_commendDate]  DEFAULT (getdate()) FOR [commentDate]
GO
ALTER TABLE [PeopleComments] ADD  CONSTRAINT [DF_PeopleComments_flag]  DEFAULT ('False') FOR [flag]
GO
ALTER TABLE [PeopleContacts] ADD  CONSTRAINT [DF_PeopleContacts_preferred]  DEFAULT ('False') FOR [preferred]
GO
ALTER TABLE [PeopleContacts] ADD  CONSTRAINT [DF_PeopleContacts_dateCreated]  DEFAULT (getdate()) FOR [dateCreated]
GO
ALTER TABLE [Plans] ADD  DEFAULT ((4)) FOR [projectDuration]
GO
ALTER TABLE [PriorityProjects] ADD  CONSTRAINT [DF_PriorityProjects_dateCreated]  DEFAULT (getdate()) FOR [dateCreated]
GO
ALTER TABLE [ProjectDocuments] ADD  DEFAULT ('client') FOR [documentSource]
GO
ALTER TABLE [ProjectEfforts] ADD  DEFAULT ((1)) FOR [effortRankValue]
GO
ALTER TABLE [ProjectMethods] ADD  CONSTRAINT [DF_ProjectMethods_otherDetailFlag]  DEFAULT ('False') FOR [otherDetailFlag]
GO
ALTER TABLE [ProjectPeopleAllocations] ADD  CONSTRAINT [DF_ProjectPeopleRoles_dateCreated]  DEFAULT (getdate()) FOR [dateCreated]
GO
ALTER TABLE [Projects] ADD  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [Projects] ADD  CONSTRAINT [DF_Projects_projectDuration]  DEFAULT ((4)) FOR [projectDuration]
GO
ALTER TABLE [Projects] ADD  CONSTRAINT [DF_Projects_projectSponsorAgreement]  DEFAULT ('False') FOR [projectSponsorAgreement]
GO
ALTER TABLE [Projects] ADD  DEFAULT ('SP2') FOR [projectSemester]
GO
ALTER TABLE [Projects] ADD  DEFAULT (datepart(year,getdate())) FOR [projectYear]
GO
ALTER TABLE [Projects] ADD  DEFAULT ((100)) FOR [projectSequenceNo]
GO
ALTER TABLE [Projects] ADD  DEFAULT ('u') FOR [honoursUndergrad]
GO
ALTER TABLE [Projects] ADD  DEFAULT ('False') FOR [requirementsMet]
GO
ALTER TABLE [Projects] ADD  CONSTRAINT [DF_Projects_dateEntered]  DEFAULT (getdate()) FOR [dateCreated]
GO
ALTER TABLE [Projects] ADD  DEFAULT ('False') FOR [austCitizenOnly]
GO
ALTER TABLE [Projects] ADD  DEFAULT ((1)) FOR [studentsReq]
GO
ALTER TABLE [Students] ADD  DEFAULT ('N') FOR [international]
GO
ALTER TABLE [Students] ADD  DEFAULT ('False') FOR [externalStudent]
GO
ALTER TABLE [AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [Clients]  WITH CHECK ADD  CONSTRAINT [FK_clientID] FOREIGN KEY([clientID])
REFERENCES [AspNetUsers] ([personID])
GO
ALTER TABLE [Clients] CHECK CONSTRAINT [FK_clientID]
GO
ALTER TABLE [Memberships]  WITH CHECK ADD  CONSTRAINT [MembershipEntity_Application] FOREIGN KEY([ApplicationId])
REFERENCES [Applications] ([ApplicationId])
GO
ALTER TABLE [Memberships] CHECK CONSTRAINT [MembershipEntity_Application]
GO
ALTER TABLE [Memberships]  WITH CHECK ADD  CONSTRAINT [MembershipEntity_User] FOREIGN KEY([UserId])
REFERENCES [Users] ([UserId])
GO
ALTER TABLE [Memberships] CHECK CONSTRAINT [MembershipEntity_User]
GO
ALTER TABLE [PeopleComments]  WITH CHECK ADD  CONSTRAINT [FK_PeopleComments_People] FOREIGN KEY([personID])
REFERENCES [AspNetUsers] ([personID])
ON DELETE CASCADE
GO
ALTER TABLE [PeopleComments] CHECK CONSTRAINT [FK_PeopleComments_People]
GO
ALTER TABLE [PeopleComments]  WITH CHECK ADD  CONSTRAINT [FK_PeopleComments_People1] FOREIGN KEY([commentPersonID])
REFERENCES [AspNetUsers] ([personID])
GO
ALTER TABLE [PeopleComments] CHECK CONSTRAINT [FK_PeopleComments_People1]
GO
ALTER TABLE [PeopleContacts]  WITH CHECK ADD  CONSTRAINT [FK_PeopleContacts_People] FOREIGN KEY([personID])
REFERENCES [AspNetUsers] ([personID])
GO
ALTER TABLE [PeopleContacts] CHECK CONSTRAINT [FK_PeopleContacts_People]
GO
ALTER TABLE [PlanCourses]  WITH CHECK ADD  CONSTRAINT [FK_PlanCourses_Course] FOREIGN KEY([courseId])
REFERENCES [Course] ([courseID])
GO
ALTER TABLE [PlanCourses] CHECK CONSTRAINT [FK_PlanCourses_Course]
GO
ALTER TABLE [PlanCourses]  WITH CHECK ADD  CONSTRAINT [FK_PlanCourses_Plans] FOREIGN KEY([planId])
REFERENCES [Plans] ([planId])
GO
ALTER TABLE [PlanCourses] CHECK CONSTRAINT [FK_PlanCourses_Plans]
GO
ALTER TABLE [PriorityProjects]  WITH CHECK ADD  CONSTRAINT [FK_PriorityProjects_Projects] FOREIGN KEY([projectID])
REFERENCES [Projects] ([projectID])
ON DELETE CASCADE
GO
ALTER TABLE [PriorityProjects] CHECK CONSTRAINT [FK_PriorityProjects_Projects]
GO
ALTER TABLE [PriorityProjects]  WITH CHECK ADD  CONSTRAINT [FK_projectCreatorID] FOREIGN KEY([priorityCreatorID])
REFERENCES [AspNetUsers] ([personID])
GO
ALTER TABLE [PriorityProjects] CHECK CONSTRAINT [FK_projectCreatorID]
GO
ALTER TABLE [Profiles]  WITH CHECK ADD  CONSTRAINT [ProfileEntity_User] FOREIGN KEY([UserId])
REFERENCES [Users] ([UserId])
GO
ALTER TABLE [Profiles] CHECK CONSTRAINT [ProfileEntity_User]
GO
ALTER TABLE [ProjectDocuments]  WITH CHECK ADD  CONSTRAINT [FK_Projects_ProjectDocuments] FOREIGN KEY([projectID])
REFERENCES [Projects] ([projectID])
GO
ALTER TABLE [ProjectDocuments] CHECK CONSTRAINT [FK_Projects_ProjectDocuments]
GO
ALTER TABLE [ProjectEffortsApplied]  WITH CHECK ADD  CONSTRAINT [FK_ProjectEffortsApplied_ProjectMethods] FOREIGN KEY([effortID])
REFERENCES [ProjectEfforts] ([effortID])
GO
ALTER TABLE [ProjectEffortsApplied] CHECK CONSTRAINT [FK_ProjectEffortsApplied_ProjectMethods]
GO
ALTER TABLE [ProjectEffortsApplied]  WITH CHECK ADD  CONSTRAINT [FK_ProjectEffortsApplied_Projects] FOREIGN KEY([projectID])
REFERENCES [Projects] ([projectID])
GO
ALTER TABLE [ProjectEffortsApplied] CHECK CONSTRAINT [FK_ProjectEffortsApplied_Projects]
GO
ALTER TABLE [ProjectMethodsApplied]  WITH CHECK ADD  CONSTRAINT [FK_ProjectMethodsApplied_ProjectMethods] FOREIGN KEY([methodID])
REFERENCES [ProjectMethods] ([methodID])
GO
ALTER TABLE [ProjectMethodsApplied] CHECK CONSTRAINT [FK_ProjectMethodsApplied_ProjectMethods]
GO
ALTER TABLE [ProjectMethodsApplied]  WITH CHECK ADD  CONSTRAINT [FK_ProjectMethodsApplied_Projects] FOREIGN KEY([projectID])
REFERENCES [Projects] ([projectID])
GO
ALTER TABLE [ProjectMethodsApplied] CHECK CONSTRAINT [FK_ProjectMethodsApplied_Projects]
GO
ALTER TABLE [ProjectPeopleAllocations]  WITH CHECK ADD  CONSTRAINT [FK_ProjectPeopleAllocations_People] FOREIGN KEY([personID])
REFERENCES [AspNetUsers] ([personID])
GO
ALTER TABLE [ProjectPeopleAllocations] CHECK CONSTRAINT [FK_ProjectPeopleAllocations_People]
GO
ALTER TABLE [ProjectPeopleAllocations]  WITH CHECK ADD  CONSTRAINT [FK_ProjectPeopleAllocations_Projects] FOREIGN KEY([projectID])
REFERENCES [Projects] ([projectID])
ON DELETE CASCADE
GO
ALTER TABLE [ProjectPeopleAllocations] CHECK CONSTRAINT [FK_ProjectPeopleAllocations_Projects]
GO
ALTER TABLE [Projects]  WITH CHECK ADD  CONSTRAINT [FK_Projects_ProjectStatus] FOREIGN KEY([projectStatus])
REFERENCES [ProjectStatus] ([ProjectStatusId])
ON DELETE CASCADE
GO
ALTER TABLE [Projects] CHECK CONSTRAINT [FK_Projects_ProjectStatus]
GO
ALTER TABLE [Projects]  WITH CHECK ADD  CONSTRAINT [FK_projectsCreatorID] FOREIGN KEY([projectCreatorID])
REFERENCES [AspNetUsers] ([personID])
ON DELETE CASCADE
GO
ALTER TABLE [Projects] CHECK CONSTRAINT [FK_projectsCreatorID]
GO
ALTER TABLE [Roles]  WITH CHECK ADD  CONSTRAINT [RoleEntity_Application] FOREIGN KEY([ApplicationId])
REFERENCES [Applications] ([ApplicationId])
GO
ALTER TABLE [Roles] CHECK CONSTRAINT [RoleEntity_Application]
GO
ALTER TABLE [Staff]  WITH CHECK ADD  CONSTRAINT [FK_staffID] FOREIGN KEY([staffID])
REFERENCES [AspNetUsers] ([personID])
GO
ALTER TABLE [Staff] CHECK CONSTRAINT [FK_staffID]
GO
ALTER TABLE [StudentCourses]  WITH CHECK ADD  CONSTRAINT [FK_StudentCourses_Course] FOREIGN KEY([courseID])
REFERENCES [Course] ([courseID])
ON DELETE CASCADE
GO
ALTER TABLE [StudentCourses] CHECK CONSTRAINT [FK_StudentCourses_Course]
GO
ALTER TABLE [StudentCourses]  WITH CHECK ADD  CONSTRAINT [FK_StudentCourses_Students] FOREIGN KEY([studentID])
REFERENCES [Students] ([studentID])
ON DELETE CASCADE
GO
ALTER TABLE [StudentCourses] CHECK CONSTRAINT [FK_StudentCourses_Students]
GO
ALTER TABLE [StudentProjectRanking]  WITH CHECK ADD  CONSTRAINT [FK_StudentProjectRanking_Projects] FOREIGN KEY([projectID])
REFERENCES [Projects] ([projectID])
GO
ALTER TABLE [StudentProjectRanking] CHECK CONSTRAINT [FK_StudentProjectRanking_Projects]
GO
ALTER TABLE [StudentProjectRanking]  WITH CHECK ADD  CONSTRAINT [FK_StudentProjectRanking_Students] FOREIGN KEY([studentID])
REFERENCES [Students] ([studentID])
GO
ALTER TABLE [StudentProjectRanking] CHECK CONSTRAINT [FK_StudentProjectRanking_Students]
GO
ALTER TABLE [Students]  WITH CHECK ADD  CONSTRAINT [FK_planId] FOREIGN KEY([planId])
REFERENCES [Plans] ([planId])
GO
ALTER TABLE [Students] CHECK CONSTRAINT [FK_planId]
GO
ALTER TABLE [Students]  WITH CHECK ADD  CONSTRAINT [FK_studentID] FOREIGN KEY([studentID])
REFERENCES [AspNetUsers] ([personID])
ON DELETE CASCADE
GO
ALTER TABLE [Students] CHECK CONSTRAINT [FK_studentID]
GO
ALTER TABLE [Users]  WITH CHECK ADD  CONSTRAINT [User_Application] FOREIGN KEY([ApplicationId])
REFERENCES [Applications] ([ApplicationId])
GO
ALTER TABLE [Users] CHECK CONSTRAINT [User_Application]
GO
ALTER TABLE [UsersInRoles]  WITH CHECK ADD  CONSTRAINT [UsersInRole_Role] FOREIGN KEY([RoleId])
REFERENCES [Roles] ([RoleId])
GO
ALTER TABLE [UsersInRoles] CHECK CONSTRAINT [UsersInRole_Role]
GO
ALTER TABLE [UsersInRoles]  WITH CHECK ADD  CONSTRAINT [UsersInRole_User] FOREIGN KEY([UserId])
REFERENCES [Users] ([UserId])
GO
ALTER TABLE [UsersInRoles] CHECK CONSTRAINT [UsersInRole_User]
GO
ALTER TABLE [ProjectDocuments]  WITH CHECK ADD  CONSTRAINT [CHECK_documentRecipient] CHECK  (([documentSource]='client' OR [documentSource]='additional'))
GO
ALTER TABLE [ProjectDocuments] CHECK CONSTRAINT [CHECK_documentRecipient]
GO
ALTER TABLE [Projects]  WITH CHECK ADD  CONSTRAINT [Check_HonsUndergrad] CHECK  (([honoursUndergrad]='u' OR [honoursUndergrad]='h'))
GO
ALTER TABLE [Projects] CHECK CONSTRAINT [Check_HonsUndergrad]
GO
ALTER TABLE [Projects]  WITH CHECK ADD  CONSTRAINT [Check_Students] CHECK  (([studentsReq]>=(1) AND [studentsReq]<=(10)))
GO
ALTER TABLE [Projects] CHECK CONSTRAINT [Check_Students]
GO
