// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.UncertaintyKind;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Version;

privileged aspect UncertaintyKind_Roo_Jpa_Entity {
    
    declare @type: UncertaintyKind: @Entity;
    
    @Id
    @SequenceGenerator(name = "uncertaintyKindGen", sequenceName = "UNCERTAINTY_KIND_PKSEQ")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "uncertaintyKindGen")
    @Column(name = "id")
    private Long UncertaintyKind.id;
    
    @Version
    @Column(name = "version")
    private Integer UncertaintyKind.version;
    
    public Long UncertaintyKind.getId() {
        return this.id;
    }
    
    public void UncertaintyKind.setId(Long id) {
        this.id = id;
    }
    
    public Integer UncertaintyKind.getVersion() {
        return this.version;
    }
    
    public void UncertaintyKind.setVersion(Integer version) {
        this.version = version;
    }
    
}
