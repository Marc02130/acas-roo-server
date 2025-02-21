package com.labsynch.labseer.domain;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "experiment_sample")
public class ExperimentSample {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "experiment_order_id")
    private ExperimentOrder experimentOrder;

    @ManyToOne
    @JoinColumn(name = "compound_id")
    private Compound compound;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public ExperimentOrder getExperimentOrder() {
        return experimentOrder;
    }

    public void setExperimentOrder(ExperimentOrder experimentOrder) {
        this.experimentOrder = experimentOrder;
    }

    public Compound getCompound() {
        return compound;
    }

    public void setCompound(Compound compound) {
        this.compound = compound;
    }

    public static void deleteByExperimentOrder(ExperimentOrder experimentOrder) {
        // Implementation for deleting samples by experiment order
    }
} 