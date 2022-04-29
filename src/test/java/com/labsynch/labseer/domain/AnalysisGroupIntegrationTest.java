package com.labsynch.labseer.domain;

import java.util.Iterator;
import java.util.List;
import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:/META-INF/spring/applicationContext*.xml")
@Transactional
@Configurable
public class AnalysisGroupIntegrationTest {

    @Test
    public void testMarkerMethod() {
    }

	@Autowired
    AnalysisGroupDataOnDemand dod;

	@Test
    public void testCountAnalysisGroups() {
        Assert.assertNotNull("Data on demand for 'AnalysisGroup' failed to initialize correctly", dod.getRandomAnalysisGroup());
        long count = AnalysisGroup.countAnalysisGroups();
        Assert.assertTrue("Counter for 'AnalysisGroup' incorrectly reported there were no entries", count > 0);
    }

	@Test
    public void testFindAnalysisGroup() {
        AnalysisGroup obj = dod.getRandomAnalysisGroup();
        Assert.assertNotNull("Data on demand for 'AnalysisGroup' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'AnalysisGroup' failed to provide an identifier", id);
        obj = AnalysisGroup.findAnalysisGroup(id);
        Assert.assertNotNull("Find method for 'AnalysisGroup' illegally returned null for id '" + id + "'", obj);
        Assert.assertEquals("Find method for 'AnalysisGroup' returned the incorrect identifier", id, obj.getId());
    }

	@Test
    public void testFindAllAnalysisGroups() {
        Assert.assertNotNull("Data on demand for 'AnalysisGroup' failed to initialize correctly", dod.getRandomAnalysisGroup());
        long count = AnalysisGroup.countAnalysisGroups();
        Assert.assertTrue("Too expensive to perform a find all test for 'AnalysisGroup', as there are " + count + " entries; set the findAllMaximum to exceed this value or set findAll=false on the integration test annotation to disable the test", count < 250);
        List<AnalysisGroup> result = AnalysisGroup.findAllAnalysisGroups();
        Assert.assertNotNull("Find all method for 'AnalysisGroup' illegally returned null", result);
        Assert.assertTrue("Find all method for 'AnalysisGroup' failed to return any data", result.size() > 0);
    }

	@Test
    public void testFindAnalysisGroupEntries() {
        Assert.assertNotNull("Data on demand for 'AnalysisGroup' failed to initialize correctly", dod.getRandomAnalysisGroup());
        long count = AnalysisGroup.countAnalysisGroups();
        if (count > 20) count = 20;
        int firstResult = 0;
        int maxResults = (int) count;
        List<AnalysisGroup> result = AnalysisGroup.findAnalysisGroupEntries(firstResult, maxResults);
        Assert.assertNotNull("Find entries method for 'AnalysisGroup' illegally returned null", result);
        Assert.assertEquals("Find entries method for 'AnalysisGroup' returned an incorrect number of entries", count, result.size());
    }

	@Test
    public void testFlush() {
        AnalysisGroup obj = dod.getRandomAnalysisGroup();
        Assert.assertNotNull("Data on demand for 'AnalysisGroup' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'AnalysisGroup' failed to provide an identifier", id);
        obj = AnalysisGroup.findAnalysisGroup(id);
        Assert.assertNotNull("Find method for 'AnalysisGroup' illegally returned null for id '" + id + "'", obj);
        boolean modified =  dod.modifyAnalysisGroup(obj);
        Integer currentVersion = obj.getVersion();
        obj.flush();
        Assert.assertTrue("Version for 'AnalysisGroup' failed to increment on flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }

	@Test
    public void testMergeUpdate() {
        AnalysisGroup obj = dod.getRandomAnalysisGroup();
        Assert.assertNotNull("Data on demand for 'AnalysisGroup' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'AnalysisGroup' failed to provide an identifier", id);
        obj = AnalysisGroup.findAnalysisGroup(id);
        boolean modified =  dod.modifyAnalysisGroup(obj);
        Integer currentVersion = obj.getVersion();
        AnalysisGroup merged = (AnalysisGroup)obj.merge();
        obj.flush();
        Assert.assertEquals("Identifier of merged object not the same as identifier of original object", merged.getId(), id);
        Assert.assertTrue("Version for 'AnalysisGroup' failed to increment on merge and flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }

	@Test
    public void testPersist() {
        Assert.assertNotNull("Data on demand for 'AnalysisGroup' failed to initialize correctly", dod.getRandomAnalysisGroup());
        AnalysisGroup obj = dod.getNewTransientAnalysisGroup(Integer.MAX_VALUE);
        Assert.assertNotNull("Data on demand for 'AnalysisGroup' failed to provide a new transient entity", obj);
        Assert.assertNull("Expected 'AnalysisGroup' identifier to be null", obj.getId());
        try {
            obj.persist();
        } catch (final ConstraintViolationException e) {
            final StringBuilder msg = new StringBuilder();
            for (Iterator<ConstraintViolation<?>> iter = e.getConstraintViolations().iterator(); iter.hasNext();) {
                final ConstraintViolation<?> cv = iter.next();
                msg.append("[").append(cv.getRootBean().getClass().getName()).append(".").append(cv.getPropertyPath()).append(": ").append(cv.getMessage()).append(" (invalid value = ").append(cv.getInvalidValue()).append(")").append("]");
            }
            throw new IllegalStateException(msg.toString(), e);
        }
        obj.flush();
        Assert.assertNotNull("Expected 'AnalysisGroup' identifier to no longer be null", obj.getId());
    }

	@Test
    public void testRemove() {
        AnalysisGroup obj = dod.getRandomAnalysisGroup();
        Assert.assertNotNull("Data on demand for 'AnalysisGroup' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'AnalysisGroup' failed to provide an identifier", id);
        obj = AnalysisGroup.findAnalysisGroup(id);
        obj.remove();
        obj.flush();
        Assert.assertNull("Failed to remove 'AnalysisGroup' with identifier '" + id + "'", AnalysisGroup.findAnalysisGroup(id));
    }
}
