// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.web;

import com.labsynch.labseer.domain.ContainerState;
import com.labsynch.labseer.domain.ContainerValue;
import com.labsynch.labseer.web.ContainerValueController;
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

privileged aspect ContainerValueController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String ContainerValueController.create(@Valid ContainerValue containerValue, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, containerValue);
            return "containervalues/create";
        }
        uiModel.asMap().clear();
        containerValue.persist();
        return "redirect:/containervalues/" + encodeUrlPathSegment(containerValue.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String ContainerValueController.createForm(Model uiModel) {
        populateEditForm(uiModel, new ContainerValue());
        List<String[]> dependencies = new ArrayList<String[]>();
        if (ContainerState.countContainerStates() == 0) {
            dependencies.add(new String[] { "containerstate", "containerstates" });
        }
        uiModel.addAttribute("dependencies", dependencies);
        return "containervalues/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String ContainerValueController.show(@PathVariable("id") Long id, Model uiModel) {
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("containervalue", ContainerValue.findContainerValue(id));
        uiModel.addAttribute("itemId", id);
        return "containervalues/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String ContainerValueController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("containervalues", ContainerValue.findContainerValueEntries(firstResult, sizeNo));
            float nrOfPages = (float) ContainerValue.countContainerValues() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("containervalues", ContainerValue.findAllContainerValues());
        }
        addDateTimeFormatPatterns(uiModel);
        return "containervalues/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String ContainerValueController.update(@Valid ContainerValue containerValue, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, containerValue);
            return "containervalues/update";
        }
        uiModel.asMap().clear();
        containerValue.merge();
        return "redirect:/containervalues/" + encodeUrlPathSegment(containerValue.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String ContainerValueController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, ContainerValue.findContainerValue(id));
        return "containervalues/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String ContainerValueController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        ContainerValue containerValue = ContainerValue.findContainerValue(id);
        containerValue.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/containervalues";
    }
    
    void ContainerValueController.addDateTimeFormatPatterns(Model uiModel) {
        uiModel.addAttribute("containerValue_datevalue_date_format", DateTimeFormat.patternForStyle("MM", LocaleContextHolder.getLocale()));
        uiModel.addAttribute("containerValue_recordeddate_date_format", DateTimeFormat.patternForStyle("MM", LocaleContextHolder.getLocale()));
        uiModel.addAttribute("containerValue_modifieddate_date_format", DateTimeFormat.patternForStyle("MM", LocaleContextHolder.getLocale()));
    }
    
    void ContainerValueController.populateEditForm(Model uiModel, ContainerValue containerValue) {
        uiModel.addAttribute("containerValue", containerValue);
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("containerstates", ContainerState.findAllContainerStates());
    }
    
    String ContainerValueController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        try {
            pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        } catch (UnsupportedEncodingException uee) {}
        return pathSegment;
    }
    
}
