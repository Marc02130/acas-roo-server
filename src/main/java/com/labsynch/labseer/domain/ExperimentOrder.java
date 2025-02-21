package com.labsynch.labseer.domain;

import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.ArrayList;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EntityManager;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.PersistenceContext;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.TypedQuery;
import javax.persistence.Version;
import javax.validation.constraints.NotNull;
import javax.persistence.OneToMany;
import javax.persistence.CascadeType;
import javax.persistence.Transient;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.transaction.annotation.Transactional;

import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;

@Entity
@Table(name = "experiment_orders")
@Configurable
@Transactional
public class ExperimentOrder {

    private static final Logger logger = LoggerFactory.getLogger(ExperimentOrder.class);

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long id;

    @Version
    @Column(name = "version")
    private Integer version;

    @NotNull
    @Column(name = "tracking_id", unique = true)
    private String trackingId;

    @NotNull
    @Column(name = "project_id")
    private Long projectId;

    @NotNull
    @Column(name = "experiment_type")
    private String experimentType;

    @Column(name = "priority")
    private Integer priority;

    @NotNull
    @Column(name = "status")
    private String status = "Submitted";

    @Column(name = "expected_completion_date")
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "M-")
    private Date expectedCompletionDate;

    @NotNull
    @Column(name = "submitted_by")
    private String submittedBy;

    @Column(name = "submitted_date")
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "M-")
    private Date submittedDate;

    @Column(name = "last_updated")
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "M-")
    private Date lastUpdated;

    @NotNull
    @Column(name = "protocol_id")
    private String protocolId;

    @OneToMany(mappedBy = "experimentOrder", cascade = CascadeType.ALL)
    private Set<ExperimentSample> experimentSamples;

    @Transient
    private Collection<Sample> samples;

    @PersistenceContext
    transient EntityManager entityManager;

    public static final EntityManager entityManager() {
        EntityManager em = new ExperimentOrder().entityManager;
        if (em == null)
            throw new IllegalStateException(
                    "Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }

    public String toJson() {
        return new JSONSerializer()
            .exclude("*.class")
            .serialize(this);
    }

    public String toString() {
        return ReflectionToStringBuilder.toString(this, ToStringStyle.SHORT_PREFIX_STYLE);
    }

    public static String toJsonArray(Collection<ExperimentOrder> collection) {
        return new JSONSerializer()
            .exclude("*.class")
            .serialize(collection);
    }

    public static ExperimentOrder fromJson(String json) {
        return new JSONDeserializer<ExperimentOrder>()
            .use(null, ExperimentOrder.class)
            .deserialize(json);
    }

    public static Collection<ExperimentOrder> fromJsonArrayToExperimentOrders(String json) {
        return new JSONDeserializer<List<ExperimentOrder>>()
            .use("values", ExperimentOrder.class)
            .deserialize(json);
    }

    public static TypedQuery<ExperimentOrder> findExperimentOrdersByProjectId(Long projectId) {
        if (projectId == null)
            throw new IllegalArgumentException("The projectId argument is required");
        EntityManager em = ExperimentOrder.entityManager();
        TypedQuery<ExperimentOrder> q = em.createQuery(
            "SELECT o FROM ExperimentOrder AS o WHERE o.projectId = :projectId", 
            ExperimentOrder.class);
        q.setParameter("projectId", projectId);
        return q;
    }

    public static TypedQuery<ExperimentOrder> findExperimentOrdersByTrackingId(String trackingId) {
        if (trackingId == null || trackingId.length() == 0)
            throw new IllegalArgumentException("The trackingId argument is required");
        EntityManager em = ExperimentOrder.entityManager();
        TypedQuery<ExperimentOrder> q = em.createQuery(
            "SELECT o FROM ExperimentOrder AS o WHERE o.trackingId = :trackingId", 
            ExperimentOrder.class);
        q.setParameter("trackingId", trackingId);
        return q;
    }

    public static TypedQuery<ExperimentOrder> findExperimentOrdersByStatus(String status) {
        if (status == null || status.length() == 0)
            throw new IllegalArgumentException("The status argument is required");
        EntityManager em = ExperimentOrder.entityManager();
        TypedQuery<ExperimentOrder> q = em.createQuery(
            "SELECT o FROM ExperimentOrder AS o WHERE o.status = :status", 
            ExperimentOrder.class);
        q.setParameter("status", status);
        return q;
    }

    public static ExperimentOrder findExperimentOrder(Long id) {
        if (id == null) return null;
        return entityManager().find(ExperimentOrder.class, id);
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
    public ExperimentOrder merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        ExperimentOrder merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }

    // Getters and setters
    public Long getId() { return this.id; }
    public void setId(Long id) { this.id = id; }
    public Integer getVersion() { return this.version; }
    public void setVersion(Integer version) { this.version = version; }
    public String getTrackingId() { return this.trackingId; }
    public void setTrackingId(String trackingId) { this.trackingId = trackingId; }
    public Long getProjectId() { return this.projectId; }
    public void setProjectId(Long projectId) { this.projectId = projectId; }
    public String getExperimentType() { return this.experimentType; }
    public void setExperimentType(String experimentType) { this.experimentType = experimentType; }
    public Integer getPriority() { return this.priority; }
    public void setPriority(Integer priority) { this.priority = priority; }
    public String getStatus() { return this.status; }
    public void setStatus(String status) { this.status = status; }
    public Date getExpectedCompletionDate() { return this.expectedCompletionDate; }
    public void setExpectedCompletionDate(Date expectedCompletionDate) { this.expectedCompletionDate = expectedCompletionDate; }
    public String getSubmittedBy() { return this.submittedBy; }
    public void setSubmittedBy(String submittedBy) { this.submittedBy = submittedBy; }
    public Date getSubmittedDate() { return this.submittedDate; }
    public void setSubmittedDate(Date submittedDate) { this.submittedDate = submittedDate; }
    public Date getLastUpdated() { return this.lastUpdated; }
    public void setLastUpdated(Date lastUpdated) { this.lastUpdated = lastUpdated; }
    public String getProtocolId() { return this.protocolId; }
    public void setProtocolId(String protocolId) { this.protocolId = protocolId; }

    public Collection<Sample> getSamples() {
        if (samples == null) {
            samples = new ArrayList<>();
            for (ExperimentSample es : experimentSamples) {
                samples.add(es.getSample());
            }
        }
        return samples;
    }

    public void setSamples(Collection<Sample> samples) {
        this.samples = samples;
    }
} 