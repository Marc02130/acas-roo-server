package com.labsynch.labseer.service;


import java.awt.Image;
import java.awt.image.RenderedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.StringReader;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;

import javax.imageio.ImageIO;
import javax.persistence.EntityManager;
import javax.persistence.Query;

import org.apache.commons.codec.binary.Base64OutputStream;
import org.openscience.cdk.depict.Depiction;
import org.openscience.cdk.depict.DepictionGenerator;
import org.openscience.cdk.exception.CDKException;
import org.openscience.cdk.interfaces.IAtomContainer;
import org.openscience.cdk.io.MDLV2000Reader;
import org.openscience.cdk.silent.SilentChemObjectBuilder;
import org.openscience.cdk.smiles.SmilesGenerator;
import org.openscience.cdk.tools.manipulator.AtomContainerManipulator;
import org.openscience.cdk.tools.manipulator.MolecularFormulaManipulator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.labsynch.labseer.domain.ChemStructure;
import com.labsynch.labseer.dto.AutoLabelDTO;
import com.labsynch.labseer.dto.MolPropertiesDTO;
import com.labsynch.labseer.utils.PropertiesUtilService;

@Service
@Transactional
public class StructureServiceImpl implements StructureService {

	private static final Logger logger = LoggerFactory.getLogger(StructureServiceImpl.class);

	@Autowired
	private PropertiesUtilService propertiesUtilService;
	
	@Autowired
	private AutoLabelService autoLabelService;

	@Override
	public byte[] renderMolStructure(String molStructure, Integer hSize, Integer wSize, String format) throws IOException, CDKException{
		if (molStructure == null || molStructure.equalsIgnoreCase("")) throw new IllegalArgumentException("The molStructure argument is required");
		if (format == null || format.equalsIgnoreCase("") || !(format.equalsIgnoreCase("jpg") || format.equalsIgnoreCase("png"))) throw new IllegalArgumentException("The accepted formats are jpg or png");
		
		int WIDTH = hSize;
		int HEIGHT = wSize;
		IAtomContainer molecule = readMolStructure(molStructure);
		DepictionGenerator sdg = new DepictionGenerator().withSize(WIDTH, HEIGHT).withFillToFit();
		Depiction depiction = sdg.depict(molecule);
		Image image = depiction.toImg();

		ByteArrayOutputStream baos=new ByteArrayOutputStream();
		ImageIO.write((RenderedImage) image, format, baos );
		byte[] imageInByte = baos.toByteArray();

		return imageInByte;
	}
	
	@Override
	public String renderMolStructureBase64(String molStructure, Integer hSize, Integer wSize, String format) throws IOException, CDKException{
		if (molStructure == null || molStructure.equalsIgnoreCase("")) throw new IllegalArgumentException("The molStructure argument is required");
//		if (format == null || format.equalsIgnoreCase("") || !(format.equalsIgnoreCase("jpg") || format.equalsIgnoreCase("png"))) throw new IllegalArgumentException("The accepted formats are jpg or png");
		
		int WIDTH = hSize;
		int HEIGHT = wSize;
		IAtomContainer molecule = readMolStructure(molStructure);
		DepictionGenerator sdg = new DepictionGenerator().withSize(WIDTH, HEIGHT).withFillToFit();
		Depiction depiction = sdg.depict(molecule);
		Image image = depiction.toImg();
		
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		String result = null;
		  try
		  {
			  OutputStream b64 = new Base64OutputStream(os);
			  ImageIO.write((RenderedImage) image, "png", b64);
			  result = os.toString("UTF-8");
			  b64.close();
			  os.close();
		  }
		  catch (final IOException ioe)
		  {
		    throw new RuntimeException(ioe);
		  }

		return result;
	}

	@Override
	public MolPropertiesDTO calculateMoleculeProperties(String molStructure)
			throws IOException, CDKException {
		if (molStructure == null || molStructure.equalsIgnoreCase("")) throw new IllegalArgumentException("The molStructure argument is required");
		IAtomContainer molecule = readMolStructure(molStructure);
		
		MolPropertiesDTO result = new MolPropertiesDTO();
		result.setMolStructure(molStructure);
		result.setMolWeight(AtomContainerManipulator.getNaturalExactMass(molecule));
		result.setMolFormula(MolecularFormulaManipulator.getString(MolecularFormulaManipulator.getMolecularFormula(molecule)));
        result.setSmiles(SmilesGenerator.unique().create(molecule));
		return result;
	}

