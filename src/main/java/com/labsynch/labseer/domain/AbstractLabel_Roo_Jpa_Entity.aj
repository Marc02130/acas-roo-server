// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.AbstractLabel;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.Version;

privileged aspect AbstractLabel_Roo_Jpa_Entity {
    
    declare @type: AbstractLabel: @Entity;
    
    declare @type: AbstractLabel: @Inheritance(strategy = InheritanceType.TABLE_PER_CLASS);
    
    @Version
    @Column(name = "version")
    private Integer AbstractLabel.version;
    
    public Integer AbstractLabel.getVersion() {
        return this.version;
    }
    
    public void AbstractLabel.setVersion(Integer version) {
        this.version = version;
    }
    
}
