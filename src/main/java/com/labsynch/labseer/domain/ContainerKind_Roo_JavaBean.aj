// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.ContainerKind;
import com.labsynch.labseer.domain.ContainerType;

privileged aspect ContainerKind_Roo_JavaBean {
    
    public ContainerType ContainerKind.getLsType() {
        return this.lsType;
    }
    
    public void ContainerKind.setLsType(ContainerType lsType) {
        this.lsType = lsType;
    }
    
    public String ContainerKind.getKindName() {
        return this.kindName;
    }
    
    public void ContainerKind.setKindName(String kindName) {
        this.kindName = kindName;
    }
    
    public String ContainerKind.getLsTypeAndKind() {
        return this.lsTypeAndKind;
    }
    
    public void ContainerKind.setLsTypeAndKind(String lsTypeAndKind) {
        this.lsTypeAndKind = lsTypeAndKind;
    }
    
}