	@Override
	public ChemStructure saveStructure(ChemStructure structure) throws IOException, CDKException{
		logger.debug(structure.toJson());
		ChemStructure newStructure = new ChemStructure(structure);
		logger.debug(newStructure.toJson());
		if (structure.getCodeName() == null){
			String thingTypeAndKind = "structure_chemical";
			String labelTypeAndKind = "id_codeName";
			Long numberOfLabels = 1L;
			List<AutoLabelDTO> labels = autoLabelService.getAutoLabels(thingTypeAndKind, labelTypeAndKind, numberOfLabels );
			newStructure.setCodeName(labels.get(0).getAutoLabel());
		}
		newStructure.persist();
		return newStructure;
	}

	@Override
	public ChemStructure updateStructure(ChemStructure structure) {
		ChemStructure updatedStructure = ChemStructure.update(structure);
		return updatedStructure;
	}
	
	private IAtomContainer readMolStructure(String molStructure) throws IOException, CDKException{
		MDLV2000Reader mdlReader = new MDLV2000Reader(new StringReader (molStructure));
		IAtomContainer molecule = SilentChemObjectBuilder.getInstance().newInstance(IAtomContainer.class);
		molecule = mdlReader.read(molecule);
		mdlReader.close();
		return molecule;
	}

	@Override
	public byte[] renderStructureByCodeName(String codeName, Integer height,
			Integer width, String format) throws IOException, CDKException {
		ChemStructure structure = ChemStructure.findStructureByCodeName(codeName);
		return renderMolStructure(structure.getMolStructure(), height, width, format);
	}

	@Override
	public Collection<ChemStructure> searchStructuresByTypeKind(String queryMol, String lsType, String lsKind, String searchType, Integer maxResults, Float similarity){
		String chemistryPackage = propertiesUtilService.getChemistryPackage();
		if (chemistryPackage == null) chemistryPackage = "rdkit";
		Collection<ChemStructure> searchResults = new HashSet<ChemStructure>();
		if (chemistryPackage.equalsIgnoreCase("rdkit")){
			if (searchType.equalsIgnoreCase("SUBSTRUCTURE")){
				searchResults = rdkitSubstructureSearch(queryMol, maxResults);
			}else if (searchType.equalsIgnoreCase("SIMILARITY")){
				searchResults = rdkitSimilaritySearch(queryMol, similarity, maxResults);
			}else if (searchType.equalsIgnoreCase("EXACT")){
				searchResults = rdkitExactSearch(queryMol, lsType, lsKind, maxResults);
			}
		}else{
			logger.error("Configured chemistry package not set up!! "+chemistryPackage);
		}
		return searchResults;
	}
	
	private Collection<ChemStructure> rdkitExactSearch(String queryMol, String lsType, String lsKind, Integer maxResults) {
		if (lsType == null && lsKind == null){
			return (rdkitExactSearchNoTypeKind(queryMol, maxResults));
		} else {
			String queryString = "SELECT s.* FROM Structure s WHERE rdkmol @= mol_from_ctab( CAST( :queryMol AS cstring)) AND ls_type = :lsType AND ls_kind = :lsKind";
			EntityManager em = ChemStructure.entityManager();
			Query q = em.createNativeQuery(queryString, ChemStructure.class);
			q.setParameter("queryMol", queryMol);
			q.setParameter("lsType", lsType);
			q.setParameter("lsKind", lsKind);
			if (maxResults != null) q.setMaxResults(maxResults);
			return q.getResultList();
		}
	}
	
	private Collection<ChemStructure> rdkitExactSearchNoTypeKind(String queryMol, Integer maxResults) {
		String queryString = "SELECT s.* FROM Structure s WHERE rdkmol @= mol_from_ctab( CAST( :queryMol AS cstring))";
		EntityManager em = ChemStructure.entityManager();
		Query q = em.createNativeQuery(queryString, ChemStructure.class);
		q.setParameter("queryMol", queryMol);
		if (maxResults != null) q.setMaxResults(maxResults);
		return q.getResultList();
	}

