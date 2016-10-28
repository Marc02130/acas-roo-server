// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.domain;

import com.labsynch.labseer.domain.ThingKind;
import com.labsynch.labseer.domain.ThingKindDataOnDemand;
import com.labsynch.labseer.domain.ThingKindIntegrationTest;
import java.util.List;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

privileged aspect ThingKindIntegrationTest_Roo_IntegrationTest {
    
    declare @type: ThingKindIntegrationTest: @RunWith(SpringJUnit4ClassRunner.class);
    
    declare @type: ThingKindIntegrationTest: @ContextConfiguration(locations = "classpath:/META-INF/spring/applicationContext*.xml");
    
    declare @type: ThingKindIntegrationTest: @Transactional;
    
    @Autowired
    ThingKindDataOnDemand ThingKindIntegrationTest.dod;
    
    @Test
    public void ThingKindIntegrationTest.testCountThingKinds() {
        Assert.assertNotNull("Data on demand for 'ThingKind' failed to initialize correctly", dod.getRandomThingKind());
        long count = ThingKind.countThingKinds();
        Assert.assertTrue("Counter for 'ThingKind' incorrectly reported there were no entries", count > 0);
    }
    
    @Test
    public void ThingKindIntegrationTest.testFindThingKind() {
        ThingKind obj = dod.getRandomThingKind();
        Assert.assertNotNull("Data on demand for 'ThingKind' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ThingKind' failed to provide an identifier", id);
        obj = ThingKind.findThingKind(id);
        Assert.assertNotNull("Find method for 'ThingKind' illegally returned null for id '" + id + "'", obj);
        Assert.assertEquals("Find method for 'ThingKind' returned the incorrect identifier", id, obj.getId());
    }
    
    @Test
    public void ThingKindIntegrationTest.testFindAllThingKinds() {
        Assert.assertNotNull("Data on demand for 'ThingKind' failed to initialize correctly", dod.getRandomThingKind());
        long count = ThingKind.countThingKinds();
        Assert.assertTrue("Too expensive to perform a find all test for 'ThingKind', as there are " + count + " entries; set the findAllMaximum to exceed this value or set findAll=false on the integration test annotation to disable the test", count < 250);
        List<ThingKind> result = ThingKind.findAllThingKinds();
        Assert.assertNotNull("Find all method for 'ThingKind' illegally returned null", result);
        Assert.assertTrue("Find all method for 'ThingKind' failed to return any data", result.size() > 0);
    }
    
    @Test
    public void ThingKindIntegrationTest.testFindThingKindEntries() {
        Assert.assertNotNull("Data on demand for 'ThingKind' failed to initialize correctly", dod.getRandomThingKind());
        long count = ThingKind.countThingKinds();
        if (count > 20) count = 20;
        int firstResult = 0;
        int maxResults = (int) count;
        List<ThingKind> result = ThingKind.findThingKindEntries(firstResult, maxResults);
        Assert.assertNotNull("Find entries method for 'ThingKind' illegally returned null", result);
        Assert.assertEquals("Find entries method for 'ThingKind' returned an incorrect number of entries", count, result.size());
    }
    
    @Test
    public void ThingKindIntegrationTest.testFlush() {
        ThingKind obj = dod.getRandomThingKind();
        Assert.assertNotNull("Data on demand for 'ThingKind' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ThingKind' failed to provide an identifier", id);
        obj = ThingKind.findThingKind(id);
        Assert.assertNotNull("Find method for 'ThingKind' illegally returned null for id '" + id + "'", obj);
        boolean modified =  dod.modifyThingKind(obj);
        Integer currentVersion = obj.getVersion();
        obj.flush();
        Assert.assertTrue("Version for 'ThingKind' failed to increment on flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }
    
    @Test
    public void ThingKindIntegrationTest.testMergeUpdate() {
        ThingKind obj = dod.getRandomThingKind();
        Assert.assertNotNull("Data on demand for 'ThingKind' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ThingKind' failed to provide an identifier", id);
        obj = ThingKind.findThingKind(id);
        boolean modified =  dod.modifyThingKind(obj);
        Integer currentVersion = obj.getVersion();
        ThingKind merged = obj.merge();
        obj.flush();
        Assert.assertEquals("Identifier of merged object not the same as identifier of original object", merged.getId(), id);
        Assert.assertTrue("Version for 'ThingKind' failed to increment on merge and flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }
    
    @Test
    public void ThingKindIntegrationTest.testPersist() {
        Assert.assertNotNull("Data on demand for 'ThingKind' failed to initialize correctly", dod.getRandomThingKind());
        ThingKind obj = dod.getNewTransientThingKind(Integer.MAX_VALUE);
        Assert.assertNotNull("Data on demand for 'ThingKind' failed to provide a new transient entity", obj);
        Assert.assertNull("Expected 'ThingKind' identifier to be null", obj.getId());
        obj.persist();
        obj.flush();
        Assert.assertNotNull("Expected 'ThingKind' identifier to no longer be null", obj.getId());
    }
    
    @Test
    public void ThingKindIntegrationTest.testRemove() {
        ThingKind obj = dod.getRandomThingKind();
        Assert.assertNotNull("Data on demand for 'ThingKind' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ThingKind' failed to provide an identifier", id);
        obj = ThingKind.findThingKind(id);
        obj.remove();
        obj.flush();
        Assert.assertNull("Failed to remove 'ThingKind' with identifier '" + id + "'", ThingKind.findThingKind(id));
    }
    
}
