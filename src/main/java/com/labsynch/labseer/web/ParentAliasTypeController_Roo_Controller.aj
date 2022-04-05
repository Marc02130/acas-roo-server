// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.web;

import com.labsynch.labseer.domain.ParentAliasType;
import com.labsynch.labseer.web.ParentAliasTypeController;
import java.io.UnsupportedEncodingException;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect ParentAliasTypeController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String ParentAliasTypeController.create(@Valid ParentAliasType parentAliasType, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, parentAliasType);
            return "parentaliastypes/create";
        }
        uiModel.asMap().clear();
        parentAliasType.persist();
        return "redirect:/parentaliastypes/" + encodeUrlPathSegment(parentAliasType.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String ParentAliasTypeController.createForm(Model uiModel) {
        populateEditForm(uiModel, new ParentAliasType());
        return "parentaliastypes/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String ParentAliasTypeController.show(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("parentaliastype", ParentAliasType.findParentAliasType(id));
        uiModel.addAttribute("itemId", id);
        return "parentaliastypes/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String ParentAliasTypeController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, @RequestParam(value = "sortFieldName", required = false) String sortFieldName, @RequestParam(value = "sortOrder", required = false) String sortOrder, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("parentaliastypes", ParentAliasType.findParentAliasTypeEntries(firstResult, sizeNo, sortFieldName, sortOrder));
            float nrOfPages = (float) ParentAliasType.countParentAliasTypes() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("parentaliastypes", ParentAliasType.findAllParentAliasTypes(sortFieldName, sortOrder));
        }
        return "parentaliastypes/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String ParentAliasTypeController.update(@Valid ParentAliasType parentAliasType, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, parentAliasType);
            return "parentaliastypes/update";
        }
        uiModel.asMap().clear();
        parentAliasType.merge();
        return "redirect:/parentaliastypes/" + encodeUrlPathSegment(parentAliasType.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String ParentAliasTypeController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, ParentAliasType.findParentAliasType(id));
        return "parentaliastypes/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String ParentAliasTypeController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        ParentAliasType parentAliasType = ParentAliasType.findParentAliasType(id);
        parentAliasType.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/parentaliastypes";
    }
    
    void ParentAliasTypeController.populateEditForm(Model uiModel, ParentAliasType parentAliasType) {
        uiModel.addAttribute("parentAliasType", parentAliasType);
    }
    
    String ParentAliasTypeController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        return pathSegment;
    }
    
}
