// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.web;

import com.labsynch.labseer.domain.Subject;
import com.labsynch.labseer.domain.SubjectLabel;
import com.labsynch.labseer.web.SubjectLabelController;
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

privileged aspect SubjectLabelController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String SubjectLabelController.create(@Valid SubjectLabel subjectLabel, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, subjectLabel);
            return "subjectlabels/create";
        }
        uiModel.asMap().clear();
        subjectLabel.persist();
        return "redirect:/subjectlabels/" + encodeUrlPathSegment(subjectLabel.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String SubjectLabelController.createForm(Model uiModel) {
        populateEditForm(uiModel, new SubjectLabel());
        List<String[]> dependencies = new ArrayList<String[]>();
        if (Subject.countSubjects() == 0) {
            dependencies.add(new String[] { "subject", "subjects" });
        }
        uiModel.addAttribute("dependencies", dependencies);
        return "subjectlabels/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String SubjectLabelController.show(@PathVariable("id") Long id, Model uiModel) {
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("subjectlabel", SubjectLabel.findSubjectLabel(id));
        uiModel.addAttribute("itemId", id);
        return "subjectlabels/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String SubjectLabelController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, @RequestParam(value = "sortFieldName", required = false) String sortFieldName, @RequestParam(value = "sortOrder", required = false) String sortOrder, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("subjectlabels", SubjectLabel.findSubjectLabelEntries(firstResult, sizeNo, sortFieldName, sortOrder));
            float nrOfPages = (float) SubjectLabel.countSubjectLabels() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("subjectlabels", SubjectLabel.findAllSubjectLabels(sortFieldName, sortOrder));
        }
        addDateTimeFormatPatterns(uiModel);
        return "subjectlabels/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String SubjectLabelController.update(@Valid SubjectLabel subjectLabel, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, subjectLabel);
            return "subjectlabels/update";
        }
        uiModel.asMap().clear();
        subjectLabel.merge();
        return "redirect:/subjectlabels/" + encodeUrlPathSegment(subjectLabel.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String SubjectLabelController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, SubjectLabel.findSubjectLabel(id));
        return "subjectlabels/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String SubjectLabelController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        SubjectLabel subjectLabel = SubjectLabel.findSubjectLabel(id);
        subjectLabel.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/subjectlabels";
    }
    
    void SubjectLabelController.addDateTimeFormatPatterns(Model uiModel) {
        uiModel.addAttribute("subjectLabel_recordeddate_date_format", DateTimeFormat.patternForStyle("MM", LocaleContextHolder.getLocale()));
        uiModel.addAttribute("subjectLabel_modifieddate_date_format", DateTimeFormat.patternForStyle("MM", LocaleContextHolder.getLocale()));
    }
    
    void SubjectLabelController.populateEditForm(Model uiModel, SubjectLabel subjectLabel) {
        uiModel.addAttribute("subjectLabel", subjectLabel);
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("subjects", Subject.findAllSubjects());
    }
    
    String SubjectLabelController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        return pathSegment;
    }
    
}
