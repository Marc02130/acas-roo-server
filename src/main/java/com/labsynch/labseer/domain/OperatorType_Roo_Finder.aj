// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.OperatorType;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

privileged aspect OperatorType_Roo_Finder {
    
    public static TypedQuery<OperatorType> OperatorType.findOperatorTypesByTypeNameEquals(String typeName) {
        if (typeName == null || typeName.length() == 0) throw new IllegalArgumentException("The typeName argument is required");
        EntityManager em = OperatorType.entityManager();
        TypedQuery<OperatorType> q = em.createQuery("SELECT o FROM OperatorType AS o WHERE o.typeName = :typeName", OperatorType.class);
        q.setParameter("typeName", typeName);
        return q;
    }
    
}
