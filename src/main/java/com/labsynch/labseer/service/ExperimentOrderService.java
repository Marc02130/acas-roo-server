package com.labsynch.labseer.service;

import java.util.List;

import com.labsynch.labseer.domain.ExperimentOrder;
import org.springframework.stereotype.Service;

@Service
public interface ExperimentOrderService {

    /**
     * Creates a new experiment order
     * @param experimentOrder The experiment order to create
     * @return The created experiment order
     */
    ExperimentOrder saveExperimentOrder(ExperimentOrder experimentOrder);

    /**
     * Finds experiment orders by project with optional filters
     * @param projectId The project ID
     * @param status Optional status filter
     * @param fromDate Optional start date filter
     * @param toDate Optional end date filter
     * @return List of matching experiment orders
     */
    List<ExperimentOrder> findExperimentsByProject(Long projectId);

    /**
     * Gets experiment order details by ID
     * @param id The experiment order ID
     * @return The experiment order or null if not found
     */
    ExperimentOrder findExperiment(Long id);

    /**
     * Updates experiment order status
     * @param id The experiment order ID
     * @param status The new status
     * @param username The username of the user updating the status
     * @return The updated experiment order or null if not found
     */
    ExperimentOrder updateStatus(Long id, String status);

    /**
     * Validates experiment order status
     * @param status The status to validate
     * @return true if valid, false otherwise
     */
    boolean isValidStatus(String status);

    /**
     * Generates a unique tracking ID for a new experiment order
     * @return The generated tracking ID
     */
    String generateTrackingId();

    /**
     * Finds experiment orders by search term
     * @param searchTerm The search term
     * @return List of matching experiment orders
     */
    List<ExperimentOrder> findExperimentsBySearchTerm(String searchTerm);

} 