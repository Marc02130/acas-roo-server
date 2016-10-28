// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.ContainerValue;
import com.labsynch.labseer.domain.ContainerValueDataOnDemand;
import com.labsynch.labseer.domain.ContainerValueIntegrationTest;
import java.util.List;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

privileged aspect ContainerValueIntegrationTest_Roo_IntegrationTest {
    
    declare @type: ContainerValueIntegrationTest: @RunWith(SpringJUnit4ClassRunner.class);
    
    declare @type: ContainerValueIntegrationTest: @ContextConfiguration(locations = "classpath:/META-INF/spring/applicationContext*.xml");
    
    declare @type: ContainerValueIntegrationTest: @Transactional;
    
    @Autowired
    ContainerValueDataOnDemand ContainerValueIntegrationTest.dod;
    
    @Test
    public void ContainerValueIntegrationTest.testCountContainerValues() {
        Assert.assertNotNull("Data on demand for 'ContainerValue' failed to initialize correctly", dod.getRandomContainerValue());
        long count = ContainerValue.countContainerValues();
        Assert.assertTrue("Counter for 'ContainerValue' incorrectly reported there were no entries", count > 0);
    }
    
    @Test
    public void ContainerValueIntegrationTest.testFindContainerValue() {
        ContainerValue obj = dod.getRandomContainerValue();
        Assert.assertNotNull("Data on demand for 'ContainerValue' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ContainerValue' failed to provide an identifier", id);
        obj = ContainerValue.findContainerValue(id);
        Assert.assertNotNull("Find method for 'ContainerValue' illegally returned null for id '" + id + "'", obj);
        Assert.assertEquals("Find method for 'ContainerValue' returned the incorrect identifier", id, obj.getId());
    }
    
    @Test
    public void ContainerValueIntegrationTest.testFindAllContainerValues() {
        Assert.assertNotNull("Data on demand for 'ContainerValue' failed to initialize correctly", dod.getRandomContainerValue());
        long count = ContainerValue.countContainerValues();
        Assert.assertTrue("Too expensive to perform a find all test for 'ContainerValue', as there are " + count + " entries; set the findAllMaximum to exceed this value or set findAll=false on the integration test annotation to disable the test", count < 250);
        List<ContainerValue> result = ContainerValue.findAllContainerValues();
        Assert.assertNotNull("Find all method for 'ContainerValue' illegally returned null", result);
        Assert.assertTrue("Find all method for 'ContainerValue' failed to return any data", result.size() > 0);
    }
    
    @Test
    public void ContainerValueIntegrationTest.testFindContainerValueEntries() {
        Assert.assertNotNull("Data on demand for 'ContainerValue' failed to initialize correctly", dod.getRandomContainerValue());
        long count = ContainerValue.countContainerValues();
        if (count > 20) count = 20;
        int firstResult = 0;
        int maxResults = (int) count;
        List<ContainerValue> result = ContainerValue.findContainerValueEntries(firstResult, maxResults);
        Assert.assertNotNull("Find entries method for 'ContainerValue' illegally returned null", result);
        Assert.assertEquals("Find entries method for 'ContainerValue' returned an incorrect number of entries", count, result.size());
    }
    
    @Test
    public void ContainerValueIntegrationTest.testFlush() {
        ContainerValue obj = dod.getRandomContainerValue();
        Assert.assertNotNull("Data on demand for 'ContainerValue' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ContainerValue' failed to provide an identifier", id);
        obj = ContainerValue.findContainerValue(id);
        Assert.assertNotNull("Find method for 'ContainerValue' illegally returned null for id '" + id + "'", obj);
        boolean modified =  dod.modifyContainerValue(obj);
        Integer currentVersion = obj.getVersion();
        obj.flush();
        Assert.assertTrue("Version for 'ContainerValue' failed to increment on flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }
    
    @Test
    public void ContainerValueIntegrationTest.testMergeUpdate() {
        ContainerValue obj = dod.getRandomContainerValue();
        Assert.assertNotNull("Data on demand for 'ContainerValue' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ContainerValue' failed to provide an identifier", id);
        obj = ContainerValue.findContainerValue(id);
        boolean modified =  dod.modifyContainerValue(obj);
        Integer currentVersion = obj.getVersion();
        ContainerValue merged = (ContainerValue)obj.merge();
        obj.flush();
        Assert.assertEquals("Identifier of merged object not the same as identifier of original object", merged.getId(), id);
        Assert.assertTrue("Version for 'ContainerValue' failed to increment on merge and flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }
    
    @Test
    public void ContainerValueIntegrationTest.testPersist() {
        Assert.assertNotNull("Data on demand for 'ContainerValue' failed to initialize correctly", dod.getRandomContainerValue());
        ContainerValue obj = dod.getNewTransientContainerValue(Integer.MAX_VALUE);
        Assert.assertNotNull("Data on demand for 'ContainerValue' failed to provide a new transient entity", obj);
        Assert.assertNull("Expected 'ContainerValue' identifier to be null", obj.getId());
        obj.persist();
        obj.flush();
        Assert.assertNotNull("Expected 'ContainerValue' identifier to no longer be null", obj.getId());
    }
    
    @Test
    public void ContainerValueIntegrationTest.testRemove() {
        ContainerValue obj = dod.getRandomContainerValue();
        Assert.assertNotNull("Data on demand for 'ContainerValue' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ContainerValue' failed to provide an identifier", id);
        obj = ContainerValue.findContainerValue(id);
        obj.remove();
        obj.flush();
        Assert.assertNull("Failed to remove 'ContainerValue' with identifier '" + id + "'", ContainerValue.findContainerValue(id));
    }
    
}
