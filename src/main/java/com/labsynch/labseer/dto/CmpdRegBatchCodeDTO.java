package com.labsynch.labseer.dto;

import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

import com.labsynch.labseer.domain.AnalysisGroupValue;
import com.labsynch.labseer.domain.SubjectValue;
import com.labsynch.labseer.domain.TreatmentGroupValue;
import com.labsynch.labseer.utils.ExcludeNulls;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.transaction.annotation.Transactional;

import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;

public class CmpdRegBatchCodeDTO {

	public CmpdRegBatchCodeDTO() {
	}

	public CmpdRegBatchCodeDTO(Collection<String> batchCodes) {
		this.setBatchCodes(batchCodes);
	}

	private static final Logger logger = LoggerFactory.getLogger(CmpdRegBatchCodeDTO.class);

	private Collection<String> batchCodes;

	private Boolean linkedDataExists;

	private Collection<CodeTableDTO> linkedExperiments;

	private Collection<ErrorMessageDTO> errors;

	@Transactional
	public String toJson() {
		return new JSONSerializer().exclude("*.class").include("linkedExperiments.*", "batchCodes.*")
				.transform(new ExcludeNulls(), void.class).serialize(this);
	}

	@Transactional
	public void checkForDependentData() {
		linkedDataExists = false;
		linkedExperiments = new HashSet<CodeTableDTO>();
		errors = new HashSet<ErrorMessageDTO>();
		try {
			if (countExperimentValueBatchCodes() > 0) {
				linkedDataExists = true;
				logger.debug("Found Experiment values referencing provided batch codes. Retrieving experiment info.");
				linkedExperiments.addAll(findExperimentCodeTableDTOsFromExperimentValueBatchCodes());
			}
		} catch (Exception e) {
			ErrorMessageDTO error = new ErrorMessageDTO();
			error.setLevel("error");
			error.setMessage(e.getMessage());
			errors.add(error);
		}
		if (countTreatmentGroupValueBatchCodes() > 0) {
			linkedDataExists = true;
			logger.debug("Found TreatmentGroup values referencing provided batch codes. Retrieving experiment info.");
			linkedExperiments.addAll(findExperimentCodeTableDTOsFromTreatmentGroupValueBatchCodes());
		}
		if (countAnalysisGroupValueBatchCodes() > 0) {
			linkedDataExists = true;
			logger.debug("Found AnalysisGroup values referencing provided batch codes. Retrieving experiment info.");
			linkedExperiments.addAll(findExperimentCodeTableDTOsFromAnalysisGroupValueBatchCodes());
		}
		if (countSubjectValueBatchCodes() > 0) {
			linkedDataExists = true;
			logger.debug("Found Subject values referencing provided batch codes. Retrieving experiment info.");
			linkedExperiments.addAll(findExperimentCodeTableDTOsFromSubjectValueBatchCodes());
		}
		if (countProtocolValueBatchCodes() > 0) {
			linkedDataExists = true;
		}
		if (countLsThingValueBatchCodes() > 0) {
			linkedDataExists = true;
		}
		if (countContainerValueBatchCodes() > 0) {
			linkedDataExists = true;
		}
		// dedupeLinkedExperiments();
	}

	private Collection<CodeTableDTO> findExperimentCodeTableDTOsFromExperimentValueBatchCodes() {
		EntityManager em = SubjectValue.entityManager();
		String sql = "SELECT DISTINCT NEW MAP(e.codeName as code, el.labelText as name, ev.codeValue as comments) "
				+ "FROM ExperimentValue ev "
				+ "JOIN ev.lsState as es "
				+ "JOIN es.experiment as e "
				+ "LEFT OUTER JOIN e.lsLabels as el "
				+ "WHERE el.lsKind = 'experiment name' "
				+ "AND ev.lsKind = 'batch code' "
				+ "AND ev.ignored = false "
				+ "AND es.ignored = false "
				+ "AND e.ignored = false "
				+ "AND el.ignored = false "
				+ "AND ev.codeValue IN :batchCodes";

		TypedQuery<Map> q = em.createQuery(sql, Map.class);
		q.setParameter("batchCodes", this.batchCodes);

		Collection<CodeTableDTO> experimentCodeTableDTOs = new HashSet<CodeTableDTO>();
		for (Map<String, String> map : q.getResultList()) {
			CodeTableDTO codeTable = new CodeTableDTO();
			codeTable.setCode(map.get("code"));
			codeTable.setName(map.get("name"));
			codeTable.setComments(map.get("comments"));
			experimentCodeTableDTOs.add(codeTable);
		}
		return experimentCodeTableDTOs;
	}

