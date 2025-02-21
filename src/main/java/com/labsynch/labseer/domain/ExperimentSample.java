package com.labsynch.labseer.domain;

import javax.persistence.Entity;
import javax.persistence.EntityManager;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PersistenceContext;
import javax.persistence.Table;
import javax.persistence.Column;

import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.transaction.annotation.Transactional;

import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;

import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import org.springframework.roo.addon.jpa.activerecord.RooJpaActiveRecord;

@Entity
@Table(name = "experiment_samples")
@Configurable
@Transactional
@RooJavaBean
@RooToString
@RooJpaActiveRecord
public class ExperimentSample {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "experiment_id")
    private ExperimentOrder experimentOrder;

    @ManyToOne 
    @JoinColumn(name = "sample_id")
    private Sample sample;

    @Column(name = "sample_role")
    private String sampleRole;

    @PersistenceContext
    transient EntityManager entityManager;

    public String toJson() {
        return new JSONSerializer()
            .exclude("*.class")
            .serialize(this);
    }

    public static ExperimentSample fromJson(String json) {
        return new JSONDeserializer<ExperimentSample>()
            .use(null, ExperimentSample.class)
            .deserialize(json);
    }

    // Getters and setters
    public ExperimentOrder getExperimentOrder() {
        return this.experimentOrder;
    }

    public void setExperimentOrder(ExperimentOrder experimentOrder) {
        this.experimentOrder = experimentOrder;
    }

    public Integer getSampleId() {
        return this.sample.getId();
    }

    public void setSampleId(Integer sampleId) {
        this.sample.setId(sampleId);
    }

    public String getSampleRole() {
        return this.sampleRole;
    }

    public void setSampleRole(String sampleRole) {
        this.sampleRole = sampleRole;
    }
} 