package com.labsynch.labseer.api;

import java.util.List;
import java.util.Collection;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.transaction.annotation.Transactional;

import com.labsynch.labseer.domain.Compound;
import com.labsynch.labseer.domain.ExperimentOrder;
import com.labsynch.labseer.domain.ExperimentSample;
import com.labsynch.labseer.service.ExperimentOrderService;

@RestController
@RequestMapping("/api/v1")
@Transactional
public class ApiExperimentOrderController {

    private static final Logger logger = LoggerFactory.getLogger(ApiExperimentOrderController.class);

    @Autowired
    private ExperimentOrderService experimentOrderService;

    @PersistenceContext
    EntityManager entityManager;

    @GetMapping("/projects/{id}/experimentorder")
    public ResponseEntity<String> getProjectExperiments(@PathVariable Long id) {
        try {
            List<ExperimentOrder> experiments = experimentOrderService.findExperimentsByProject(id);
            return new ResponseEntity<String>(ExperimentOrder.toJsonArray(experiments), HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<String>(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/experimentorder")
    public ResponseEntity<String> createExperiment(@RequestBody ExperimentOrder order) {
        try {
            ExperimentOrder experimentOrder = experimentOrderService.saveExperimentOrder(order);
            return new ResponseEntity<String>(experimentOrder.toJson(), HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<String>(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/experimentorder/{id}/status")
    public ResponseEntity<String> updateStatus(@PathVariable Long id, @RequestBody String status) {
        try {
            experimentOrderService.updateStatus(id, status);
            return new ResponseEntity<String>("Status updated successfully", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<String>("Error updating status: " + e.getMessage(), 
                                     HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/experimentorder/search/{searchTerm}")
    public ResponseEntity<String> searchExperimentOrders(@PathVariable String searchTerm) {
        try {
            // Search by code, name, status etc
            List<ExperimentOrder> experiments = experimentOrderService.findExperimentsBySearchTerm(searchTerm);
            return new ResponseEntity<String>(ExperimentOrder.toJsonArray(experiments), HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<String>(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @RequestMapping(value = "/{id}/compounds", method = RequestMethod.GET)
    public ResponseEntity<String> getExperimentCompounds(@PathVariable("id") Long id) {
        ExperimentOrder experimentOrder = ExperimentOrder.findExperimentOrder(id);
        return new ResponseEntity<String>(Compound.toJsonArray(experimentOrder.getCompounds()), 
            getJsonHeaders(), HttpStatus.OK);
    }

    @RequestMapping(value = "/{id}/compounds", method = RequestMethod.POST)
    public ResponseEntity<String> updateExperimentCompounds(
            @PathVariable("id") Long id,
            @RequestBody Collection<Compound> compounds) {
        ExperimentOrder experimentOrder = ExperimentOrder.findExperimentOrder(id);
        
        // Delete existing experiment samples - using the getter method
        for (ExperimentSample es : experimentOrder.getExperimentSamples()) {
            entityManager.remove(es);
        }
        
        // Create new experiment samples
        for (Compound compound : compounds) {
            ExperimentSample experimentSample = new ExperimentSample();
            experimentSample.setExperimentOrder(experimentOrder);
            experimentSample.setCompound(compound);
            entityManager.persist(experimentSample);
        }
        
        return new ResponseEntity<String>(getJsonHeaders(), HttpStatus.OK);
    }

    private HttpHeaders getJsonHeaders() {
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Type", "application/json; charset=utf-8");
        return headers;
    }
}