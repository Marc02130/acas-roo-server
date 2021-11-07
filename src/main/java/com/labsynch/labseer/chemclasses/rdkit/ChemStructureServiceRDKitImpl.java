package com.labsynch.labseer.chemclasses.rdkit;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.labsynch.labseer.chemclasses.CmpdRegMolecule;
import com.labsynch.labseer.domain.RDKitSaltStructure;
import com.labsynch.labseer.domain.RDKitStructure;
import com.labsynch.labseer.domain.Salt;
import com.labsynch.labseer.dto.MolConvertOutputDTO;
import com.labsynch.labseer.dto.StrippedSaltDTO;
import com.labsynch.labseer.exceptions.CmpdRegMolFormatException;
import com.labsynch.labseer.service.ChemStructureService;
import com.labsynch.labseer.utils.PropertiesUtilService;
import com.labsynch.labseer.utils.SimpleUtil;

import org.springframework.jdbc.core.JdbcTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.RDKit.*;

import org.codehaus.jackson.JsonFactory;
import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.JsonParser;
import org.codehaus.jackson.JsonToken;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.node.ArrayNode;
import org.codehaus.jackson.node.ObjectNode;
import java.util.UUID;
import static java.lang.Math.toIntExact;
@Component
public class ChemStructureServiceRDKitImpl implements ChemStructureService {

	Logger logger = LoggerFactory.getLogger(ChemStructureServiceRDKitImpl.class);

	@Autowired
	private PropertiesUtilService propertiesUtilService;
	
	@Autowired
	private JdbcTemplate basicJdbcTemplate;

