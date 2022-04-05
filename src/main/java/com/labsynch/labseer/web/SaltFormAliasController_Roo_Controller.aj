// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.web;

import com.labsynch.labseer.domain.SaltForm;
import com.labsynch.labseer.domain.SaltFormAlias;
import com.labsynch.labseer.web.SaltFormAliasController;
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

privileged aspect SaltFormAliasController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String SaltFormAliasController.create(@Valid SaltFormAlias saltFormAlias, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, saltFormAlias);
            return "saltformaliases/create";
        }
        uiModel.asMap().clear();
        saltFormAlias.persist();
        return "redirect:/saltformaliases/" + encodeUrlPathSegment(saltFormAlias.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String SaltFormAliasController.createForm(Model uiModel) {
        populateEditForm(uiModel, new SaltFormAlias());
        return "saltformaliases/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String SaltFormAliasController.show(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("saltformalias", SaltFormAlias.findSaltFormAlias(id));
        uiModel.addAttribute("itemId", id);
        return "saltformaliases/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String SaltFormAliasController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, @RequestParam(value = "sortFieldName", required = false) String sortFieldName, @RequestParam(value = "sortOrder", required = false) String sortOrder, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("saltformaliases", SaltFormAlias.findSaltFormAliasEntries(firstResult, sizeNo, sortFieldName, sortOrder));
            float nrOfPages = (float) SaltFormAlias.countSaltFormAliases() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("saltformaliases", SaltFormAlias.findAllSaltFormAliases(sortFieldName, sortOrder));
        }
        return "saltformaliases/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String SaltFormAliasController.update(@Valid SaltFormAlias saltFormAlias, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, saltFormAlias);
            return "saltformaliases/update";
        }
        uiModel.asMap().clear();
        saltFormAlias.merge();
        return "redirect:/saltformaliases/" + encodeUrlPathSegment(saltFormAlias.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String SaltFormAliasController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, SaltFormAlias.findSaltFormAlias(id));
        return "saltformaliases/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String SaltFormAliasController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        SaltFormAlias saltFormAlias = SaltFormAlias.findSaltFormAlias(id);
        saltFormAlias.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/saltformaliases";
    }
    
    void SaltFormAliasController.populateEditForm(Model uiModel, SaltFormAlias saltFormAlias) {
        uiModel.addAttribute("saltFormAlias", saltFormAlias);
        uiModel.addAttribute("saltforms", SaltForm.findAllSaltForms());
    }
    
    String SaltFormAliasController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        return pathSegment;
    }
    
}
