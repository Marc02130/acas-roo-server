package com.labsynch.labseer.api;

import java.util.List;
import java.util.Collection;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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

import com.labsynch.labseer.domain.ExperimentOrder;
import com.labsynch.labseer.domain.ExperimentSample;
import com.labsynch.labseer.domain.Sample;
import com.labsynch.labseer.service.ExperimentOrderService;

@RestController
@RequestMapping("/api/v1")
public class ApiExperimentOrderController {

    private static final Logger logger = LoggerFactory.getLogger(ApiExperimentOrderController.class);

    @Autowired
    private ExperimentOrderService experimentOrderService;

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

    @RequestMapping(value = "/{id}/samples", method = RequestMethod.GET) 
    @ResponseBody
    public Collection<Sample> getExperimentSamples(@PathVariable("id") Long id) {
        ExperimentOrder experimentOrder = ExperimentOrder.findExperimentOrder(id);
        return experimentOrder.getSamples();
    }

    @RequestMapping(value = "/{id}/samples", method = RequestMethod.POST)
    @ResponseBody 
    public void updateExperimentSamples(@PathVariable("id") Long id, 
                                      @RequestBody Collection<Sample> samples) {
        ExperimentOrder experimentOrder = ExperimentOrder.findExperimentOrder(id);
        
        // Remove existing samples
        ExperimentSample.deleteByExperimentOrder(experimentOrder);
        
        // Add new samples
        for (Sample sample : samples) {
            ExperimentSample experimentSample = new ExperimentSample();
            experimentSample.setExperimentOrder(experimentOrder);
            experimentSample.setSample(sample);
            experimentSample.persist();
        }
    }
}