	private Collection<CodeTableDTO> findExperimentCodeTableDTOsFromAnalysisGroupValueBatchCodes() {
		EntityManager em = SubjectValue.entityManager();
		String sql = "SELECT DISTINCT NEW MAP(e.codeName as code, el.labelText as name, agv.codeValue as comments) "
				+ "FROM AnalysisGroupValue agv "
				+ "JOIN agv.lsState as ags "
				+ "JOIN ags.analysisGroup as ag "
				+ "JOIN ag.experiments as e "
				+ "LEFT OUTER JOIN e.lsLabels as el "
				+ "WHERE el.lsKind = 'experiment name' "
				+ "AND agv.lsType = 'codeValue' "
				+ "AND agv.lsKind = 'batch code' "
				+ "AND agv.ignored = false "
				+ "AND ags.ignored = false "
				+ "AND ag.ignored = false "
				+ "AND e.ignored = false "
				+ "AND el.ignored = false "
				+ "AND agv.codeValue IN :batchCodes";

		TypedQuery<Map> q = em.createQuery(sql, Map.class);
		q.setParameter("batchCodes", this.batchCodes);

		Collection<CodeTableDTO> experimentCodeTableDTOs = new HashSet<CodeTableDTO>();
		for (Map<String, String> map : q.getResultList()) {
			CodeTableDTO codeTable = new CodeTableDTO();
			codeTable.setCode(map.get("code"));
			codeTable.setName(map.get("name"));
			codeTable.setComments(map.get("comments"));
			experimentCodeTableDTOs.add(codeTable);
		}
		return experimentCodeTableDTOs;
	}

	private Collection<CodeTableDTO> findExperimentCodeTableDTOsFromSubjectValueBatchCodes() {
		EntityManager em = SubjectValue.entityManager();
		String sql = "SELECT DISTINCT NEW MAP(e.codeName as code, el.labelText as name, sv.codeValue as comments) "
				+ "FROM SubjectValue sv "
				+ "JOIN sv.lsState as ss "
				+ "JOIN ss.subject as s "
				+ "JOIN s.treatmentGroups as tg "
				+ "JOIN tg.analysisGroups as ag "
				+ "JOIN ag.experiments as e "
				+ "LEFT OUTER JOIN e.lsLabels as el "
				+ "WHERE el.lsKind = 'experiment name' "
				+ "AND sv.lsKind = 'batch code' "
				+ "AND sv.ignored = false "
				+ "AND ss.ignored = false "
				+ "AND s.ignored = false "
				+ "AND tg.ignored = false "
				+ "AND ag.ignored = false "
				+ "AND e.ignored = false "
				+ "AND el.ignored = false "
				+ "AND sv.codeValue IN :batchCodes";

		TypedQuery<Map> q = em.createQuery(sql, Map.class);
		q.setParameter("batchCodes", this.batchCodes);

		Collection<CodeTableDTO> experimentCodeTableDTOs = new HashSet<CodeTableDTO>();
		for (Map<String, String> map : q.getResultList()) {
			CodeTableDTO codeTable = new CodeTableDTO();
			codeTable.setCode(map.get("code"));
			codeTable.setName(map.get("name"));
			codeTable.setComments(map.get("comments"));
			experimentCodeTableDTOs.add(codeTable);
		}
		return experimentCodeTableDTOs;
	}

	private Collection<CodeTableDTO> findExperimentCodeTableDTOsFromTreatmentGroupValueBatchCodes() {
		EntityManager em = SubjectValue.entityManager();
		String sql = "SELECT DISTINCT NEW MAP(e.codeName as code, el.labelText as name, tgv.codeValue as comments) "
				+ "FROM TreatmentGroupValue tgv "
				+ "JOIN tgv.lsState as tgs "
				+ "JOIN tgs.treatmentGroup as tg "
				+ "JOIN tg.analysisGroups as ag "
				+ "JOIN ag.experiments as e "
				+ "LEFT OUTER JOIN e.lsLabels as el "
				+ "WHERE el.lsKind = 'experiment name' "
				+ "AND tgv.lsType = 'codeValue' "
				+ "AND tgv.lsKind = 'batch code' "
				+ "AND tgv.ignored = false "
				+ "AND tgs.ignored = false "
				+ "AND tg.ignored = false "
				+ "AND ag.ignored = false "
				+ "AND e.ignored = false "
				+ "AND el.ignored = false "
				+ "AND tgv.codeValue IN :batchCodes";

		TypedQuery<Map> q = em.createQuery(sql, Map.class);
		q.setParameter("batchCodes", this.batchCodes);

		Collection<CodeTableDTO> experimentCodeTableDTOs = new HashSet<CodeTableDTO>();
		for (Map<String, String> map : q.getResultList()) {
			CodeTableDTO codeTable = new CodeTableDTO();
			codeTable.setCode(map.get("code"));
			codeTable.setName(map.get("name"));
			codeTable.setComments(map.get("comments"));
			experimentCodeTableDTOs.add(codeTable);
		}
		return experimentCodeTableDTOs;
	}

