//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ICTManagementTool.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class ProjectMethodsApplied
    {
        public int projectID { get; set; }
        public int methodID { get; set; }
        public string comment { get; set; }
    
        protected virtual ProjectMethods ProjectMethods { get; set; }
        protected virtual Projects Projects { get; set; }
    }
}