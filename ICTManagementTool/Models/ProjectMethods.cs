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
    
    public partial class ProjectMethods
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public ProjectMethods()
        {
            this.ProjectMethodsApplied = new HashSet<ProjectMethodsApplied>();
        }
    
        public int methodID { get; set; }
        public string methodDescription { get; set; }
        public bool otherDetailFlag { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        protected virtual ICollection<ProjectMethodsApplied> ProjectMethodsApplied { get; set; }
    }
}
