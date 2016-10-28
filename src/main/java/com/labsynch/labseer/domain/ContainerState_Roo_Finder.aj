// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.Container;
import com.labsynch.labseer.domain.ContainerState;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

privileged aspect ContainerState_Roo_Finder {
    
    public static TypedQuery<ContainerState> ContainerState.findContainerStatesByContainer(Container container) {
        if (container == null) throw new IllegalArgumentException("The container argument is required");
        EntityManager em = ContainerState.entityManager();
        TypedQuery<ContainerState> q = em.createQuery("SELECT o FROM ContainerState AS o WHERE o.container = :container", ContainerState.class);
        q.setParameter("container", container);
        return q;
    }
    
    public static TypedQuery<ContainerState> ContainerState.findContainerStatesByContainerAndLsKindEqualsAndIgnoredNot(Container container, String lsKind, boolean ignored) {
        if (container == null) throw new IllegalArgumentException("The container argument is required");
        if (lsKind == null || lsKind.length() == 0) throw new IllegalArgumentException("The lsKind argument is required");
        EntityManager em = ContainerState.entityManager();
        TypedQuery<ContainerState> q = em.createQuery("SELECT o FROM ContainerState AS o WHERE o.container = :container AND o.lsKind = :lsKind  AND o.ignored IS NOT :ignored", ContainerState.class);
        q.setParameter("container", container);
        q.setParameter("lsKind", lsKind);
        q.setParameter("ignored", ignored);
        return q;
    }
    
    public static TypedQuery<ContainerState> ContainerState.findContainerStatesByIgnoredNot(boolean ignored) {
        EntityManager em = ContainerState.entityManager();
        TypedQuery<ContainerState> q = em.createQuery("SELECT o FROM ContainerState AS o WHERE o.ignored IS NOT :ignored", ContainerState.class);
        q.setParameter("ignored", ignored);
        return q;
    }
    
}