	private int countSubjectValueBatchCodes() {
		EntityManager em = SubjectValue.entityManager();
		String sql = "SELECT COUNT(*) "
				+ "FROM SubjectValue sv "
				+ "JOIN sv.lsState as ss "
				+ "JOIN ss.subject as s "
				+ "JOIN s.treatmentGroups as tg "
				+ "JOIN tg.analysisGroups as ag "
				+ "JOIN ag.experiments as e "
				+ "WHERE sv.lsType = 'codeValue' "
				+ "AND sv.lsKind = 'batch code' "
				+ "AND sv.ignored = false "
				+ "AND ss.ignored = false "
				+ "AND s.ignored = false "
				+ "AND tg.ignored = false "
				+ "AND ag.ignored = false "
				+ "AND e.ignored = false "
				+ "AND sv.codeValue IN :batchCodes";

		TypedQuery<Long> q = em.createQuery(sql, Long.class);
		q.setParameter("batchCodes", this.batchCodes);
		return q.getSingleResult().intValue();
	}

	private int countTreatmentGroupValueBatchCodes() {
		EntityManager em = TreatmentGroupValue.entityManager();
		String sql = "SELECT COUNT(*) "
				+ "FROM TreatmentGroupValue tgv "
				+ "JOIN tgv.lsState as tgs "
				+ "JOIN tgs.treatmentGroup as tg "
				+ "JOIN tg.analysisGroups as ag "
				+ "JOIN ag.experiments as e "
				+ "WHERE tgv.lsType = 'codeValue' "
				+ "AND tgv.lsKind = 'batch code' "
				+ "AND tgv.ignored = false "
				+ "AND tgs.ignored = false "
				+ "AND tg.ignored = false "
				+ "AND ag.ignored = false "
				+ "AND e.ignored = false "
				+ "AND tgv.codeValue IN :batchCodes";

		TypedQuery<Long> q = em.createQuery(sql, Long.class);
		q.setParameter("batchCodes", this.batchCodes);
		return q.getSingleResult().intValue();
	}

	private int countAnalysisGroupValueBatchCodes() {
		EntityManager em = AnalysisGroupValue.entityManager();
		String sql = "SELECT COUNT(*) "
				+ "FROM AnalysisGroupValue agv "
				+ "JOIN agv.lsState as ags "
				+ "JOIN ags.analysisGroup as ag "
				+ "JOIN ag.experiments as e "
				+ "WHERE agv.lsType = 'codeValue' "
				+ "AND agv.lsKind = 'batch code' "
				+ "AND agv.ignored = false "
				+ "AND ags.ignored = false "
				+ "AND ag.ignored = false "
				+ "AND e.ignored = false "
				+ "AND agv.codeValue IN :batchCodes";

		TypedQuery<Long> q = em.createQuery(sql, Long.class);
		q.setParameter("batchCodes", this.batchCodes);
		return q.getSingleResult().intValue();
	}

	private int countExperimentValueBatchCodes() {
		EntityManager em = TreatmentGroupValue.entityManager();
		String sql = "SELECT COUNT(*) "
				+ "FROM ExperimentValue ev "
				+ "JOIN ev.lsState as es "
				+ "JOIN es.experiment as e "
				+ "WHERE ev.lsType = 'codeValue' "
				+ "AND ev.lsKind = 'batch code' "
				+ "AND ev.ignored = false "
				+ "AND es.ignored = false "
				+ "AND e.ignored = false "
				+ "AND ev.codeValue IN :batchCodes";

		TypedQuery<Long> q = em.createQuery(sql, Long.class);
		q.setParameter("batchCodes", batchCodes);
		return q.getSingleResult().intValue();
	}

	private int countLsThingValueBatchCodes() {
		EntityManager em = TreatmentGroupValue.entityManager();
		String sql = "SELECT COUNT(*) "
				+ "FROM LsThingValue lstv "
				+ "JOIN lstv.lsState as lsts "
				+ "JOIN lsts.lsThing as lst "
				+ "WHERE lstv.lsType = 'codeValue' "
				+ "AND lstv.lsKind = 'batch code' "
				+ "AND lstv.ignored = false "
				+ "AND lsts.ignored = false "
				+ "AND lst.ignored = false "
				+ "AND lstv.codeValue IN :batchCodes";

		TypedQuery<Long> q = em.createQuery(sql, Long.class);
		q.setParameter("batchCodes", batchCodes);
		return q.getSingleResult().intValue();
	}

