// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.InteractionKind;
import com.labsynch.labseer.domain.InteractionType;

privileged aspect InteractionKind_Roo_JavaBean {
    
    public InteractionType InteractionKind.getLsType() {
        return this.lsType;
    }
    
    public void InteractionKind.setLsType(InteractionType lsType) {
        this.lsType = lsType;
    }
    
    public String InteractionKind.getKindName() {
        return this.kindName;
    }
    
    public void InteractionKind.setKindName(String kindName) {
        this.kindName = kindName;
    }
    
    public String InteractionKind.getLsTypeAndKind() {
        return this.lsTypeAndKind;
    }
    
    public void InteractionKind.setLsTypeAndKind(String lsTypeAndKind) {
        this.lsTypeAndKind = lsTypeAndKind;
    }
    
}
