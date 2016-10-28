// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.LsTag;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.springframework.transaction.annotation.Transactional;

privileged aspect LsTag_Roo_Jpa_ActiveRecord {
    
    @PersistenceContext
    transient EntityManager LsTag.entityManager;
    
    public static final EntityManager LsTag.entityManager() {
        EntityManager em = new LsTag().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long LsTag.countLsTags() {
        return entityManager().createQuery("SELECT COUNT(o) FROM LsTag o", Long.class).getSingleResult();
    }
    
    public static List<LsTag> LsTag.findAllLsTags() {
        return entityManager().createQuery("SELECT o FROM LsTag o", LsTag.class).getResultList();
    }
    
    public static LsTag LsTag.findLsTag(Long id) {
        if (id == null) return null;
        return entityManager().find(LsTag.class, id);
    }
    
    public static List<LsTag> LsTag.findLsTagEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM LsTag o", LsTag.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
    @Transactional
    public void LsTag.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void LsTag.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            LsTag attached = LsTag.findLsTag(this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void LsTag.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public void LsTag.clear() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.clear();
    }
    
    @Transactional
    public LsTag LsTag.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        LsTag merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
}
