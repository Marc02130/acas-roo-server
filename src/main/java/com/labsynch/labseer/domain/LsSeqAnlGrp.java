package com.labsynch.labseer.domain;

import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EntityManager;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.PersistenceContext;
import javax.persistence.SequenceGenerator;
import javax.persistence.Version;
import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.jpa.activerecord.RooJpaActiveRecord;
import org.springframework.transaction.annotation.Transactional;

@Entity
@Configurable
@RooJavaBean
@RooJpaActiveRecord(sequenceName = "LSSEQ_ANLGRP_PKSEQ" )
public class LsSeqAnlGrp {
	
	

	@Id
    @SequenceGenerator(name = "lsSeqAnlGrpGen", sequenceName = "LSSEQ_ANLGRP_PKSEQ")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "lsSeqAnlGrpGen")
    @Column(name = "id")
    private Long id;

	@Version
    @Column(name = "version")
    private Integer version;

	public Long getId() {
        return this.id;
    }

	public void setId(Long id) {
        this.id = id;
    }

	public Integer getVersion() {
        return this.version;
    }

	public void setVersion(Integer version) {
        this.version = version;
    }

	@PersistenceContext
    transient EntityManager entityManager;

	public static final List<String> fieldNames4OrderClauseFilter = java.util.Arrays.asList("");

	public static final EntityManager entityManager() {
        EntityManager em = new LsSeqAnlGrp().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }

	public static long countLsSeqAnlGrps() {
        return entityManager().createQuery("SELECT COUNT(o) FROM LsSeqAnlGrp o", Long.class).getSingleResult();
    }

	public static List<LsSeqAnlGrp> findAllLsSeqAnlGrps() {
        return entityManager().createQuery("SELECT o FROM LsSeqAnlGrp o", LsSeqAnlGrp.class).getResultList();
    }

	public static List<LsSeqAnlGrp> findAllLsSeqAnlGrps(String sortFieldName, String sortOrder) {
        String jpaQuery = "SELECT o FROM LsSeqAnlGrp o";
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            jpaQuery = jpaQuery + " ORDER BY " + sortFieldName;
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                jpaQuery = jpaQuery + " " + sortOrder;
            }
        }
        return entityManager().createQuery(jpaQuery, LsSeqAnlGrp.class).getResultList();
    }

	public static LsSeqAnlGrp findLsSeqAnlGrp(Long id) {
        if (id == null) return null;
        return entityManager().find(LsSeqAnlGrp.class, id);
    }

	public static List<LsSeqAnlGrp> findLsSeqAnlGrpEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM LsSeqAnlGrp o", LsSeqAnlGrp.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }

	public static List<LsSeqAnlGrp> findLsSeqAnlGrpEntries(int firstResult, int maxResults, String sortFieldName, String sortOrder) {
        String jpaQuery = "SELECT o FROM LsSeqAnlGrp o";
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            jpaQuery = jpaQuery + " ORDER BY " + sortFieldName;
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                jpaQuery = jpaQuery + " " + sortOrder;
            }
        }
        return entityManager().createQuery(jpaQuery, LsSeqAnlGrp.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }

	@Transactional
    public void persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }

	@Transactional
    public void remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            LsSeqAnlGrp attached = LsSeqAnlGrp.findLsSeqAnlGrp(this.id);
            this.entityManager.remove(attached);
        }
    }

	@Transactional
    public void flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }

	@Transactional
    public void clear() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.clear();
    }

	@Transactional
    public LsSeqAnlGrp merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        LsSeqAnlGrp merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
}
