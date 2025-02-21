package com.labsynch.labseer.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.labsynch.labseer.domain.ExperimentOrder;

@Service
@Transactional
public class ExperimentOrderServiceImpl implements ExperimentOrderService {

    private static final Logger logger = LoggerFactory.getLogger(ExperimentOrderServiceImpl.class);

    private static final List<String> VALID_STATUSES = Arrays.asList(
        "Created", "Lab Notified", "In Progress", "Results Available"
    );

    @Override
    public ExperimentOrder saveExperimentOrder(ExperimentOrder order) {
        order.setStatus("Created");  // Initial status from requirements
        order.setSubmittedDate(new Date());
        return order.merge();
    }

    @Override
    public List<ExperimentOrder> findExperimentsByProject(Long projectId) {
        return ExperimentOrder.findExperimentOrdersByProjectId(projectId).getResultList();
    }

    @Override
    public ExperimentOrder findExperiment(Long id) {
        return ExperimentOrder.findExperimentOrder(id);
    }

    @Override
    public ExperimentOrder updateStatus(Long id, String status) {
        if (!VALID_STATUSES.contains(status)) {
            throw new IllegalArgumentException("Invalid status: " + status);
        }
        
        ExperimentOrder order = findExperiment(id);
        if (order != null) {
            order.setStatus(status);
            order.setLastUpdated(new Date());
            order.merge();
        }
        return order;
    }

    @Override
    public boolean isValidStatus(String status) {
        return VALID_STATUSES.contains(status);
    }

    @Override
    public String generateTrackingId() {
        return "EXP-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    @Override
    public List<ExperimentOrder> findExperimentsBySearchTerm(String searchTerm) {
        // Basic implementation - search by tracking ID or status
        if (searchTerm == null || searchTerm.isEmpty()) {
            return new ArrayList<>();
        }
        
        List<ExperimentOrder> results = new ArrayList<>();
        results.addAll(ExperimentOrder.findExperimentOrdersByTrackingId(searchTerm).getResultList());
        results.addAll(ExperimentOrder.findExperimentOrdersByStatus(searchTerm).getResultList());
        return results;
    }
}