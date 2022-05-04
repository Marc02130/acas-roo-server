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

@Configurable
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:/META-INF/spring/applicationContext*.xml")
@Transactional
public class ItxSubjectContainerStateIntegrationTest {

    @Test
    public void testMarkerMethod() {
    }

    @Autowired
    ItxSubjectContainerStateDataOnDemand dod;

    @Test
    public void testCountItxSubjectContainerStates() {
        Assert.assertNotNull("Data on demand for 'ItxSubjectContainerState' failed to initialize correctly",
                dod.getRandomItxSubjectContainerState());
        long count = ItxSubjectContainerState.countItxSubjectContainerStates();
        Assert.assertTrue("Counter for 'ItxSubjectContainerState' incorrectly reported there were no entries",
                count > 0);
    }

    @Test
    public void testFindItxSubjectContainerState() {
        ItxSubjectContainerState obj = dod.getRandomItxSubjectContainerState();
        Assert.assertNotNull("Data on demand for 'ItxSubjectContainerState' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ItxSubjectContainerState' failed to provide an identifier", id);
        obj = ItxSubjectContainerState.findItxSubjectContainerState(id);
        Assert.assertNotNull("Find method for 'ItxSubjectContainerState' illegally returned null for id '" + id + "'",
                obj);
        Assert.assertEquals("Find method for 'ItxSubjectContainerState' returned the incorrect identifier", id,
                obj.getId());
    }

    @Test
    public void testFindAllItxSubjectContainerStates() {
        Assert.assertNotNull("Data on demand for 'ItxSubjectContainerState' failed to initialize correctly",
                dod.getRandomItxSubjectContainerState());
        long count = ItxSubjectContainerState.countItxSubjectContainerStates();
        Assert.assertTrue("Too expensive to perform a find all test for 'ItxSubjectContainerState', as there are "
                + count
                + " entries; set the findAllMaximum to exceed this value or set findAll=false on the integration test annotation to disable the test",
                count < 250);
        List<ItxSubjectContainerState> result = ItxSubjectContainerState.findAllItxSubjectContainerStates();
        Assert.assertNotNull("Find all method for 'ItxSubjectContainerState' illegally returned null", result);
        Assert.assertTrue("Find all method for 'ItxSubjectContainerState' failed to return any data",
                result.size() > 0);
    }

    @Test
    public void testFindItxSubjectContainerStateEntries() {
        Assert.assertNotNull("Data on demand for 'ItxSubjectContainerState' failed to initialize correctly",
                dod.getRandomItxSubjectContainerState());
        long count = ItxSubjectContainerState.countItxSubjectContainerStates();
        if (count > 20)
            count = 20;
        int firstResult = 0;
        int maxResults = (int) count;
        List<ItxSubjectContainerState> result = ItxSubjectContainerState
                .findItxSubjectContainerStateEntries(firstResult, maxResults);
        Assert.assertNotNull("Find entries method for 'ItxSubjectContainerState' illegally returned null", result);
        Assert.assertEquals(
                "Find entries method for 'ItxSubjectContainerState' returned an incorrect number of entries", count,
                result.size());
    }

    @Test
    public void testFlush() {
        ItxSubjectContainerState obj = dod.getRandomItxSubjectContainerState();
        Assert.assertNotNull("Data on demand for 'ItxSubjectContainerState' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ItxSubjectContainerState' failed to provide an identifier", id);
        obj = ItxSubjectContainerState.findItxSubjectContainerState(id);
        Assert.assertNotNull("Find method for 'ItxSubjectContainerState' illegally returned null for id '" + id + "'",
                obj);
        boolean modified = dod.modifyItxSubjectContainerState(obj);
        Integer currentVersion = obj.getVersion();
        obj.flush();
        Assert.assertTrue("Version for 'ItxSubjectContainerState' failed to increment on flush directive",
                (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }

    @Test
    public void testMergeUpdate() {
        ItxSubjectContainerState obj = dod.getRandomItxSubjectContainerState();
        Assert.assertNotNull("Data on demand for 'ItxSubjectContainerState' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ItxSubjectContainerState' failed to provide an identifier", id);
        obj = ItxSubjectContainerState.findItxSubjectContainerState(id);
        boolean modified = dod.modifyItxSubjectContainerState(obj);
        Integer currentVersion = obj.getVersion();
        ItxSubjectContainerState merged = (ItxSubjectContainerState) obj.merge();
        obj.flush();
        Assert.assertEquals("Identifier of merged object not the same as identifier of original object", merged.getId(),
                id);
        Assert.assertTrue("Version for 'ItxSubjectContainerState' failed to increment on merge and flush directive",
                (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }

    @Test
    public void testPersist() {
        Assert.assertNotNull("Data on demand for 'ItxSubjectContainerState' failed to initialize correctly",
                dod.getRandomItxSubjectContainerState());
        ItxSubjectContainerState obj = dod.getNewTransientItxSubjectContainerState(Integer.MAX_VALUE);
        Assert.assertNotNull("Data on demand for 'ItxSubjectContainerState' failed to provide a new transient entity",
                obj);
        Assert.assertNull("Expected 'ItxSubjectContainerState' identifier to be null", obj.getId());
        try {
            obj.persist();
        } catch (final ConstraintViolationException e) {
            final StringBuilder msg = new StringBuilder();
            for (Iterator<ConstraintViolation<?>> iter = e.getConstraintViolations().iterator(); iter.hasNext();) {
                final ConstraintViolation<?> cv = iter.next();
                msg.append("[").append(cv.getRootBean().getClass().getName()).append(".").append(cv.getPropertyPath())
                        .append(": ").append(cv.getMessage()).append(" (invalid value = ").append(cv.getInvalidValue())
                        .append(")").append("]");
            }
            throw new IllegalStateException(msg.toString(), e);
        }
        obj.flush();
        Assert.assertNotNull("Expected 'ItxSubjectContainerState' identifier to no longer be null", obj.getId());
    }

    @Test
    public void testRemove() {
        ItxSubjectContainerState obj = dod.getRandomItxSubjectContainerState();
        Assert.assertNotNull("Data on demand for 'ItxSubjectContainerState' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'ItxSubjectContainerState' failed to provide an identifier", id);
        obj = ItxSubjectContainerState.findItxSubjectContainerState(id);
        obj.remove();
        obj.flush();
        Assert.assertNull("Failed to remove 'ItxSubjectContainerState' with identifier '" + id + "'",
                ItxSubjectContainerState.findItxSubjectContainerState(id));
    }
}