	@Override
	public Collection<ChemStructure> searchStructures(String queryMol, String searchType, Integer maxResults, Float similarity){
		String chemistryPackage = propertiesUtilService.getChemistryPackage();
		if (chemistryPackage == null) chemistryPackage = "rdkit";
		Collection<ChemStructure> searchResults = new HashSet<ChemStructure>();
		if (chemistryPackage.equalsIgnoreCase("rdkit")){
			if (searchType.equalsIgnoreCase("SUBSTRUCTURE")){
				searchResults = rdkitSubstructureSearch(queryMol, maxResults);
			}else if (searchType.equalsIgnoreCase("SIMILARITY")){
				searchResults = rdkitSimilaritySearch(queryMol, similarity, maxResults);
			}else if (searchType.equalsIgnoreCase("EXACT")){
				searchResults = rdkitExactSearch(queryMol, maxResults);
			}
		}else{
			logger.error("Configured chemistry package not set up!! "+chemistryPackage);
		}
		return searchResults;
	}
	
	@Override
	public Collection<String> searchStructuresCodes(String queryMol, String searchType, Integer maxResults, Float similarity){
		String chemistryPackage = propertiesUtilService.getChemistryPackage();
		if (chemistryPackage == null) chemistryPackage = "rdkit";
		Collection<String> searchResults = new HashSet<String>();
		if (chemistryPackage.equalsIgnoreCase("rdkit")){
			searchResults = rdkitSubstructureSearchCodes(queryMol, maxResults);
		}else{
			logger.error("Configured chemistry package not set up!! "+chemistryPackage);
		}
		return searchResults;
	}

	private Collection<ChemStructure> rdkitExactSearch(String queryMol,
			Integer maxResults) {
		String queryString = "SELECT s.* FROM Structure s WHERE rdkmol @= mol_from_ctab( CAST( :queryMol AS cstring))";
		EntityManager em = ChemStructure.entityManager();
		Query q = em.createNativeQuery(queryString, ChemStructure.class);
		q.setParameter("queryMol", queryMol);
		if (maxResults != null) q.setMaxResults(maxResults);
		return q.getResultList();
	}

	private Collection<ChemStructure> rdkitSimilaritySearch(String queryMol,
			Float similarity, Integer maxResults) {
		EntityManager em = ChemStructure.entityManager();
		if (similarity != null){
			String similarityQueryString = "set rdkit.tanimoto_threshold = "+similarity.toString();
			Query similarityQuery = em.createNativeQuery(similarityQueryString);
			similarityQuery.executeUpdate();
			logger.debug("set tanimoto threshold to "+similarity.toString());
		}
		String queryString = "SELECT s.* FROM Structure s JOIN get_mfp2_neighbors_mol(mol_from_ctab( CAST( :queryMol AS cstring))) similarity ON s.id = similarity.id";
		Query q = em.createNativeQuery(queryString, ChemStructure.class);
		q.setParameter("queryMol", queryMol);
		if (maxResults != null) q.setMaxResults(maxResults);
		return q.getResultList();
	}

	private Collection<ChemStructure> rdkitSubstructureSearch(String queryMol,
			Integer maxResults) {
		String queryString = "SELECT s.* FROM Structure s WHERE rdkmol @> qmol_from_ctab( CAST( :queryMol AS cstring))";
		logger.info("query string " + queryString);
		EntityManager em = ChemStructure.entityManager();
		Query q = em.createNativeQuery(queryString, ChemStructure.class);
		q.setParameter("queryMol", queryMol);
		if (maxResults != null) q.setMaxResults(maxResults);
		return q.getResultList();
	}

	private Collection<String> rdkitSubstructureSearchCodes(String queryMol, Integer maxResults) {
		String queryString = "SELECT s.code_name FROM structure s WHERE s.ignored <> '1' AND rdkmol @> qmol_from_ctab( CAST( :queryMol AS cstring))";
		EntityManager em = ChemStructure.entityManager();
		Query q = em.createNativeQuery(queryString);
		q.setParameter("queryMol", queryMol);
		if (maxResults != null) q.setMaxResults(maxResults);
		return q.getResultList();
	}
	
	private Collection<ChemStructure> substructureSearchInLsThingList(String queryMol, List<Long> thingIdList,
			Integer maxResults) {
		String queryString = "SELECT s.* FROM Structure s WHERE rdkmol @> qmol_from_ctab( CAST( :queryMol AS cstring))";
		EntityManager em = ChemStructure.entityManager();
		Query q = em.createNativeQuery(queryString, ChemStructure.class);
		q.setParameter("queryMol", queryMol);
		if (maxResults != null) q.setMaxResults(maxResults);
		return q.getResultList();
	}
	
	}
