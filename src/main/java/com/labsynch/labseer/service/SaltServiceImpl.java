package com.labsynch.labseer.service;

import java.io.FileNotFoundException;
import java.io.IOException;

import java.util.List;

import com.labsynch.labseer.chemclasses.CmpdRegMolecule;
import com.labsynch.labseer.chemclasses.CmpdRegMoleculeFactory;
import com.labsynch.labseer.chemclasses.CmpdRegSDFReader;
import com.labsynch.labseer.chemclasses.CmpdRegSDFReaderFactory;
import com.labsynch.labseer.chemclasses.CmpdRegSDFWriterFactory;
import com.labsynch.labseer.chemclasses.CmpdRegSDFWriter;

import com.labsynch.labseer.domain.Salt;
import com.labsynch.labseer.exceptions.CmpdRegMolFormatException;
import com.labsynch.labseer.service.ChemStructureService.SearchType;
import com.labsynch.labseer.service.ChemStructureService.StructureType;
import com.labsynch.labseer.utils.MoleculeUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SaltServiceImpl implements SaltService {

	Logger logger = LoggerFactory.getLogger(SaltServiceImpl.class);

	@Autowired
	private ChemStructureService saltStructServ;

	@Autowired
	CmpdRegMoleculeFactory cmpdRegMoleculeFactory;

	@Autowired
	CmpdRegSDFReaderFactory cmpdRegSDFReaderFactory;

	@Autowired
	public CmpdRegSDFWriterFactory cmpdRegSDFWriterFactory;

	@Autowired
	public CmpdRegSDFWriterFactory sdfWriterFactory;

	@Transactional
	@Override
	public int loadSalts(String saltSD_fileName) {
		// simple utility to load salts
		// fileName = "src/test/resources/Initial_Salts.sdf";
		int savedSaltCount = 0;
		try {
			// Open an input stream
			CmpdRegSDFReader mi = cmpdRegSDFReaderFactory.getCmpdRegSDFReader(saltSD_fileName);
			CmpdRegMolecule mol = null;
			Long saltCount = 0L;
			while ((mol = mi.readNextMol()) != null) {
				// save salt if no existing salt with the same Abbrev -- could do match by other
				// properties
				saltCount = Salt.countFindSaltsByAbbrevLike(MoleculeUtil.getMolProperty(mol, "code"));
				if (saltCount < 1) {
					saveSalt(mol);
					savedSaltCount++;
				}
			}
			mi.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (CmpdRegMolFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return savedSaltCount;
	}

	@Transactional
	private void saveSalt(CmpdRegMolecule mol) throws IOException, CmpdRegMolFormatException {
		Salt salt = new Salt();
		salt.setMolStructure(MoleculeUtil.exportMolAsText(mol, "mol"));
		salt.setOriginalStructure(MoleculeUtil.exportMolAsText(mol, "mol"));
		salt.setAbbrev(MoleculeUtil.getMolProperty(mol, "code"));
		salt.setName(MoleculeUtil.getMolProperty(mol, "Name"));
		salt.setFormula(mol.getFormula());
		salt.setMolWeight(mol.getMass());

		logger.debug("salt code: " + salt.getAbbrev());
		logger.debug("salt name: " + salt.getName());
		logger.debug("salt structure: " + salt.getMolStructure());

		int[] queryHits = saltStructServ.searchMolStructures(salt.getMolStructure(), StructureType.SALT,
				SearchType.DUPLICATE_NO_TAUTOMER);
		Integer cdId = 0;
		if (queryHits.length > 0) {
			cdId = 0;
		} else {
			cdId = saltStructServ.saveStructure(salt.getMolStructure(), StructureType.SALT);
		}
		salt.setCdId(cdId);

		if (salt.getCdId() > 0 && salt.getCdId() != -1) {
			salt.persist();
		} else {
			logger.error("Could not save the salt: " + salt.getAbbrev());
		}
	}

	@Transactional
	public String exportSalts() {
		CmpdRegSDFWriter sdfWriter = null;
		try {
			sdfWriter = sdfWriterFactory.getCmpdRegSDFBufferWriter();
		} catch (IllegalArgumentException e1) {
			e1.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		// Get List of Salts 
		List<Salt> allSaltList = Salt.findAllSalts();

		for (Salt salt : allSaltList) {
			try {
				CmpdRegMolecule currSalt = cmpdRegMoleculeFactory.getCmpdRegMolecule(salt.getMolStructure());
				currSalt.setProperty("name", salt.getName());
				currSalt.setProperty("abbrev", salt.getAbbrev());
				currSalt.setProperty("formula", salt.getFormula());
				currSalt.setProperty("molWeight", String.valueOf(salt.getMolWeight()));
				currSalt.setProperty("charge", String.valueOf(salt.getCharge()));
				sdfWriter.writeMol(currSalt);
			} catch (CmpdRegMolFormatException e) {
				logger.error("bad structure error: " + salt.getMolStructure());
			} catch (IOException e) {
				logger.error("IO error reading in molfile");
				e.printStackTrace();
			}

		}
		try {
			sdfWriter.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		logger.debug("output SDF: " + sdfWriter.getBufferString());
		return sdfWriter.getBufferString();
	}

}
