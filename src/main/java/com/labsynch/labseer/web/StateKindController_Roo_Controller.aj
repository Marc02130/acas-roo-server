// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.web;

import com.labsynch.labseer.domain.StateKind;
import com.labsynch.labseer.domain.StateType;
import com.labsynch.labseer.web.StateKindController;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
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

privileged aspect StateKindController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String StateKindController.create(@Valid StateKind stateKind, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, stateKind);
            return "statekinds/create";
        }
        uiModel.asMap().clear();
        stateKind.persist();
        return "redirect:/statekinds/" + encodeUrlPathSegment(stateKind.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String StateKindController.createForm(Model uiModel) {
        populateEditForm(uiModel, new StateKind());
        List<String[]> dependencies = new ArrayList<String[]>();
        if (StateType.countStateTypes() == 0) {
            dependencies.add(new String[] { "lsType", "statetypes" });
        }
        uiModel.addAttribute("dependencies", dependencies);
        return "statekinds/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String StateKindController.show(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("statekind", StateKind.findStateKind(id));
        uiModel.addAttribute("itemId", id);
        return "statekinds/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String StateKindController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, @RequestParam(value = "sortFieldName", required = false) String sortFieldName, @RequestParam(value = "sortOrder", required = false) String sortOrder, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("statekinds", StateKind.findStateKindEntries(firstResult, sizeNo, sortFieldName, sortOrder));
            float nrOfPages = (float) StateKind.countStateKinds() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("statekinds", StateKind.findAllStateKinds(sortFieldName, sortOrder));
        }
        return "statekinds/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String StateKindController.update(@Valid StateKind stateKind, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, stateKind);
            return "statekinds/update";
        }
        uiModel.asMap().clear();
        stateKind.merge();
        return "redirect:/statekinds/" + encodeUrlPathSegment(stateKind.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String StateKindController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, StateKind.findStateKind(id));
        return "statekinds/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String StateKindController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        StateKind stateKind = StateKind.findStateKind(id);
        stateKind.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/statekinds";
    }
    
    void StateKindController.populateEditForm(Model uiModel, StateKind stateKind) {
        uiModel.addAttribute("stateKind", stateKind);
        uiModel.addAttribute("statetypes", StateType.findAllStateTypes());
    }
    
    String StateKindController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        return pathSegment;
    }
    
}
