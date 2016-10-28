// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.AnalysisGroupValue;
import com.labsynch.labseer.domain.AnalysisGroupValueDataOnDemand;
import com.labsynch.labseer.domain.AnalysisGroupValueIntegrationTest;
import java.util.List;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

privileged aspect AnalysisGroupValueIntegrationTest_Roo_IntegrationTest {
    
    declare @type: AnalysisGroupValueIntegrationTest: @RunWith(SpringJUnit4ClassRunner.class);
    
    declare @type: AnalysisGroupValueIntegrationTest: @ContextConfiguration(locations = "classpath:/META-INF/spring/applicationContext*.xml");
    
    declare @type: AnalysisGroupValueIntegrationTest: @Transactional;
    
    @Autowired
    AnalysisGroupValueDataOnDemand AnalysisGroupValueIntegrationTest.dod;
    
    @Test
    public void AnalysisGroupValueIntegrationTest.testCountAnalysisGroupValues() {
        Assert.assertNotNull("Data on demand for 'AnalysisGroupValue' failed to initialize correctly", dod.getRandomAnalysisGroupValue());
        long count = AnalysisGroupValue.countAnalysisGroupValues();
        Assert.assertTrue("Counter for 'AnalysisGroupValue' incorrectly reported there were no entries", count > 0);
    }
    
    @Test
    public void AnalysisGroupValueIntegrationTest.testFindAnalysisGroupValue() {
        AnalysisGroupValue obj = dod.getRandomAnalysisGroupValue();
        Assert.assertNotNull("Data on demand for 'AnalysisGroupValue' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'AnalysisGroupValue' failed to provide an identifier", id);
        obj = AnalysisGroupValue.findAnalysisGroupValue(id);
        Assert.assertNotNull("Find method for 'AnalysisGroupValue' illegally returned null for id '" + id + "'", obj);
        Assert.assertEquals("Find method for 'AnalysisGroupValue' returned the incorrect identifier", id, obj.getId());
    }
    
    @Test
    public void AnalysisGroupValueIntegrationTest.testFindAllAnalysisGroupValues() {
        Assert.assertNotNull("Data on demand for 'AnalysisGroupValue' failed to initialize correctly", dod.getRandomAnalysisGroupValue());
        long count = AnalysisGroupValue.countAnalysisGroupValues();
        Assert.assertTrue("Too expensive to perform a find all test for 'AnalysisGroupValue', as there are " + count + " entries; set the findAllMaximum to exceed this value or set findAll=false on the integration test annotation to disable the test", count < 250);
        List<AnalysisGroupValue> result = AnalysisGroupValue.findAllAnalysisGroupValues();
        Assert.assertNotNull("Find all method for 'AnalysisGroupValue' illegally returned null", result);
        Assert.assertTrue("Find all method for 'AnalysisGroupValue' failed to return any data", result.size() > 0);
    }
    
    @Test
    public void AnalysisGroupValueIntegrationTest.testFindAnalysisGroupValueEntries() {
        Assert.assertNotNull("Data on demand for 'AnalysisGroupValue' failed to initialize correctly", dod.getRandomAnalysisGroupValue());
        long count = AnalysisGroupValue.countAnalysisGroupValues();
        if (count > 20) count = 20;
        int firstResult = 0;
        int maxResults = (int) count;
        List<AnalysisGroupValue> result = AnalysisGroupValue.findAnalysisGroupValueEntries(firstResult, maxResults);
        Assert.assertNotNull("Find entries method for 'AnalysisGroupValue' illegally returned null", result);
        Assert.assertEquals("Find entries method for 'AnalysisGroupValue' returned an incorrect number of entries", count, result.size());
    }
    
    @Test
    public void AnalysisGroupValueIntegrationTest.testFlush() {
        AnalysisGroupValue obj = dod.getRandomAnalysisGroupValue();
        Assert.assertNotNull("Data on demand for 'AnalysisGroupValue' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'AnalysisGroupValue' failed to provide an identifier", id);
        obj = AnalysisGroupValue.findAnalysisGroupValue(id);
        Assert.assertNotNull("Find method for 'AnalysisGroupValue' illegally returned null for id '" + id + "'", obj);
        boolean modified =  dod.modifyAnalysisGroupValue(obj);
        Integer currentVersion = obj.getVersion();
        obj.flush();
        Assert.assertTrue("Version for 'AnalysisGroupValue' failed to increment on flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }
    
    @Test
    public void AnalysisGroupValueIntegrationTest.testMergeUpdate() {
        AnalysisGroupValue obj = dod.getRandomAnalysisGroupValue();
        Assert.assertNotNull("Data on demand for 'AnalysisGroupValue' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'AnalysisGroupValue' failed to provide an identifier", id);
        obj = AnalysisGroupValue.findAnalysisGroupValue(id);
        boolean modified =  dod.modifyAnalysisGroupValue(obj);
        Integer currentVersion = obj.getVersion();
        AnalysisGroupValue merged = (AnalysisGroupValue)obj.merge();
        obj.flush();
        Assert.assertEquals("Identifier of merged object not the same as identifier of original object", merged.getId(), id);
        Assert.assertTrue("Version for 'AnalysisGroupValue' failed to increment on merge and flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }
    
    @Test
    public void AnalysisGroupValueIntegrationTest.testPersist() {
        Assert.assertNotNull("Data on demand for 'AnalysisGroupValue' failed to initialize correctly", dod.getRandomAnalysisGroupValue());
        AnalysisGroupValue obj = dod.getNewTransientAnalysisGroupValue(Integer.MAX_VALUE);
        Assert.assertNotNull("Data on demand for 'AnalysisGroupValue' failed to provide a new transient entity", obj);
        Assert.assertNull("Expected 'AnalysisGroupValue' identifier to be null", obj.getId());
        obj.persist();
        obj.flush();
        Assert.assertNotNull("Expected 'AnalysisGroupValue' identifier to no longer be null", obj.getId());
    }
    
    @Test
    public void AnalysisGroupValueIntegrationTest.testRemove() {
        AnalysisGroupValue obj = dod.getRandomAnalysisGroupValue();
        Assert.assertNotNull("Data on demand for 'AnalysisGroupValue' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'AnalysisGroupValue' failed to provide an identifier", id);
        obj = AnalysisGroupValue.findAnalysisGroupValue(id);
        obj.remove();
        obj.flush();
        Assert.assertNull("Failed to remove 'AnalysisGroupValue' with identifier '" + id + "'", AnalysisGroupValue.findAnalysisGroupValue(id));
    }
    
}
