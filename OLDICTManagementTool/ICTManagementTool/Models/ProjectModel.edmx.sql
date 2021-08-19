
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 06/01/2017 23:15:04
-- Generated from EDMX file: C:\Users\glend\Desktop\50\ICTManagementTool\ICTManagementTool\Models\ProjectModel.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [ICTProjects];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK_dbo_AspNetUserClaims_dbo_AspNetUsers_UserId]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[AspNetUserClaims] DROP CONSTRAINT [FK_dbo_AspNetUserClaims_dbo_AspNetUsers_UserId];
GO
IF OBJECT_ID(N'[dbo].[FK_dbo_AspNetUserLogins_dbo_AspNetUsers_UserId]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[AspNetUserLogins] DROP CONSTRAINT [FK_dbo_AspNetUserLogins_dbo_AspNetUsers_UserId];
GO
IF OBJECT_ID(N'[dbo].[FK_dbo_AspNetUserRoles_dbo_AspNetRoles_RoleId]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[AspNetUserRoles] DROP CONSTRAINT [FK_dbo_AspNetUserRoles_dbo_AspNetRoles_RoleId];
GO
IF OBJECT_ID(N'[dbo].[FK_dbo_AspNetUserRoles_dbo_AspNetUsers_UserId]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[AspNetUserRoles] DROP CONSTRAINT [FK_dbo_AspNetUserRoles_dbo_AspNetUsers_UserId];
GO
IF OBJECT_ID(N'[dbo].[FK_PriorityProjects_Projects]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[PriorityProjects] DROP CONSTRAINT [FK_PriorityProjects_Projects];
GO
IF OBJECT_ID(N'[dbo].[FK_ProjectEffortsApplied_ProjectMethods]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ProjectEffortsApplied] DROP CONSTRAINT [FK_ProjectEffortsApplied_ProjectMethods];
GO
IF OBJECT_ID(N'[dbo].[FK_ProjectEffortsApplied_Projects]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ProjectEffortsApplied] DROP CONSTRAINT [FK_ProjectEffortsApplied_Projects];
GO
IF OBJECT_ID(N'[dbo].[FK_ProjectMethodsApplied_ProjectMethods]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ProjectMethodsApplied] DROP CONSTRAINT [FK_ProjectMethodsApplied_ProjectMethods];
GO
IF OBJECT_ID(N'[dbo].[FK_ProjectMethodsApplied_Projects]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ProjectMethodsApplied] DROP CONSTRAINT [FK_ProjectMethodsApplied_Projects];
GO
IF OBJECT_ID(N'[dbo].[FK_ProjectPeopleAllocations_Projects]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ProjectPeopleAllocations] DROP CONSTRAINT [FK_ProjectPeopleAllocations_Projects];
GO
IF OBJECT_ID(N'[dbo].[FK_Projects_ProjectDocuments]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ProjectDocuments] DROP CONSTRAINT [FK_Projects_ProjectDocuments];
GO
IF OBJECT_ID(N'[dbo].[FK_StudentCourses_Course]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[StudentCourses] DROP CONSTRAINT [FK_StudentCourses_Course];
GO
IF OBJECT_ID(N'[dbo].[FK_StudentCourses_Students]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[StudentCourses] DROP CONSTRAINT [FK_StudentCourses_Students];
GO
IF OBJECT_ID(N'[dbo].[FK_StudentProjectRanking_Projects]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[StudentProjectRanking] DROP CONSTRAINT [FK_StudentProjectRanking_Projects];
GO
IF OBJECT_ID(N'[dbo].[FK_StudentProjectRanking_Students]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[StudentProjectRanking] DROP CONSTRAINT [FK_StudentProjectRanking_Students];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[__MigrationHistory]', 'U') IS NOT NULL
    DROP TABLE [dbo].[__MigrationHistory];
GO
IF OBJECT_ID(N'[dbo].[AspNetRoles]', 'U') IS NOT NULL
    DROP TABLE [dbo].[AspNetRoles];
GO
IF OBJECT_ID(N'[dbo].[AspNetUserClaims]', 'U') IS NOT NULL
    DROP TABLE [dbo].[AspNetUserClaims];
GO
IF OBJECT_ID(N'[dbo].[AspNetUserLogins]', 'U') IS NOT NULL
    DROP TABLE [dbo].[AspNetUserLogins];
GO
IF OBJECT_ID(N'[dbo].[AspNetUserRoles]', 'U') IS NOT NULL
    DROP TABLE [dbo].[AspNetUserRoles];
GO
IF OBJECT_ID(N'[dbo].[AspNetUsers]', 'U') IS NOT NULL
    DROP TABLE [dbo].[AspNetUsers];
GO
IF OBJECT_ID(N'[dbo].[Clients]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Clients];
GO
IF OBJECT_ID(N'[dbo].[Course]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Course];
GO
IF OBJECT_ID(N'[dbo].[PeopleComments]', 'U') IS NOT NULL
    DROP TABLE [dbo].[PeopleComments];
GO
IF OBJECT_ID(N'[dbo].[PeopleContacts]', 'U') IS NOT NULL
    DROP TABLE [dbo].[PeopleContacts];
GO
IF OBJECT_ID(N'[dbo].[PriorityProjects]', 'U') IS NOT NULL
    DROP TABLE [dbo].[PriorityProjects];
GO
IF OBJECT_ID(N'[dbo].[Program]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Program];
GO
IF OBJECT_ID(N'[dbo].[ProjectDocuments]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ProjectDocuments];
GO
IF OBJECT_ID(N'[dbo].[ProjectEfforts]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ProjectEfforts];
GO
IF OBJECT_ID(N'[dbo].[ProjectEffortsApplied]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ProjectEffortsApplied];
GO
IF OBJECT_ID(N'[dbo].[ProjectMethods]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ProjectMethods];
GO
IF OBJECT_ID(N'[dbo].[ProjectMethodsApplied]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ProjectMethodsApplied];
GO
IF OBJECT_ID(N'[dbo].[ProjectPeopleAllocations]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ProjectPeopleAllocations];
GO
IF OBJECT_ID(N'[dbo].[Projects]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Projects];
GO
IF OBJECT_ID(N'[dbo].[Staff]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Staff];
GO
IF OBJECT_ID(N'[dbo].[StudentCourses]', 'U') IS NOT NULL
    DROP TABLE [dbo].[StudentCourses];
GO
IF OBJECT_ID(N'[dbo].[StudentProjectRanking]', 'U') IS NOT NULL
    DROP TABLE [dbo].[StudentProjectRanking];
GO
IF OBJECT_ID(N'[dbo].[Students]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Students];
GO
IF OBJECT_ID(N'[dbo].[sysdiagrams]', 'U') IS NOT NULL
    DROP TABLE [dbo].[sysdiagrams];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'C__MigrationHistory'
CREATE TABLE [dbo].[C__MigrationHistory] (
    [MigrationId] nvarchar(150)  NOT NULL,
    [ContextKey] nvarchar(300)  NOT NULL,
    [Model] varbinary(max)  NOT NULL,
    [ProductVersion] nvarchar(32)  NOT NULL
);
GO

-- Creating table 'AspNetRoles'
CREATE TABLE [dbo].[AspNetRoles] (
    [Id] nvarchar(128)  NOT NULL,
    [Name] nvarchar(256)  NOT NULL
);
GO

-- Creating table 'AspNetUserClaims'
CREATE TABLE [dbo].[AspNetUserClaims] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [UserId] nvarchar(128)  NOT NULL,
    [ClaimType] nvarchar(max)  NULL,
    [ClaimValue] nvarchar(max)  NULL
);
GO

-- Creating table 'AspNetUserLogins'
CREATE TABLE [dbo].[AspNetUserLogins] (
    [LoginProvider] nvarchar(128)  NOT NULL,
    [ProviderKey] nvarchar(128)  NOT NULL,
    [UserId] nvarchar(128)  NOT NULL
);
GO

-- Creating table 'AspNetUsers'
CREATE TABLE [dbo].[AspNetUsers] (
    [Id] nvarchar(128)  NOT NULL,
    [personID] int  NOT NULL,
    [dateCreated] datetime  NOT NULL,
    [Email] nvarchar(256)  NULL,
    [EmailConfirmed] bit  NOT NULL,
    [PasswordHash] nvarchar(max)  NULL,
    [SecurityStamp] nvarchar(max)  NULL,
    [PhoneNumber] nvarchar(max)  NULL,
    [PhoneNumberConfirmed] bit  NOT NULL,
    [TwoFactorEnabled] bit  NOT NULL,
    [LockoutEndDateUtc] datetime  NULL,
    [LockoutEnabled] bit  NOT NULL,
    [AccessFailedCount] int  NOT NULL,
    [UserName] nvarchar(256)  NOT NULL,
    [firstName] nvarchar(max)  NULL,
    [lastName] nvarchar(max)  NULL
);
GO

-- Creating table 'Clients'
CREATE TABLE [dbo].[Clients] (
    [clientID] int  NOT NULL,
    [companyName] varchar(100)  NULL
);
GO

-- Creating table 'Course'
CREATE TABLE [dbo].[Course] (
    [courseID] varchar(10)  NOT NULL,
    [courseName] varchar(50)  NULL,
    [courseCode] varchar(10)  NULL
);
GO

-- Creating table 'PeopleComments'
CREATE TABLE [dbo].[PeopleComments] (
    [commentID] int IDENTITY(1,1) NOT NULL,
    [personID] int  NOT NULL,
    [commentDate] datetime  NOT NULL,
    [commentPersonID] int  NOT NULL,
    [comment] varchar(500)  NOT NULL,
    [flag] bit  NOT NULL
);
GO

-- Creating table 'PeopleContacts'
CREATE TABLE [dbo].[PeopleContacts] (
    [personID] int  NOT NULL,
    [contactMethod] varchar(15)  NOT NULL,
    [contactValue] varchar(100)  NOT NULL,
    [preferred] bit  NOT NULL,
    [dateCreated] datetime  NOT NULL,
    [dateEnded] datetime  NULL
);
GO

-- Creating table 'PriorityProjects'
CREATE TABLE [dbo].[PriorityProjects] (
    [projectID] int  NOT NULL,
    [dateCreated] datetime  NOT NULL,
    [priorityLevel] varchar(3)  NOT NULL,
    [priorityReason] varchar(500)  NULL,
    [priorityCreatorID] int  NULL
);
GO

-- Creating table 'Program'
CREATE TABLE [dbo].[Program] (
    [programCode] varchar(10)  NOT NULL,
    [programDescription] varchar(100)  NULL,
    [programDirectorName] varchar(50)  NULL
);
GO

-- Creating table 'ProjectDocuments'
CREATE TABLE [dbo].[ProjectDocuments] (
    [projectDocumentID] int IDENTITY(1,1) NOT NULL,
    [projectID] int  NOT NULL,
    [documentLink] varchar(100)  NOT NULL,
    [documentTitle] varchar(50)  NOT NULL
);
GO

-- Creating table 'ProjectMethods'
CREATE TABLE [dbo].[ProjectMethods] (
    [methodID] int IDENTITY(1,1) NOT NULL,
    [methodDescription] varchar(100)  NOT NULL,
    [otherDetailFlag] bit  NOT NULL
);
GO

-- Creating table 'ProjectMethodsApplied'
CREATE TABLE [dbo].[ProjectMethodsApplied] (
    [projectID] int  NOT NULL,
    [methodID] int  NOT NULL,
    [comment] varchar(100)  NULL
);
GO

-- Creating table 'ProjectPeopleAllocations'
CREATE TABLE [dbo].[ProjectPeopleAllocations] (
    [projectID] int  NOT NULL,
    [personID] int  NOT NULL,
    [personRole] varchar(15)  NOT NULL,
    [dateCreated] datetime  NOT NULL,
    [creatorID] int  NOT NULL,
    [creatorComment] varchar(500)  NULL
);
GO

-- Creating table 'Projects'
CREATE TABLE [dbo].[Projects] (
    [projectID] int IDENTITY(1,1) NOT NULL,
    [projectTitle] varchar(250)  NULL,
    [projectScope] varchar(max)  NULL,
    [projectOutcomes] varchar(max)  NULL,
    [projectDuration] int  NOT NULL,
    [projectPlacementRequirements] varchar(500)  NULL,
    [projectSponsorAgreement] bit  NOT NULL,
    [projectStatus] varchar(15)  NOT NULL,
    [projectStatusComment] varchar(500)  NULL,
    [projectStatusChangeDate] datetime  NULL,
    [projectSemester] char(3)  NULL,
    [projectSemesterCode] varchar(10)  NULL,
    [projectYear] int  NOT NULL,
    [projectSequenceNo] int  NULL,
    [honoursUndergrad] varchar(6)  NOT NULL,
    [requirementsMet] bit  NOT NULL,
    [projectCreatorID] int  NOT NULL,
    [dateCreated] datetime  NOT NULL,
    [projectEffortRequirements] char(10)  NULL
);
GO

-- Creating table 'Staff'
CREATE TABLE [dbo].[Staff] (
    [staffID] int  NOT NULL,
    [uniStaffID] varchar(12)  NULL,
    [username] varchar(12)  NULL,
    [dateEnded] datetime  NULL
);
GO

-- Creating table 'StudentCourses'
CREATE TABLE [dbo].[StudentCourses] (
    [studentCourseID] int IDENTITY(1,1) NOT NULL,
    [studentID] int  NOT NULL,
    [courseID] varchar(10)  NOT NULL,
    [semester] varchar(5)  NULL,
    [year] int  NULL,
    [grade] varchar(5)  NULL,
    [mark] decimal(4,1)  NULL
);
GO

-- Creating table 'StudentProjectRanking'
CREATE TABLE [dbo].[StudentProjectRanking] (
    [studentID] int  NOT NULL,
    [projectID] int  NOT NULL,
    [projectRank] int  NOT NULL
);
GO

-- Creating table 'Students'
CREATE TABLE [dbo].[Students] (
    [studentID] int  NOT NULL,
    [uniUserName] varchar(12)  NOT NULL,
    [uniStudentID] varchar(12)  NOT NULL,
    [programCode] varchar(10)  NULL,
    [programStream] varchar(10)  NULL,
    [gpa] decimal(3,2)  NULL,
    [year] int  NOT NULL,
    [semester] char(3)  NOT NULL,
    [dateEnded] datetime  NULL
);
GO

-- Creating table 'sysdiagrams'
CREATE TABLE [dbo].[sysdiagrams] (
    [name] nvarchar(128)  NOT NULL,
    [principal_id] int  NOT NULL,
    [diagram_id] int IDENTITY(1,1) NOT NULL,
    [version] int  NULL,
    [definition] varbinary(max)  NULL
);
GO

-- Creating table 'ProjectEfforts'
CREATE TABLE [dbo].[ProjectEfforts] (
    [effortID] int IDENTITY(1,1) NOT NULL,
    [effortDescription] varchar(100)  NOT NULL
);
GO

-- Creating table 'ProjectEffortsApplied'
CREATE TABLE [dbo].[ProjectEffortsApplied] (
    [projectEffortsAppliedID] int IDENTITY(1,1) NOT NULL,
    [projectID] int  NOT NULL,
    [effortID] int  NOT NULL,
    [comment] varchar(100)  NULL,
    [hours] int  NULL
);
GO

-- Creating table 'AspNetUserRoles'
CREATE TABLE [dbo].[AspNetUserRoles] (
    [AspNetRoles_Id] nvarchar(128)  NOT NULL,
    [AspNetUsers_Id] nvarchar(128)  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [MigrationId], [ContextKey] in table 'C__MigrationHistory'
ALTER TABLE [dbo].[C__MigrationHistory]
ADD CONSTRAINT [PK_C__MigrationHistory]
    PRIMARY KEY CLUSTERED ([MigrationId], [ContextKey] ASC);
GO

-- Creating primary key on [Id] in table 'AspNetRoles'
ALTER TABLE [dbo].[AspNetRoles]
ADD CONSTRAINT [PK_AspNetRoles]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'AspNetUserClaims'
ALTER TABLE [dbo].[AspNetUserClaims]
ADD CONSTRAINT [PK_AspNetUserClaims]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [LoginProvider], [ProviderKey], [UserId] in table 'AspNetUserLogins'
ALTER TABLE [dbo].[AspNetUserLogins]
ADD CONSTRAINT [PK_AspNetUserLogins]
    PRIMARY KEY CLUSTERED ([LoginProvider], [ProviderKey], [UserId] ASC);
GO

-- Creating primary key on [Id] in table 'AspNetUsers'
ALTER TABLE [dbo].[AspNetUsers]
ADD CONSTRAINT [PK_AspNetUsers]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [clientID] in table 'Clients'
ALTER TABLE [dbo].[Clients]
ADD CONSTRAINT [PK_Clients]
    PRIMARY KEY CLUSTERED ([clientID] ASC);
GO

-- Creating primary key on [courseID] in table 'Course'
ALTER TABLE [dbo].[Course]
ADD CONSTRAINT [PK_Course]
    PRIMARY KEY CLUSTERED ([courseID] ASC);
GO

-- Creating primary key on [commentID] in table 'PeopleComments'
ALTER TABLE [dbo].[PeopleComments]
ADD CONSTRAINT [PK_PeopleComments]
    PRIMARY KEY CLUSTERED ([commentID] ASC);
GO

-- Creating primary key on [personID], [contactMethod], [contactValue] in table 'PeopleContacts'
ALTER TABLE [dbo].[PeopleContacts]
ADD CONSTRAINT [PK_PeopleContacts]
    PRIMARY KEY CLUSTERED ([personID], [contactMethod], [contactValue] ASC);
GO

-- Creating primary key on [projectID], [dateCreated] in table 'PriorityProjects'
ALTER TABLE [dbo].[PriorityProjects]
ADD CONSTRAINT [PK_PriorityProjects]
    PRIMARY KEY CLUSTERED ([projectID], [dateCreated] ASC);
GO

-- Creating primary key on [programCode] in table 'Program'
ALTER TABLE [dbo].[Program]
ADD CONSTRAINT [PK_Program]
    PRIMARY KEY CLUSTERED ([programCode] ASC);
GO

-- Creating primary key on [projectDocumentID] in table 'ProjectDocuments'
ALTER TABLE [dbo].[ProjectDocuments]
ADD CONSTRAINT [PK_ProjectDocuments]
    PRIMARY KEY CLUSTERED ([projectDocumentID] ASC);
GO

-- Creating primary key on [methodID] in table 'ProjectMethods'
ALTER TABLE [dbo].[ProjectMethods]
ADD CONSTRAINT [PK_ProjectMethods]
    PRIMARY KEY CLUSTERED ([methodID] ASC);
GO

-- Creating primary key on [projectID], [methodID] in table 'ProjectMethodsApplied'
ALTER TABLE [dbo].[ProjectMethodsApplied]
ADD CONSTRAINT [PK_ProjectMethodsApplied]
    PRIMARY KEY CLUSTERED ([projectID], [methodID] ASC);
GO

-- Creating primary key on [projectID], [personID], [personRole] in table 'ProjectPeopleAllocations'
ALTER TABLE [dbo].[ProjectPeopleAllocations]
ADD CONSTRAINT [PK_ProjectPeopleAllocations]
    PRIMARY KEY CLUSTERED ([projectID], [personID], [personRole] ASC);
GO

-- Creating primary key on [projectID] in table 'Projects'
ALTER TABLE [dbo].[Projects]
ADD CONSTRAINT [PK_Projects]
    PRIMARY KEY CLUSTERED ([projectID] ASC);
GO

-- Creating primary key on [staffID] in table 'Staff'
ALTER TABLE [dbo].[Staff]
ADD CONSTRAINT [PK_Staff]
    PRIMARY KEY CLUSTERED ([staffID] ASC);
GO

-- Creating primary key on [studentCourseID] in table 'StudentCourses'
ALTER TABLE [dbo].[StudentCourses]
ADD CONSTRAINT [PK_StudentCourses]
    PRIMARY KEY CLUSTERED ([studentCourseID] ASC);
GO

-- Creating primary key on [studentID], [projectID] in table 'StudentProjectRanking'
ALTER TABLE [dbo].[StudentProjectRanking]
ADD CONSTRAINT [PK_StudentProjectRanking]
    PRIMARY KEY CLUSTERED ([studentID], [projectID] ASC);
GO

-- Creating primary key on [studentID] in table 'Students'
ALTER TABLE [dbo].[Students]
ADD CONSTRAINT [PK_Students]
    PRIMARY KEY CLUSTERED ([studentID] ASC);
GO

-- Creating primary key on [diagram_id] in table 'sysdiagrams'
ALTER TABLE [dbo].[sysdiagrams]
ADD CONSTRAINT [PK_sysdiagrams]
    PRIMARY KEY CLUSTERED ([diagram_id] ASC);
GO

-- Creating primary key on [effortID] in table 'ProjectEfforts'
ALTER TABLE [dbo].[ProjectEfforts]
ADD CONSTRAINT [PK_ProjectEfforts]
    PRIMARY KEY CLUSTERED ([effortID] ASC);
GO

-- Creating primary key on [projectEffortsAppliedID] in table 'ProjectEffortsApplied'
ALTER TABLE [dbo].[ProjectEffortsApplied]
ADD CONSTRAINT [PK_ProjectEffortsApplied]
    PRIMARY KEY CLUSTERED ([projectEffortsAppliedID] ASC);
GO

-- Creating primary key on [AspNetRoles_Id], [AspNetUsers_Id] in table 'AspNetUserRoles'
ALTER TABLE [dbo].[AspNetUserRoles]
ADD CONSTRAINT [PK_AspNetUserRoles]
    PRIMARY KEY CLUSTERED ([AspNetRoles_Id], [AspNetUsers_Id] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [UserId] in table 'AspNetUserClaims'
ALTER TABLE [dbo].[AspNetUserClaims]
ADD CONSTRAINT [FK_dbo_AspNetUserClaims_dbo_AspNetUsers_UserId]
    FOREIGN KEY ([UserId])
    REFERENCES [dbo].[AspNetUsers]
        ([Id])
    ON DELETE CASCADE ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_dbo_AspNetUserClaims_dbo_AspNetUsers_UserId'
CREATE INDEX [IX_FK_dbo_AspNetUserClaims_dbo_AspNetUsers_UserId]
ON [dbo].[AspNetUserClaims]
    ([UserId]);
GO

-- Creating foreign key on [UserId] in table 'AspNetUserLogins'
ALTER TABLE [dbo].[AspNetUserLogins]
ADD CONSTRAINT [FK_dbo_AspNetUserLogins_dbo_AspNetUsers_UserId]
    FOREIGN KEY ([UserId])
    REFERENCES [dbo].[AspNetUsers]
        ([Id])
    ON DELETE CASCADE ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_dbo_AspNetUserLogins_dbo_AspNetUsers_UserId'
CREATE INDEX [IX_FK_dbo_AspNetUserLogins_dbo_AspNetUsers_UserId]
ON [dbo].[AspNetUserLogins]
    ([UserId]);
GO

-- Creating foreign key on [courseID] in table 'StudentCourses'
ALTER TABLE [dbo].[StudentCourses]
ADD CONSTRAINT [FK_StudentCourses_Course]
    FOREIGN KEY ([courseID])
    REFERENCES [dbo].[Course]
        ([courseID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_StudentCourses_Course'
CREATE INDEX [IX_FK_StudentCourses_Course]
ON [dbo].[StudentCourses]
    ([courseID]);
GO

-- Creating foreign key on [projectID] in table 'PriorityProjects'
ALTER TABLE [dbo].[PriorityProjects]
ADD CONSTRAINT [FK_PriorityProjects_Projects]
    FOREIGN KEY ([projectID])
    REFERENCES [dbo].[Projects]
        ([projectID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [projectID] in table 'ProjectDocuments'
ALTER TABLE [dbo].[ProjectDocuments]
ADD CONSTRAINT [FK_Projects_ProjectDocuments]
    FOREIGN KEY ([projectID])
    REFERENCES [dbo].[Projects]
        ([projectID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_Projects_ProjectDocuments'
CREATE INDEX [IX_FK_Projects_ProjectDocuments]
ON [dbo].[ProjectDocuments]
    ([projectID]);
GO

-- Creating foreign key on [methodID] in table 'ProjectMethodsApplied'
ALTER TABLE [dbo].[ProjectMethodsApplied]
ADD CONSTRAINT [FK_ProjectMethodsApplied_ProjectMethods]
    FOREIGN KEY ([methodID])
    REFERENCES [dbo].[ProjectMethods]
        ([methodID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ProjectMethodsApplied_ProjectMethods'
CREATE INDEX [IX_FK_ProjectMethodsApplied_ProjectMethods]
ON [dbo].[ProjectMethodsApplied]
    ([methodID]);
GO

-- Creating foreign key on [projectID] in table 'ProjectMethodsApplied'
ALTER TABLE [dbo].[ProjectMethodsApplied]
ADD CONSTRAINT [FK_ProjectMethodsApplied_Projects]
    FOREIGN KEY ([projectID])
    REFERENCES [dbo].[Projects]
        ([projectID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [projectID] in table 'ProjectPeopleAllocations'
ALTER TABLE [dbo].[ProjectPeopleAllocations]
ADD CONSTRAINT [FK_ProjectPeopleAllocations_Projects]
    FOREIGN KEY ([projectID])
    REFERENCES [dbo].[Projects]
        ([projectID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [projectID] in table 'StudentProjectRanking'
ALTER TABLE [dbo].[StudentProjectRanking]
ADD CONSTRAINT [FK_StudentProjectRanking_Projects]
    FOREIGN KEY ([projectID])
    REFERENCES [dbo].[Projects]
        ([projectID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_StudentProjectRanking_Projects'
CREATE INDEX [IX_FK_StudentProjectRanking_Projects]
ON [dbo].[StudentProjectRanking]
    ([projectID]);
GO

-- Creating foreign key on [studentID] in table 'StudentCourses'
ALTER TABLE [dbo].[StudentCourses]
ADD CONSTRAINT [FK_StudentCourses_Students]
    FOREIGN KEY ([studentID])
    REFERENCES [dbo].[Students]
        ([studentID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_StudentCourses_Students'
CREATE INDEX [IX_FK_StudentCourses_Students]
ON [dbo].[StudentCourses]
    ([studentID]);
GO

-- Creating foreign key on [studentID] in table 'StudentProjectRanking'
ALTER TABLE [dbo].[StudentProjectRanking]
ADD CONSTRAINT [FK_StudentProjectRanking_Students]
    FOREIGN KEY ([studentID])
    REFERENCES [dbo].[Students]
        ([studentID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [AspNetRoles_Id] in table 'AspNetUserRoles'
ALTER TABLE [dbo].[AspNetUserRoles]
ADD CONSTRAINT [FK_AspNetUserRoles_AspNetRoles]
    FOREIGN KEY ([AspNetRoles_Id])
    REFERENCES [dbo].[AspNetRoles]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [AspNetUsers_Id] in table 'AspNetUserRoles'
ALTER TABLE [dbo].[AspNetUserRoles]
ADD CONSTRAINT [FK_AspNetUserRoles_AspNetUsers]
    FOREIGN KEY ([AspNetUsers_Id])
    REFERENCES [dbo].[AspNetUsers]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_AspNetUserRoles_AspNetUsers'
CREATE INDEX [IX_FK_AspNetUserRoles_AspNetUsers]
ON [dbo].[AspNetUserRoles]
    ([AspNetUsers_Id]);
GO

-- Creating foreign key on [effortID] in table 'ProjectEffortsApplied'
ALTER TABLE [dbo].[ProjectEffortsApplied]
ADD CONSTRAINT [FK_ProjectEffortsApplied_ProjectMethods]
    FOREIGN KEY ([effortID])
    REFERENCES [dbo].[ProjectEfforts]
        ([effortID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ProjectEffortsApplied_ProjectMethods'
CREATE INDEX [IX_FK_ProjectEffortsApplied_ProjectMethods]
ON [dbo].[ProjectEffortsApplied]
    ([effortID]);
GO

-- Creating foreign key on [projectID] in table 'ProjectEffortsApplied'
ALTER TABLE [dbo].[ProjectEffortsApplied]
ADD CONSTRAINT [FK_ProjectEffortsApplied_Projects]
    FOREIGN KEY ([projectID])
    REFERENCES [dbo].[Projects]
        ([projectID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ProjectEffortsApplied_Projects'
CREATE INDEX [IX_FK_ProjectEffortsApplied_Projects]
ON [dbo].[ProjectEffortsApplied]
    ([projectID]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------