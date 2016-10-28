// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.ExperimentType;
import com.labsynch.labseer.domain.ExperimentTypeDataOnDemand;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import org.springframework.stereotype.Component;

privileged aspect ExperimentTypeDataOnDemand_Roo_DataOnDemand {
    
    declare @type: ExperimentTypeDataOnDemand: @Component;
    
    private Random ExperimentTypeDataOnDemand.rnd = new SecureRandom();
    
    private List<ExperimentType> ExperimentTypeDataOnDemand.data;
    
    public ExperimentType ExperimentTypeDataOnDemand.getNewTransientExperimentType(int index) {
        ExperimentType obj = new ExperimentType();
        setTypeName(obj, index);
        return obj;
    }
    
    public void ExperimentTypeDataOnDemand.setTypeName(ExperimentType obj, int index) {
        String typeName = "typeName_" + index;
        if (typeName.length() > 128) {
            typeName = new Random().nextInt(10) + typeName.substring(1, 128);
        }
        obj.setTypeName(typeName);
    }
    
    public ExperimentType ExperimentTypeDataOnDemand.getSpecificExperimentType(int index) {
        init();
        if (index < 0) {
            index = 0;
        }
        if (index > (data.size() - 1)) {
            index = data.size() - 1;
        }
        ExperimentType obj = data.get(index);
        Long id = obj.getId();
        return ExperimentType.findExperimentType(id);
    }
    
    public ExperimentType ExperimentTypeDataOnDemand.getRandomExperimentType() {
        init();
        ExperimentType obj = data.get(rnd.nextInt(data.size()));
        Long id = obj.getId();
        return ExperimentType.findExperimentType(id);
    }
    
    public boolean ExperimentTypeDataOnDemand.modifyExperimentType(ExperimentType obj) {
        return false;
    }
    
    public void ExperimentTypeDataOnDemand.init() {
        int from = 0;
        int to = 10;
        data = ExperimentType.findExperimentTypeEntries(from, to);
        if (data == null) {
            throw new IllegalStateException("Find entries implementation for 'ExperimentType' illegally returned null");
        }
        if (!data.isEmpty()) {
            return;
        }
        
        data = new ArrayList<ExperimentType>();
        for (int i = 0; i < 10; i++) {
            ExperimentType obj = getNewTransientExperimentType(i);
            try {
                obj.persist();
            } catch (ConstraintViolationException e) {
                StringBuilder msg = new StringBuilder();
                for (Iterator<ConstraintViolation<?>> iter = e.getConstraintViolations().iterator(); iter.hasNext();) {
                    ConstraintViolation<?> cv = iter.next();
                    msg.append("[").append(cv.getConstraintDescriptor()).append(":").append(cv.getMessage()).append("=").append(cv.getInvalidValue()).append("]");
                }
                throw new RuntimeException(msg.toString(), e);
            }
            obj.flush();
            data.add(obj);
        }
    }
    
}
