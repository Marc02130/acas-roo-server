package com.labsynch.labseer.service;

import com.labsynch.labseer.dto.ReportGenerationRequestDTO;

public interface ReportGenerationService {
    String generateReport(Long projectId, ReportGenerationRequestDTO config) throws Exception;
} 