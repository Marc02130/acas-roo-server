// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.ValueType;
import com.labsynch.labseer.domain.ValueTypeDataOnDemand;
import com.labsynch.labseer.domain.ValueTypeIntegrationTest;
import java.util.List;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

privileged aspect ValueTypeIntegrationTest_Roo_IntegrationTest {
    
    declare @type: ValueTypeIntegrationTest: @RunWith(SpringJUnit4ClassRunner.class);
    
    declare @type: ValueTypeIntegrationTest: @ContextConfiguration(locations = "classpath:/META-INF/spring/applicationContext*.xml");
    
    declare @type: ValueTypeIntegrationTest: @Transactional;
    
    @Autowired
    ValueTypeDataOnDemand ValueTypeIntegrationTest.dod;
    
    @Test
    public void ValueTypeIntegrationTest.testCountValueTypes() {
        Assert.assertNotNull("Data on demand for 'ValueType' failed to initialize correctly", dod.getRandomValueType());
        long count = ValueType.countValueTypes();
        Assert.assertTrue("Counter for 'ValueType' incorrectly reported there were no entries", count > 0);
    }
    
    @Test
    public void ValueTypeIntegrationTest.testFindValueType() {
        ValueType obj = dod.getRandomValueType();
        Assert.assertNotNull("Data on demand for 'ValueType' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ValueType' failed to provide an identifier", id);
        obj = ValueType.findValueType(id);
        Assert.assertNotNull("Find method for 'ValueType' illegally returned null for id '" + id + "'", obj);
        Assert.assertEquals("Find method for 'ValueType' returned the incorrect identifier", id, obj.getId());
    }
    
    @Test
    public void ValueTypeIntegrationTest.testFindAllValueTypes() {
        Assert.assertNotNull("Data on demand for 'ValueType' failed to initialize correctly", dod.getRandomValueType());
        long count = ValueType.countValueTypes();
        Assert.assertTrue("Too expensive to perform a find all test for 'ValueType', as there are " + count + " entries; set the findAllMaximum to exceed this value or set findAll=false on the integration test annotation to disable the test", count < 250);
        List<ValueType> result = ValueType.findAllValueTypes();
        Assert.assertNotNull("Find all method for 'ValueType' illegally returned null", result);
        Assert.assertTrue("Find all method for 'ValueType' failed to return any data", result.size() > 0);
    }
    
    @Test
    public void ValueTypeIntegrationTest.testFindValueTypeEntries() {
        Assert.assertNotNull("Data on demand for 'ValueType' failed to initialize correctly", dod.getRandomValueType());
        long count = ValueType.countValueTypes();
        if (count > 20) count = 20;
        int firstResult = 0;
        int maxResults = (int) count;
        List<ValueType> result = ValueType.findValueTypeEntries(firstResult, maxResults);
        Assert.assertNotNull("Find entries method for 'ValueType' illegally returned null", result);
        Assert.assertEquals("Find entries method for 'ValueType' returned an incorrect number of entries", count, result.size());
    }
    
    @Test
    public void ValueTypeIntegrationTest.testFlush() {
        ValueType obj = dod.getRandomValueType();
        Assert.assertNotNull("Data on demand for 'ValueType' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ValueType' failed to provide an identifier", id);
        obj = ValueType.findValueType(id);
        Assert.assertNotNull("Find method for 'ValueType' illegally returned null for id '" + id + "'", obj);
        boolean modified =  dod.modifyValueType(obj);
        Integer currentVersion = obj.getVersion();
        obj.flush();
        Assert.assertTrue("Version for 'ValueType' failed to increment on flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }
    
    @Test
    public void ValueTypeIntegrationTest.testMergeUpdate() {
        ValueType obj = dod.getRandomValueType();
        Assert.assertNotNull("Data on demand for 'ValueType' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ValueType' failed to provide an identifier", id);
        obj = ValueType.findValueType(id);
        boolean modified =  dod.modifyValueType(obj);
        Integer currentVersion = obj.getVersion();
        ValueType merged = obj.merge();
        obj.flush();
        Assert.assertEquals("Identifier of merged object not the same as identifier of original object", merged.getId(), id);
        Assert.assertTrue("Version for 'ValueType' failed to increment on merge and flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }
    
    @Test
    public void ValueTypeIntegrationTest.testPersist() {
        Assert.assertNotNull("Data on demand for 'ValueType' failed to initialize correctly", dod.getRandomValueType());
        ValueType obj = dod.getNewTransientValueType(Integer.MAX_VALUE);
        Assert.assertNotNull("Data on demand for 'ValueType' failed to provide a new transient entity", obj);
        Assert.assertNull("Expected 'ValueType' identifier to be null", obj.getId());
        obj.persist();
        obj.flush();
        Assert.assertNotNull("Expected 'ValueType' identifier to no longer be null", obj.getId());
    }
    
    @Test
    public void ValueTypeIntegrationTest.testRemove() {
        ValueType obj = dod.getRandomValueType();
        Assert.assertNotNull("Data on demand for 'ValueType' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ValueType' failed to provide an identifier", id);
        obj = ValueType.findValueType(id);
        obj.remove();
        obj.flush();
        Assert.assertNull("Failed to remove 'ValueType' with identifier '" + id + "'", ValueType.findValueType(id));
    }
    
}
