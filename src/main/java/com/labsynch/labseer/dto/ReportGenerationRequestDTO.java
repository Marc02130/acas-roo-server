package com.labsynch.labseer.dto;

import java.util.Date;
import java.util.List;

import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;

public class ReportGenerationRequestDTO {
    private Date startDate;
    private Date endDate;
    private List<String> sections;
    private List<String> experimentIds;
    private String customNotes;
    
    public ReportGenerationRequestDTO() {}
    
    // Getters and setters
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    
    public List<String> getSections() { return sections; }
    public void setSections(List<String> sections) { this.sections = sections; }
    
    public List<String> getExperimentIds() { return experimentIds; }
    public void setExperimentIds(List<String> experimentIds) { this.experimentIds = experimentIds; }
    
    public String getCustomNotes() { return customNotes; }
    public void setCustomNotes(String customNotes) { this.customNotes = customNotes; }

    // JSON serialization methods
    public String toJson() {
        return new JSONSerializer()
                .exclude("*.class").serialize(this);
    }

    public static ReportGenerationRequestDTO fromJson(String json) {
        return new JSONDeserializer<ReportGenerationRequestDTO>()
                .use(null, ReportGenerationRequestDTO.class)
                .deserialize(json);
    }
} 