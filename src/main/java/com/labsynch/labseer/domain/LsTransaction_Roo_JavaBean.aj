// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.LsTransaction;
import java.util.Date;

privileged aspect LsTransaction_Roo_JavaBean {
    
    public String LsTransaction.getComments() {
        return this.comments;
    }
    
    public void LsTransaction.setComments(String comments) {
        this.comments = comments;
    }
    
    public Date LsTransaction.getRecordedDate() {
        return this.recordedDate;
    }
    
    public void LsTransaction.setRecordedDate(Date recordedDate) {
        this.recordedDate = recordedDate;
    }
    
}
