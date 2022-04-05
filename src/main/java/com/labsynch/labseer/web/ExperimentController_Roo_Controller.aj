// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.web;

import com.labsynch.labseer.domain.AnalysisGroup;
import com.labsynch.labseer.domain.Experiment;
import com.labsynch.labseer.domain.ExperimentLabel;
import com.labsynch.labseer.domain.ExperimentState;
import com.labsynch.labseer.domain.ItxExperimentExperiment;
import com.labsynch.labseer.domain.LsTag;
import com.labsynch.labseer.domain.Protocol;
import com.labsynch.labseer.domain.ThingPage;
import com.labsynch.labseer.web.ExperimentController;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.joda.time.format.DateTimeFormat;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect ExperimentController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String ExperimentController.create(@Valid Experiment experiment, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, experiment);
            return "experiments/create";
        }
        uiModel.asMap().clear();
        experiment.persist();
        return "redirect:/experiments/" + encodeUrlPathSegment(experiment.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String ExperimentController.createForm(Model uiModel) {
        populateEditForm(uiModel, new Experiment());
        List<String[]> dependencies = new ArrayList<String[]>();
        if (Protocol.countProtocols() == 0) {
            dependencies.add(new String[] { "protocol", "protocols" });
        }
        uiModel.addAttribute("dependencies", dependencies);
        return "experiments/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String ExperimentController.show(@PathVariable("id") Long id, Model uiModel) {
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("experiment", Experiment.findExperiment(id));
        uiModel.addAttribute("itemId", id);
        return "experiments/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String ExperimentController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, @RequestParam(value = "sortFieldName", required = false) String sortFieldName, @RequestParam(value = "sortOrder", required = false) String sortOrder, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("experiments", Experiment.findExperimentEntries(firstResult, sizeNo, sortFieldName, sortOrder));
            float nrOfPages = (float) Experiment.countExperiments() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("experiments", Experiment.findAllExperiments(sortFieldName, sortOrder));
        }
        addDateTimeFormatPatterns(uiModel);
        return "experiments/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String ExperimentController.update(@Valid Experiment experiment, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, experiment);
            return "experiments/update";
        }
        uiModel.asMap().clear();
        experiment.merge();
        return "redirect:/experiments/" + encodeUrlPathSegment(experiment.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String ExperimentController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, Experiment.findExperiment(id));
        return "experiments/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String ExperimentController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        Experiment experiment = Experiment.findExperiment(id);
        experiment.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/experiments";
    }
    
    void ExperimentController.addDateTimeFormatPatterns(Model uiModel) {
        uiModel.addAttribute("experiment_recordeddate_date_format", DateTimeFormat.patternForStyle("MM", LocaleContextHolder.getLocale()));
        uiModel.addAttribute("experiment_modifieddate_date_format", DateTimeFormat.patternForStyle("MM", LocaleContextHolder.getLocale()));
    }
    
    void ExperimentController.populateEditForm(Model uiModel, Experiment experiment) {
        uiModel.addAttribute("experiment", experiment);
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("analysisgroups", AnalysisGroup.findAllAnalysisGroups());
        uiModel.addAttribute("experimentlabels", ExperimentLabel.findAllExperimentLabels());
        uiModel.addAttribute("experimentstates", ExperimentState.findAllExperimentStates());
        uiModel.addAttribute("itxexperimentexperiments", ItxExperimentExperiment.findAllItxExperimentExperiments());
        uiModel.addAttribute("lstags", LsTag.findAllLsTags());
        uiModel.addAttribute("protocols", Protocol.findAllProtocols());
        uiModel.addAttribute("thingpages", ThingPage.findAllThingPages());
    }
    
    String ExperimentController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        return pathSegment;
    }
    
}