	static {
		System.loadLibrary("GraphMolWrap");
	}
	
	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.basicJdbcTemplate = jdbcTemplate;
	}

	public JdbcTemplate getJdbcTemplate() {
		return basicJdbcTemplate;
	}
	
	@Override
	public int getCount(String structureTable) {
		// Count the number of rows in the structure table
		String sql = "select count(*) from " + structureTable;
		
		int count;
		Integer countInt = basicJdbcTemplate.queryForObject(sql, Integer.class);
		if (countInt == null){
			count = 0;
		} else {
			count = countInt;
		}

		return count;
	}

	@Override
	public int saveStructure(String molfile, String structureTable) {
		boolean checkForDupes = false;
		return saveStructure(molfile, structureTable, checkForDupes);
	}

	@Override
	public int[] searchMolStructures(String molfile, String structureTable, String searchType, Float simlarityPercent)
			throws CmpdRegMolFormatException {
		// TODO Auto-generated method stub
		return searchMolStructures(molfile, structureTable, null, searchType, simlarityPercent);	
	}

	@Override
	public void closeConnection() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public int[] searchMolStructures(String molfile, String structureTable, String searchType)
			throws CmpdRegMolFormatException {
		String plainTable = null;
		if (structureTable.equalsIgnoreCase("Parent_Structure")){
			plainTable = "parent";
		} else if (structureTable.equalsIgnoreCase("SaltForm_Structure")){
			plainTable = "salt_form";
		} else if (structureTable.equalsIgnoreCase("Salt_Structure")){
			plainTable = "salt";
		}

		return searchMolStructures(molfile, structureTable, plainTable, searchType);	
	}

	@Override
	public int[] searchMolStructures(String molfile, String structureTable, String plainTable, String searchType,
			Float simlarityPercent) throws CmpdRegMolFormatException {
		return searchMolStructures(molfile, structureTable, plainTable, searchType, 0f);	
	}

	@Override
	public boolean dropJChemTable(String tableName) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public int[] searchMolStructures(String molfile, String structureTable, String plainTable, String searchType)
			throws CmpdRegMolFormatException {

		RDKitStructure serviceRDKitStructure = getRDKitStructureFromService(molfile);

		//Create empty list
		List<RDKitStructure> rdkitStructures = new ArrayList<RDKitStructure>();
	    if (searchType.equalsIgnoreCase("FULL_TAUTOMER")){
			rdkitStructures = RDKitStructure.findRDKitStructuresByRegEquals(serviceRDKitStructure.getReg()).getResultList();
		}else if (searchType.equalsIgnoreCase("DUPLICATE_TAUTOMER")){
			rdkitStructures = RDKitStructure.findRDKitStructuresByRegEquals(serviceRDKitStructure.getReg()).getResultList();
		}
		// Create empty int hit list
		int[] hits = new int[rdkitStructures.size()];
		for (int i = 0; i < hits.length; i++) {
			hits[i] = toIntExact(rdkitStructures.get(i).getId());
		}
		return hits;
	}
	
	public RDKitStructure getRDKitStructureFromService(String molfile) throws CmpdRegMolFormatException {
		RDKitStructure rdkitStructure = new RDKitStructure();

		// Read the preprocessor settings as json
		ObjectMapper objectMapper = new ObjectMapper();
		JsonNode jsonNode = null;
		try{
			jsonNode = objectMapper.readTree(propertiesUtilService.getPreprocessorSettings());

		} catch (IOException e) {
			logger.error("Error parsing preprocessor settings json: " + propertiesUtilService.getPreprocessorSettings());
			throw new CmpdRegMolFormatException("Error parsing preprocessor settings json: " + propertiesUtilService.getPreprocessorSettings());
		}

		// Extract the url to call
		JsonNode urlNode = jsonNode.get("processURL");
		if(urlNode == null || urlNode.isNull()) {
			logger.error("Missing preprocessorSettings processURL!!");
		}

		String url = urlNode.asText();

		// Get the preprocessory settings
		ObjectMapper mapper = new ObjectMapper();
		ObjectNode requestData = mapper.createObjectNode();
		JsonNode standardizerActions = jsonNode.get("standardizer_actions");
		ObjectNode options = (ObjectNode) jsonNode.get("process_options");
		options.put("standardizer_actions", standardizerActions);
		requestData.put("options", options);

		ArrayNode arrayNode = mapper.createArrayNode();
		arrayNode.add(molfile);
		requestData.put("structures", arrayNode);

		// Post to the service
		try {
			String requestString = requestData.toString();
			logger.info("requestString: " + requestString);
			String postResponse = SimpleUtil.postRequestToExternalServer(url, requestString, logger);
			logger.info("Got response: "+ postResponse);

			// Parse the response json to get the standardized mol
			ObjectMapper responseMapper = new ObjectMapper();
			JsonNode responseNode = responseMapper.readTree(postResponse);
			for (JsonNode responseJsonNode : responseNode)  {
				JsonNode registrationHashesNode = responseJsonNode.get("registration_hash");
				String registrationHash = registrationHashesNode.get(0).asText();
				rdkitStructure.setReg(registrationHashesNode.get(0).asText());

				JsonNode noStereoHashNode = responseJsonNode.get("no_stereo_hash");
				rdkitStructure.setPreReg(noStereoHashNode.asText());

				JsonNode sdfNode = responseJsonNode.get("sdf");
				rdkitStructure.setMol(sdfNode.asText());
			}


		} catch (Exception e) {
			logger.error("Error posting to preprocessor service: " + e.getMessage());
			throw new CmpdRegMolFormatException("Error posting to preprocessor service: " + e.getMessage());
		}

		// Set recorded date todays date. This simplifies the code when we need to persist the structure
		// in various places.
		rdkitStructure.setRecordedDate(new Date());
		return rdkitStructure;
	}

	@Override
	public boolean createJChemTable(String tableName, boolean tautomerDupe) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public int saveStructure(String molfile, String structureTable, boolean checkForDupes) {
		try {
			RDKitStructure rdkitStructure = getRDKitStructureFromService(molfile);

			if (structureTable.equalsIgnoreCase("Parent_Structure")){
				rdkitStructure.persist();
			} else if (structureTable.equalsIgnoreCase("SaltForm_Structure")){

			} else if (structureTable.equalsIgnoreCase("Salt_Structure")){
				// Can't type cast from subclass to superclass so we go to json and back
				RDKitSaltStructure rdkitStructureSalt = RDKitSaltStructure.fromJsonToRDKitSaltStructure(rdkitStructure.toJson());

				if(checkForDupes){
					List<RDKitSaltStructure> rdkitStructures =  RDKitSaltStructure.findRDKitSaltStructuresByRegEquals(rdkitStructureSalt.getReg()).getResultList();
					if(rdkitStructures.size() > 0){
						logger.error("Salt structure already exists with id "+ rdkitStructures.get(0).getId());
						return 0;
					}
				}
				rdkitStructureSalt.persist();

				// We can type cast from subclass to superclass
				rdkitStructure = (RDKitStructure) rdkitStructureSalt;
			} else if (structureTable.equalsIgnoreCase("Dry_Run_Compound_Structure")){
				// plainTable = "dry_run_compound";
			}

			return toIntExact(rdkitStructure.getId());
		} catch (CmpdRegMolFormatException e) {
			logger.error("Error saving structure: " + e.getMessage());
			return -1;
		}
	}

	@Override
	public CmpdRegMolecule[] searchMols(String molfile, String structureTable, int[] cdHitList, String plainTable,
			String searchType, Float simlarityPercent) throws CmpdRegMolFormatException {
		int maxResults = propertiesUtilService.getMaxSearchResults();
		return searchMols(molfile, structureTable, cdHitList, plainTable, searchType, simlarityPercent, maxResults);
	}

	@Override
	public double getMolWeight(String molStructure) throws CmpdRegMolFormatException {
		// Calculates the average molecular weight of a molecule
		RWMol mol = RWMol.MolFromMolBlock(molStructure);
		return RDKFuncs.calcAMW(mol, false);
	}

	@Override
	public CmpdRegMolecule toMolecule(String molStructure) throws CmpdRegMolFormatException {
		return new CmpdRegMoleculeRDKitImpl(RWMol.MolFromMolBlock(molStructure));
	}

	@Override
	public String toMolfile(String molStructure) throws CmpdRegMolFormatException {
		RWMol mol = RWMol.MolFromMolBlock(molStructure);
		mol.Kekulize();
		return mol.MolToMolBlock();
	}

	@Override
	public String toSmiles(String molStructure) throws CmpdRegMolFormatException {
		RWMol mol = RWMol.MolFromMolBlock(molStructure);
		return RDKFuncs.MolToSmiles(mol);
	}

	@Override
	public boolean createJchemPropertyTable() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public int[] checkDupeMol(String molStructure, String structureTable, String plainTable)
			throws CmpdRegMolFormatException {
		return searchMolStructures(molStructure, structureTable, plainTable, "DUPLICATE_TAUTOMER"); 
	}

	@Override
	public String toInchi(String molStructure) {
		return RDKFuncs.MolBlockToInchi(molStructure, new ExtraInchiReturnValues());
	}

	@Override
	public boolean updateStructure(String molStructure, String structureTable, int cdId) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public String getMolFormula(String molStructure) throws CmpdRegMolFormatException {
		RWMol mol = RWMol.MolFromMolBlock(molStructure);
		return RDKFuncs.calcMolFormula(mol);
	}

	@Override
	public boolean deleteAllJChemTableRows(String tableName) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean deleteJChemTableRows(String tableName, int[] cdIds) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean checkForSalt(String molfile) throws CmpdRegMolFormatException {
		boolean foundNonCovalentSalt = false;
		RWMol mol = RWMol.MolFromMolBlock(molfile);
		ROMol_Vect frags = RDKFuncs.getMolFrags(mol);
		if(frags.size() > 1.0) {
			foundNonCovalentSalt = true;
		}
		return foundNonCovalentSalt;
	}

	@Override
	public boolean updateStructure(CmpdRegMolecule mol, String structureTable, int cdId) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public double getExactMass(String molStructure) throws CmpdRegMolFormatException {
		RWMol mol = RWMol.MolFromMolBlock(molStructure);
		return RDKFuncs.calcExactMW(mol, true);
	}

	@Override
	public boolean deleteStructure(String structureTable, int cdId) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public CmpdRegMolecule[] searchMols(String molfile, String structureTable, int[] inputCdIdHitList,
			String plainTable, String searchType, Float simlarityPercent, int maxResults)
			throws CmpdRegMolFormatException {
		
			RDKitStructure serviceRDKitStructure = getRDKitStructureFromService(molfile);

			//Create empty list
			List<RDKitStructure> rdkitStructures = new ArrayList<RDKitStructure>();
			if (searchType.equalsIgnoreCase("FULL_TAUTOMER")){
				rdkitStructures = RDKitStructure.findRDKitStructuresByRegEquals(serviceRDKitStructure.getReg()).getResultList();
			}

			List<CmpdRegMolecule> resultList = new ArrayList<CmpdRegMolecule>();
			for (RDKitStructure hit : rdkitStructures) {
				resultList.add(new CmpdRegMoleculeRDKitImpl(hit.getMol()));
			}
			CmpdRegMolecule[] resultArray = new CmpdRegMolecule[resultList.size()];
			
			return resultList.toArray(resultArray);
	}

	@Override
	public int[] searchMolStructures(String molfile, String structureTable, String plainTable, String searchType,
			Float simlarityPercent, int maxResults) throws CmpdRegMolFormatException {
		int maxResultCount = propertiesUtilService.getMaxSearchResults();
		return searchMolStructures(molfile, structureTable, plainTable, searchType, simlarityPercent, maxResultCount);	
	}

	@Override
	public MolConvertOutputDTO toFormat(String structure, String inputFormat, String outputFormat)
			throws IOException, CmpdRegMolFormatException {
		boolean badStructureFlag = false;
		RWMol mol = null;
		try {
			if (inputFormat == null || inputFormat.equalsIgnoreCase("mol")) {
				mol = RWMol.MolFromMolBlock(structure);
			} else if (inputFormat.equalsIgnoreCase("sdf")) {
				mol = RWMol.MolFromMolBlock(structure);
			} else if (inputFormat.equalsIgnoreCase("smi")) {
				mol = RWMol.MolFromSmiles(structure);
			}
		} catch (Exception e) {
			badStructureFlag = true;
		}

		MolConvertOutputDTO output = new MolConvertOutputDTO();		
		if (!badStructureFlag){
			if (outputFormat == null || outputFormat.equalsIgnoreCase("mol")) {
				output.setStructure(mol.MolToMolBlock());
			} else if (inputFormat.equalsIgnoreCase("sdf")) {
				output.setStructure(mol.MolToMolBlock());
			} else if (inputFormat.equalsIgnoreCase("smi")) {
				output.setStructure(mol.MolToSmiles());
			}
			output.setFormat(outputFormat);
			String contentUrl = "TO DO: Download Link";
			output.setContentUrl(contentUrl);
		} 
		return output;
	}

	@Override
	public MolConvertOutputDTO cleanStructure(String structure, int dim, String opts)
			throws IOException, CmpdRegMolFormatException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String hydrogenizeMol(String structure, String inputFormat, String method)
			throws IOException, CmpdRegMolFormatException {
		RWMol mol = RWMol.MolFromMolBlock(structure);
		if (method.equalsIgnoreCase("HYDROGENIZE")){
			RDKFuncs.addHs(mol);		
		} else {
			RDKFuncs.removeHs(mol);
		}
		return mol.MolToMolBlock();
	}

	@Override
	public String getCipStereo(String structure) throws IOException, CmpdRegMolFormatException {
		//Jchem implementation returns something like
		//e.g. [TH: 1{0,3,2} S]
		//Indigo implementaiton returns the mol file after running some Indigo function
		//No implementing this function because its not used anywhere that I can find
		//Perhaps it was used as a utility function at somepoint
		return "NOT IMPLEMENTED";
	}

	@Override
	public StrippedSaltDTO stripSalts(CmpdRegMolecule inputStructure) throws CmpdRegMolFormatException {
		CmpdRegMoleculeRDKitImpl molWrapper = (CmpdRegMoleculeRDKitImpl) inputStructure;
		CmpdRegMoleculeRDKitImpl mol = molWrapper.clone();
		RWMol clone = mol.molecule;
		List<CmpdRegMoleculeRDKitImpl> allFrags = new ArrayList<CmpdRegMoleculeRDKitImpl>();
	    ROMol_Vect frags = RDKFuncs.getMolFrags(clone);
		for (int i = 0; i < frags.size(); i++) {
			RWMol frag = (RWMol) frags.get(i);
			CmpdRegMoleculeRDKitImpl fragWrapper = new CmpdRegMoleculeRDKitImpl(frag);
			allFrags.add(fragWrapper);
		}
	
		Map<Salt, Integer> saltCounts = new HashMap<Salt, Integer>();
		Set<CmpdRegMoleculeRDKitImpl> unidentifiedFragments = new HashSet<CmpdRegMoleculeRDKitImpl>();
		for (CmpdRegMoleculeRDKitImpl fragment : allFrags){
			int[] cdIdMatches = searchMolStructures(fragment.getMolStructure(), "Salt_Structure", "DUPLICATE_TAUTOMER");
			if (cdIdMatches.length>0){
				Salt foundSalt = Salt.findSaltsByCdId(cdIdMatches[0]).getSingleResult();
				if (saltCounts.containsKey(foundSalt)) saltCounts.put(foundSalt, saltCounts.get(foundSalt)+1);
				else saltCounts.put(foundSalt, 1);
			}else{
				unidentifiedFragments.add(fragment);
			}
		}
		StrippedSaltDTO resultDTO = new StrippedSaltDTO();
		resultDTO.setSaltCounts(saltCounts);
		resultDTO.setUnidentifiedFragments(unidentifiedFragments);
		logger.debug("Identified stripped salts:");
		for (Salt salt : saltCounts.keySet()){
			logger.debug("Salt Abbrev: "+salt.getAbbrev());
			logger.debug("Salt Count: "+ saltCounts.get(salt));
		}
		return resultDTO;
	}

	@Override
	public String standardizeStructure(String molfile) throws CmpdRegMolFormatException, IOException {
		String molOut = null;

		// Read the preprocessor settings as json
		ObjectMapper objectMapper = new ObjectMapper();
		JsonNode jsonNode = objectMapper.readTree(propertiesUtilService.getPreprocessorSettings());

		// Extract the url to call
		JsonNode urlNode = jsonNode.get("preprocessURL");
		if(urlNode == null || urlNode.isNull()) {
			logger.error("Missing preprocessorSettings preprocessURL!!");
		}

		String url = urlNode.asText();

		ObjectMapper mapper = new ObjectMapper();
		ObjectNode requestData = mapper.createObjectNode();
		JsonNode standardizerActions = jsonNode.get("standardizer_actions");
		requestData.put("config", standardizerActions);
		requestData.put("output_format", "MOL");

		// Create a "structures": { "structure-id": "molfile" } object and add it to the request
		ObjectNode structuresNode = objectMapper.createObjectNode();
		String id = UUID.randomUUID().toString();
		structuresNode.put(id, molfile);
		requestData.put("structures", structuresNode);

		// Post to the service
		String postResponse = SimpleUtil.postRequestToExternalServer(url, requestData.toString(), logger);
		logger.info("Got response: "+ postResponse);

		// Parse the response json to get the standardized mol
		ObjectMapper responseMapper = new ObjectMapper();
		JsonNode responseNode = responseMapper.readTree(postResponse);
		JsonNode structuresResponseNode = responseNode.get("structures");
		JsonNode structureResponseNode = structuresResponseNode.get(id);
		molOut = structureResponseNode.get("structure").asText();
	
		return molOut;
	}

	@Override
	public boolean compareStructures(String preMolStruct, String postMolStruct, String string) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean standardizedMolCompare(String queryMol, String targetMol) throws CmpdRegMolFormatException {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean isEmpty(String molFile) throws CmpdRegMolFormatException {
		RWMol mol = RWMol.MolFromMolBlock(molFile);
		Boolean hasAtoms =  mol.getNumAtoms() == 0.0;
		Boolean hasBonds =  mol.getNumBonds() == 0.0;
		Boolean hasSGroups = RDKFuncs.getSubstanceGroupCount(mol) == 0.0;
		return !hasAtoms && !hasBonds && !hasSGroups;
	}

}

