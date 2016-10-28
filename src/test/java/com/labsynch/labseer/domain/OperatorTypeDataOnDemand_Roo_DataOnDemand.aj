// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.OperatorType;
import com.labsynch.labseer.domain.OperatorTypeDataOnDemand;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import org.springframework.stereotype.Component;

privileged aspect OperatorTypeDataOnDemand_Roo_DataOnDemand {
    
    declare @type: OperatorTypeDataOnDemand: @Component;
    
    private Random OperatorTypeDataOnDemand.rnd = new SecureRandom();
    
    private List<OperatorType> OperatorTypeDataOnDemand.data;
    
    public OperatorType OperatorTypeDataOnDemand.getNewTransientOperatorType(int index) {
        OperatorType obj = new OperatorType();
        setTypeName(obj, index);
        return obj;
    }
    
    public void OperatorTypeDataOnDemand.setTypeName(OperatorType obj, int index) {
        String typeName = "typeName_" + index;
        if (typeName.length() > 25) {
            typeName = new Random().nextInt(10) + typeName.substring(1, 25);
        }
        obj.setTypeName(typeName);
    }
    
    public OperatorType OperatorTypeDataOnDemand.getSpecificOperatorType(int index) {
        init();
        if (index < 0) {
            index = 0;
        }
        if (index > (data.size() - 1)) {
            index = data.size() - 1;
        }
        OperatorType obj = data.get(index);
        Long id = obj.getId();
        return OperatorType.findOperatorType(id);
    }
    
    public OperatorType OperatorTypeDataOnDemand.getRandomOperatorType() {
        init();
        OperatorType obj = data.get(rnd.nextInt(data.size()));
        Long id = obj.getId();
        return OperatorType.findOperatorType(id);
    }
    
    public boolean OperatorTypeDataOnDemand.modifyOperatorType(OperatorType obj) {
        return false;
    }
    
    public void OperatorTypeDataOnDemand.init() {
        int from = 0;
        int to = 10;
        data = OperatorType.findOperatorTypeEntries(from, to);
        if (data == null) {
            throw new IllegalStateException("Find entries implementation for 'OperatorType' illegally returned null");
        }
        if (!data.isEmpty()) {
            return;
        }
        
        data = new ArrayList<OperatorType>();
        for (int i = 0; i < 10; i++) {
            OperatorType obj = getNewTransientOperatorType(i);
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
