// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.LsSeqAnlGrp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Version;

privileged aspect LsSeqAnlGrp_Roo_Jpa_Entity {
    
    declare @type: LsSeqAnlGrp: @Entity;
    
    @Id
    @SequenceGenerator(name = "lsSeqAnlGrpGen", sequenceName = "LSSEQ_ANLGRP_PKSEQ")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "lsSeqAnlGrpGen")
    @Column(name = "id")
    private Long LsSeqAnlGrp.id;
    
    @Version
    @Column(name = "version")
    private Integer LsSeqAnlGrp.version;
    
    public Long LsSeqAnlGrp.getId() {
        return this.id;
    }
    
    public void LsSeqAnlGrp.setId(Long id) {
        this.id = id;
    }
    
    public Integer LsSeqAnlGrp.getVersion() {
        return this.version;
    }
    
    public void LsSeqAnlGrp.setVersion(Integer version) {
        this.version = version;
    }
    
}
