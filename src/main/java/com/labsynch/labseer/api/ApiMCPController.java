package com.labsynch.labseer.api;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/api/v1/mcp")
public class ApiMCPController {

    private static final Logger logger = LoggerFactory.getLogger(ApiMCPController.class);
    
    private final String mcpServiceUrl = "http://mcp:3002/api/";
    private final RestTemplate restTemplate = new RestTemplate();

    @RequestMapping(value = "/process", method = RequestMethod.POST)
    public ResponseEntity<String> processChemistryData(@RequestBody String requestBody) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            HttpEntity<String> entity = new HttpEntity<>(requestBody, headers);
            ResponseEntity<String> mcpResponse = 
                restTemplate.exchange(mcpServiceUrl + "process", HttpMethod.POST, entity, String.class);
            
            return new ResponseEntity<>(mcpResponse.getBody(), mcpResponse.getStatusCode());
        } catch (Exception e) {
            logger.error("Error processing chemistry data: ", e);
            return new ResponseEntity<>("Error processing chemistry data: " + e.getMessage(), 
                                       HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    @RequestMapping(value = "/jobs/{jobId}", method = RequestMethod.GET)
    public ResponseEntity<String> getJobStatus(@PathVariable String jobId) {
        try {
            ResponseEntity<String> mcpResponse = 
                restTemplate.getForEntity(mcpServiceUrl + "jobs/" + jobId, String.class);
            
            return new ResponseEntity<>(mcpResponse.getBody(), mcpResponse.getStatusCode());
        } catch (Exception e) {
            logger.error("Error retrieving job status: ", e);
            return new ResponseEntity<>("Error retrieving job status: " + e.getMessage(), 
                                       HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
} 