	private int countContainerValueBatchCodes() {
		EntityManager em = TreatmentGroupValue.entityManager();
		String sql = "SELECT COUNT(*) "
				+ "FROM ContainerValue cv "
				+ "JOIN cv.lsState as cs "
				+ "JOIN cs.container as c "
				+ "WHERE cv.lsType = 'codeValue' "
				+ "AND cv.lsKind = 'batch code' "
				+ "AND cv.ignored = false "
				+ "AND cs.ignored = false "
				+ "AND c.ignored = false "
				+ "AND cv.codeValue IN :batchCodes";

		TypedQuery<Long> q = em.createQuery(sql, Long.class);
		q.setParameter("batchCodes", batchCodes);
		return q.getSingleResult().intValue();
	}

	private int countProtocolValueBatchCodes() {
		EntityManager em = TreatmentGroupValue.entityManager();
		String sql = "SELECT COUNT(*) "
				+ "FROM ProtocolValue pv "
				+ "JOIN pv.lsState as ps "
				+ "JOIN ps.protocol as p "
				+ "WHERE pv.lsType = 'codeValue' "
				+ "AND pv.lsKind = 'batch code' "
				+ "AND pv.ignored = false "
				+ "AND ps.ignored = false "
				+ "AND p.ignored = false "
				+ "AND pv.codeValue IN :batchCodes";

		TypedQuery<Long> q = em.createQuery(sql, Long.class);
		q.setParameter("batchCodes", batchCodes);
		return q.getSingleResult().intValue();
	}

	private void dedupeLinkedExperiments() {
		HashMap<String, String> experimentMap = new HashMap<String, String>();
		logger.debug("Incoming size: " + linkedExperiments.size());
		for (CodeTableDTO codeTable : linkedExperiments) {
			experimentMap.put(codeTable.getCode(), codeTable.getName());
		}
		HashSet<CodeTableDTO> dedupedExperimentSet = new HashSet<CodeTableDTO>();
		for (String key : experimentMap.keySet()) {
			CodeTableDTO experimentCodeTable = new CodeTableDTO();
			experimentCodeTable.setCode(key);
			experimentCodeTable.setName(experimentMap.get(key));
			dedupedExperimentSet.add(experimentCodeTable);
		}
		linkedExperiments = dedupedExperimentSet;
		logger.debug("Deduped size: " + linkedExperiments.size());
	}

	public Collection<String> getBatchCodes() {
		return this.batchCodes;
	}

	public void setBatchCodes(Collection<String> batchCodes) {
		this.batchCodes = batchCodes;
	}

	public Boolean getLinkedDataExists() {
		return this.linkedDataExists;
	}

	public void setLinkedDataExists(Boolean linkedDataExists) {
		this.linkedDataExists = linkedDataExists;
	}

	public Collection<CodeTableDTO> getLinkedExperiments() {
		return this.linkedExperiments;
	}

	public void setLinkedExperiments(Collection<CodeTableDTO> linkedExperiments) {
		this.linkedExperiments = linkedExperiments;
	}

	public Collection<ErrorMessageDTO> getErrors() {
		return this.errors;
	}

	public void setErrors(Collection<ErrorMessageDTO> errors) {
		this.errors = errors;
	}

	public static CmpdRegBatchCodeDTO fromJsonToCmpdRegBatchCodeDTO(String json) {
		return new JSONDeserializer<CmpdRegBatchCodeDTO>()
				.use(null, CmpdRegBatchCodeDTO.class).deserialize(json);
	}

	public static String toJsonArray(Collection<CmpdRegBatchCodeDTO> collection) {
		return new JSONSerializer()
				.exclude("*.class").serialize(collection);
	}

	public static String toJsonArray(Collection<CmpdRegBatchCodeDTO> collection, String[] fields) {
		return new JSONSerializer()
				.include(fields).exclude("*.class").serialize(collection);
	}

	public static Collection<CmpdRegBatchCodeDTO> fromJsonArrayToCmpdRegBatchCoes(String json) {
		return new JSONDeserializer<List<CmpdRegBatchCodeDTO>>()
				.use("values", CmpdRegBatchCodeDTO.class).deserialize(json);
	}

	public String toString() {
		return ReflectionToStringBuilder.toString(this, ToStringStyle.SHORT_PREFIX_STYLE);
	}
}
