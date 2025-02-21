package com.labsynch.labseer.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.labsynch.labseer.domain.Experiment;
import com.labsynch.labseer.domain.Protocol;
import com.labsynch.labseer.dto.ExperimentErrorMessageDTO;
import com.labsynch.labseer.dto.ReportGenerationRequestDTO;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ReportGenerationServiceImpl implements ReportGenerationService {
    
    private static final Logger logger = LoggerFactory.getLogger(ReportGenerationServiceImpl.class);

    @Autowired
    private ExperimentService experimentService;

    @Autowired
    private ProtocolService protocolService;

    @Override
    public String generateReport(Long projectId, ReportGenerationRequestDTO config) throws Exception {
        try {
            // 1. Gather experiments based on config
            Collection<ExperimentErrorMessageDTO> experimentDTOs;
            Collection<Experiment> experiments = new ArrayList<>();
            
            if (config.getExperimentIds() != null && !config.getExperimentIds().isEmpty()) {
                experimentDTOs = experimentService.findExperimentsByCodeNames(config.getExperimentIds());
                // Convert DTOs to Experiments
                for (ExperimentErrorMessageDTO dto : experimentDTOs) {
                    if (dto.getExperiment() != null) {
                        experiments.add(dto.getExperiment());
                    }
                }
            }

            // 2. Build report sections based on config.getSections()
            StringBuilder report = new StringBuilder();
            
            for (String section : config.getSections()) {
                switch (section.toLowerCase()) {
                    case "introduction":
                        report.append(generateIntroduction(experiments));
                        break;
                    case "methods":
                        report.append(generateMethods(experiments));
                        break;
                    case "results":
                        report.append(generateResults(experiments));
                        break;
                    case "discussion":
                        report.append(generateDiscussion(experiments));
                        break;
                }
            }

            // 3. Add custom notes if provided
            if (config.getCustomNotes() != null && !config.getCustomNotes().isEmpty()) {
                report.append("\n\nAdditional Notes:\n");
                report.append(config.getCustomNotes());
            }

            return report.toString();

        } catch (Exception e) {
            logger.error("Error generating report", e);
            throw e;
        }
    }

    private String generateIntroduction(Collection<Experiment> experiments) {
        StringBuilder intro = new StringBuilder("\n\nIntroduction\n============\n");
        
        // Analyze experiment objectives and background
        for (Experiment experiment : experiments) {
            // Add experiment purpose/goals
            intro.append("Experiment: ").append(experiment.getCodeName()).append("\n");
            
            // Add protocol background info
            if (experiment.getProtocol() != null) {
                intro.append("Protocol: ").append(experiment.getProtocol().getCodeName()).append("\n");
            }
        }
        
        return intro.toString();
    }

    private String generateMethods(Collection<Experiment> experiments) {
        StringBuilder methods = new StringBuilder("\n\nMethods\n=======\n");

        // Gather unique protocols
        Set<Protocol> protocols = new HashSet<Protocol>();
        for (Experiment experiment : experiments) {
            if (experiment.getProtocol() != null) {
                protocols.add(experiment.getProtocol());
            }
        }

        // Document methods for each protocol
        for (Protocol protocol : protocols) {
            methods.append("Protocol: ").append(protocol.getCodeName()).append("\n");
            methods.append("\n");
        }

        return methods.toString();
    }

    private String generateResults(Collection<Experiment> experiments) {
        StringBuilder results = new StringBuilder("\n\nResults\n=======\n");

        // Analyze and summarize results for each experiment
        for (Experiment experiment : experiments) {
            results.append("Experiment: ").append(experiment.getCodeName()).append("\n");
            results.append("\n");
        }

        return results.toString();
    }

    private String generateDiscussion(Collection<Experiment> experiments) {
        StringBuilder discussion = new StringBuilder("\n\nDiscussion\n==========\n");

        // Analyze results and generate insights
        for (Experiment experiment : experiments) {
            discussion.append("Interpretation of ").append(experiment.getCodeName()).append(":\n\n");
        }

        // Add overall conclusions
        discussion.append("\nOverall Conclusions:\n");
        discussion.append("Based on the experimental results from ").append(experiments.size()).append(" experiments.");

        return discussion.toString();
    }
} 