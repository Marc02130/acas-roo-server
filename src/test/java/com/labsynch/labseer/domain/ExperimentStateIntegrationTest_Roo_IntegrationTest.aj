// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.ExperimentState;
import com.labsynch.labseer.domain.ExperimentStateDataOnDemand;
import com.labsynch.labseer.domain.ExperimentStateIntegrationTest;
import java.util.List;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

privileged aspect ExperimentStateIntegrationTest_Roo_IntegrationTest {
    
    declare @type: ExperimentStateIntegrationTest: @RunWith(SpringJUnit4ClassRunner.class);
    
    declare @type: ExperimentStateIntegrationTest: @ContextConfiguration(locations = "classpath:/META-INF/spring/applicationContext*.xml");
    
    declare @type: ExperimentStateIntegrationTest: @Transactional;
    
    @Autowired
    ExperimentStateDataOnDemand ExperimentStateIntegrationTest.dod;
    
    @Test
    public void ExperimentStateIntegrationTest.testCountExperimentStates() {
        Assert.assertNotNull("Data on demand for 'ExperimentState' failed to initialize correctly", dod.getRandomExperimentState());
        long count = ExperimentState.countExperimentStates();
        Assert.assertTrue("Counter for 'ExperimentState' incorrectly reported there were no entries", count > 0);
    }
    
    @Test
    public void ExperimentStateIntegrationTest.testFindExperimentState() {
        ExperimentState obj = dod.getRandomExperimentState();
        Assert.assertNotNull("Data on demand for 'ExperimentState' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ExperimentState' failed to provide an identifier", id);
        obj = ExperimentState.findExperimentState(id);
        Assert.assertNotNull("Find method for 'ExperimentState' illegally returned null for id '" + id + "'", obj);
        Assert.assertEquals("Find method for 'ExperimentState' returned the incorrect identifier", id, obj.getId());
    }
    
    @Test
    public void ExperimentStateIntegrationTest.testFindAllExperimentStates() {
        Assert.assertNotNull("Data on demand for 'ExperimentState' failed to initialize correctly", dod.getRandomExperimentState());
        long count = ExperimentState.countExperimentStates();
        Assert.assertTrue("Too expensive to perform a find all test for 'ExperimentState', as there are " + count + " entries; set the findAllMaximum to exceed this value or set findAll=false on the integration test annotation to disable the test", count < 250);
        List<ExperimentState> result = ExperimentState.findAllExperimentStates();
        Assert.assertNotNull("Find all method for 'ExperimentState' illegally returned null", result);
        Assert.assertTrue("Find all method for 'ExperimentState' failed to return any data", result.size() > 0);
    }
    
    @Test
    public void ExperimentStateIntegrationTest.testFindExperimentStateEntries() {
        Assert.assertNotNull("Data on demand for 'ExperimentState' failed to initialize correctly", dod.getRandomExperimentState());
        long count = ExperimentState.countExperimentStates();
        if (count > 20) count = 20;
        int firstResult = 0;
        int maxResults = (int) count;
        List<ExperimentState> result = ExperimentState.findExperimentStateEntries(firstResult, maxResults);
        Assert.assertNotNull("Find entries method for 'ExperimentState' illegally returned null", result);
        Assert.assertEquals("Find entries method for 'ExperimentState' returned an incorrect number of entries", count, result.size());
    }
    
    @Test
    public void ExperimentStateIntegrationTest.testFlush() {
        ExperimentState obj = dod.getRandomExperimentState();
        Assert.assertNotNull("Data on demand for 'ExperimentState' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ExperimentState' failed to provide an identifier", id);
        obj = ExperimentState.findExperimentState(id);
        Assert.assertNotNull("Find method for 'ExperimentState' illegally returned null for id '" + id + "'", obj);
        boolean modified =  dod.modifyExperimentState(obj);
        Integer currentVersion = obj.getVersion();
        obj.flush();
        Assert.assertTrue("Version for 'ExperimentState' failed to increment on flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }
    
    @Test
    public void ExperimentStateIntegrationTest.testMergeUpdate() {
        ExperimentState obj = dod.getRandomExperimentState();
        Assert.assertNotNull("Data on demand for 'ExperimentState' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ExperimentState' failed to provide an identifier", id);
        obj = ExperimentState.findExperimentState(id);
        boolean modified =  dod.modifyExperimentState(obj);
        Integer currentVersion = obj.getVersion();
        ExperimentState merged = (ExperimentState)obj.merge();
        obj.flush();
        Assert.assertEquals("Identifier of merged object not the same as identifier of original object", merged.getId(), id);
        Assert.assertTrue("Version for 'ExperimentState' failed to increment on merge and flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }
    
    @Test
    public void ExperimentStateIntegrationTest.testPersist() {
        Assert.assertNotNull("Data on demand for 'ExperimentState' failed to initialize correctly", dod.getRandomExperimentState());
        ExperimentState obj = dod.getNewTransientExperimentState(Integer.MAX_VALUE);
        Assert.assertNotNull("Data on demand for 'ExperimentState' failed to provide a new transient entity", obj);
        Assert.assertNull("Expected 'ExperimentState' identifier to be null", obj.getId());
        obj.persist();
        obj.flush();
        Assert.assertNotNull("Expected 'ExperimentState' identifier to no longer be null", obj.getId());
    }
    
    @Test
    public void ExperimentStateIntegrationTest.testRemove() {
        ExperimentState obj = dod.getRandomExperimentState();
        Assert.assertNotNull("Data on demand for 'ExperimentState' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ExperimentState' failed to provide an identifier", id);
        obj = ExperimentState.findExperimentState(id);
        obj.remove();
        obj.flush();
        Assert.assertNull("Failed to remove 'ExperimentState' with identifier '" + id + "'", ExperimentState.findExperimentState(id));
    }
    
}
