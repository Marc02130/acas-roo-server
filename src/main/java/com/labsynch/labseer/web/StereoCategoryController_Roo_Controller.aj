// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.web;

import com.labsynch.labseer.domain.StereoCategory;
import com.labsynch.labseer.web.StereoCategoryController;
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

privileged aspect StereoCategoryController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String StereoCategoryController.create(@Valid StereoCategory stereoCategory, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, stereoCategory);
            return "stereocategorys/create";
        }
        uiModel.asMap().clear();
        stereoCategory.persist();
        return "redirect:/stereocategorys/" + encodeUrlPathSegment(stereoCategory.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String StereoCategoryController.createForm(Model uiModel) {
        populateEditForm(uiModel, new StereoCategory());
        return "stereocategorys/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String StereoCategoryController.show(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("stereocategory", StereoCategory.findStereoCategory(id));
        uiModel.addAttribute("itemId", id);
        return "stereocategorys/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String StereoCategoryController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, @RequestParam(value = "sortFieldName", required = false) String sortFieldName, @RequestParam(value = "sortOrder", required = false) String sortOrder, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("stereocategorys", StereoCategory.findStereoCategoryEntries(firstResult, sizeNo, sortFieldName, sortOrder));
            float nrOfPages = (float) StereoCategory.countStereoCategorys() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("stereocategorys", StereoCategory.findAllStereoCategorys(sortFieldName, sortOrder));
        }
        return "stereocategorys/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String StereoCategoryController.update(@Valid StereoCategory stereoCategory, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, stereoCategory);
            return "stereocategorys/update";
        }
        uiModel.asMap().clear();
        stereoCategory.merge();
        return "redirect:/stereocategorys/" + encodeUrlPathSegment(stereoCategory.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String StereoCategoryController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, StereoCategory.findStereoCategory(id));
        return "stereocategorys/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String StereoCategoryController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        StereoCategory stereoCategory = StereoCategory.findStereoCategory(id);
        stereoCategory.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/stereocategorys";
    }
    
    void StereoCategoryController.populateEditForm(Model uiModel, StereoCategory stereoCategory) {
        uiModel.addAttribute("stereoCategory", stereoCategory);
    }
    
    String StereoCategoryController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        return pathSegment;
    }
    
}
