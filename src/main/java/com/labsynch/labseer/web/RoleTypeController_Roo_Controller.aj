// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.web;

import com.labsynch.labseer.domain.RoleType;
import com.labsynch.labseer.web.RoleTypeController;
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

privileged aspect RoleTypeController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String RoleTypeController.create(@Valid RoleType roleType, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, roleType);
            return "roletypes/create";
        }
        uiModel.asMap().clear();
        roleType.persist();
        return "redirect:/roletypes/" + encodeUrlPathSegment(roleType.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String RoleTypeController.createForm(Model uiModel) {
        populateEditForm(uiModel, new RoleType());
        return "roletypes/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String RoleTypeController.show(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("roletype", RoleType.findRoleType(id));
        uiModel.addAttribute("itemId", id);
        return "roletypes/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String RoleTypeController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("roletypes", RoleType.findRoleTypeEntries(firstResult, sizeNo));
            float nrOfPages = (float) RoleType.countRoleTypes() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("roletypes", RoleType.findAllRoleTypes());
        }
        return "roletypes/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String RoleTypeController.update(@Valid RoleType roleType, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, roleType);
            return "roletypes/update";
        }
        uiModel.asMap().clear();
        roleType.merge();
        return "redirect:/roletypes/" + encodeUrlPathSegment(roleType.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String RoleTypeController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, RoleType.findRoleType(id));
        return "roletypes/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String RoleTypeController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        RoleType roleType = RoleType.findRoleType(id);
        roleType.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/roletypes";
    }
    
    void RoleTypeController.populateEditForm(Model uiModel, RoleType roleType) {
        uiModel.addAttribute("roleType", roleType);
    }
    
    String RoleTypeController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
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
