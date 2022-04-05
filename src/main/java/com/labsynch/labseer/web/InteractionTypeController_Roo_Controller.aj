// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.web;

import com.labsynch.labseer.domain.InteractionType;
import com.labsynch.labseer.web.InteractionTypeController;
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

privileged aspect InteractionTypeController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String InteractionTypeController.create(@Valid InteractionType interactionType, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, interactionType);
            return "interactiontypes/create";
        }
        uiModel.asMap().clear();
        interactionType.persist();
        return "redirect:/interactiontypes/" + encodeUrlPathSegment(interactionType.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String InteractionTypeController.createForm(Model uiModel) {
        populateEditForm(uiModel, new InteractionType());
        return "interactiontypes/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String InteractionTypeController.show(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("interactiontype", InteractionType.findInteractionType(id));
        uiModel.addAttribute("itemId", id);
        return "interactiontypes/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String InteractionTypeController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, @RequestParam(value = "sortFieldName", required = false) String sortFieldName, @RequestParam(value = "sortOrder", required = false) String sortOrder, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("interactiontypes", InteractionType.findInteractionTypeEntries(firstResult, sizeNo, sortFieldName, sortOrder));
            float nrOfPages = (float) InteractionType.countInteractionTypes() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("interactiontypes", InteractionType.findAllInteractionTypes(sortFieldName, sortOrder));
        }
        return "interactiontypes/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String InteractionTypeController.update(@Valid InteractionType interactionType, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, interactionType);
            return "interactiontypes/update";
        }
        uiModel.asMap().clear();
        interactionType.merge();
        return "redirect:/interactiontypes/" + encodeUrlPathSegment(interactionType.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String InteractionTypeController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, InteractionType.findInteractionType(id));
        return "interactiontypes/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String InteractionTypeController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        InteractionType interactionType = InteractionType.findInteractionType(id);
        interactionType.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/interactiontypes";
    }
    
    void InteractionTypeController.populateEditForm(Model uiModel, InteractionType interactionType) {
        uiModel.addAttribute("interactionType", interactionType);
    }
    
    String InteractionTypeController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        return pathSegment;
    }
    
}
