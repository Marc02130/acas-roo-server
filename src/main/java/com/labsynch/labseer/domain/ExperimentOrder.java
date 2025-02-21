package com.labsynch.labseer.domain;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.OneToMany;
import javax.persistence.Transient;

import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.jpa.activerecord.RooJpaActiveRecord;
import org.springframework.roo.addon.tostring.RooToString;

@RooJavaBean
@RooToString
@RooJpaActiveRecord
public class ExperimentOrder {

    @OneToMany(mappedBy = "experimentOrder", cascade = CascadeType.ALL)
    private Set<ExperimentSample> experimentSamples;

    @Transient
    private Collection<Sample> samples;

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