// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.LsSeqItxCntrCntr;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Version;

privileged aspect LsSeqItxCntrCntr_Roo_Jpa_Entity {
    
    declare @type: LsSeqItxCntrCntr: @Entity;
    
    @Id
    @SequenceGenerator(name = "lsSeqItxCntrCntrGen", sequenceName = "LSSEQ_ITXCNTRCNTR_PKSEQ")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "lsSeqItxCntrCntrGen")
    @Column(name = "id")
    private Long LsSeqItxCntrCntr.id;
    
    @Version
    @Column(name = "version")
    private Integer LsSeqItxCntrCntr.version;
    
    public Long LsSeqItxCntrCntr.getId() {
        return this.id;
    }
    
    public void LsSeqItxCntrCntr.setId(Long id) {
        this.id = id;
    }
    
    public Integer LsSeqItxCntrCntr.getVersion() {
        return this.version;
    }
    
    public void LsSeqItxCntrCntr.setVersion(Integer version) {
        this.version = version;
    }
    
}
