// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.web;

import com.labsynch.labseer.domain.Container;
import com.labsynch.labseer.domain.ItxContainerContainer;
import com.labsynch.labseer.domain.ItxContainerContainerState;
import com.labsynch.labseer.domain.ThingPage;
import com.labsynch.labseer.web.ItxContainerContainerController;
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

privileged aspect ItxContainerContainerController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String ItxContainerContainerController.create(@Valid ItxContainerContainer itxContainerContainer, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, itxContainerContainer);
            return "itxcontainercontainers/create";
        }
        uiModel.asMap().clear();
        itxContainerContainer.persist();
        return "redirect:/itxcontainercontainers/" + encodeUrlPathSegment(itxContainerContainer.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String ItxContainerContainerController.createForm(Model uiModel) {
        populateEditForm(uiModel, new ItxContainerContainer());
        List<String[]> dependencies = new ArrayList<String[]>();
        if (Container.countContainers() == 0) {
            dependencies.add(new String[] { "firstContainer", "containers" });
        }
        if (Container.countContainers() == 0) {
            dependencies.add(new String[] { "secondContainer", "containers" });
        }
        uiModel.addAttribute("dependencies", dependencies);
        return "itxcontainercontainers/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String ItxContainerContainerController.show(@PathVariable("id") Long id, Model uiModel) {
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("itxcontainercontainer", ItxContainerContainer.findItxContainerContainer(id));
        uiModel.addAttribute("itemId", id);
        return "itxcontainercontainers/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String ItxContainerContainerController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, @RequestParam(value = "sortFieldName", required = false) String sortFieldName, @RequestParam(value = "sortOrder", required = false) String sortOrder, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("itxcontainercontainers", ItxContainerContainer.findItxContainerContainerEntries(firstResult, sizeNo, sortFieldName, sortOrder));
            float nrOfPages = (float) ItxContainerContainer.countItxContainerContainers() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("itxcontainercontainers", ItxContainerContainer.findAllItxContainerContainers(sortFieldName, sortOrder));
        }
        addDateTimeFormatPatterns(uiModel);
        return "itxcontainercontainers/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String ItxContainerContainerController.update(@Valid ItxContainerContainer itxContainerContainer, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, itxContainerContainer);
            return "itxcontainercontainers/update";
        }
        uiModel.asMap().clear();
        itxContainerContainer.merge();
        return "redirect:/itxcontainercontainers/" + encodeUrlPathSegment(itxContainerContainer.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String ItxContainerContainerController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, ItxContainerContainer.findItxContainerContainer(id));
        return "itxcontainercontainers/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String ItxContainerContainerController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        ItxContainerContainer itxContainerContainer = ItxContainerContainer.findItxContainerContainer(id);
        itxContainerContainer.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/itxcontainercontainers";
    }
    
    void ItxContainerContainerController.addDateTimeFormatPatterns(Model uiModel) {
        uiModel.addAttribute("itxContainerContainer_recordeddate_date_format", DateTimeFormat.patternForStyle("MM", LocaleContextHolder.getLocale()));
        uiModel.addAttribute("itxContainerContainer_modifieddate_date_format", DateTimeFormat.patternForStyle("MM", LocaleContextHolder.getLocale()));
    }
    
    void ItxContainerContainerController.populateEditForm(Model uiModel, ItxContainerContainer itxContainerContainer) {
        uiModel.addAttribute("itxContainerContainer", itxContainerContainer);
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("containers", Container.findAllContainers());
        uiModel.addAttribute("itxcontainercontainerstates", ItxContainerContainerState.findAllItxContainerContainerStates());
        uiModel.addAttribute("thingpages", ThingPage.findAllThingPages());
    }
    
    String ItxContainerContainerController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        return pathSegment;
    }
    
}
