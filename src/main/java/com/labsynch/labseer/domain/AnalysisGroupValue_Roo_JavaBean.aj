// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.AnalysisGroupState;
import com.labsynch.labseer.domain.AnalysisGroupValue;

privileged aspect AnalysisGroupValue_Roo_JavaBean {
    
    public AnalysisGroupState AnalysisGroupValue.getLsState() {
        return this.lsState;
    }
    
    public void AnalysisGroupValue.setLsState(AnalysisGroupState lsState) {
        this.lsState = lsState;
    }
    
}
