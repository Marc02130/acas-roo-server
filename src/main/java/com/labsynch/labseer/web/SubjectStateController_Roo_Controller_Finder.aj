// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.web;

import com.labsynch.labseer.domain.Subject;
import com.labsynch.labseer.domain.SubjectState;
import com.labsynch.labseer.web.SubjectStateController;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

privileged aspect SubjectStateController_Roo_Controller_Finder {
    
    @RequestMapping(params = { "find=ByLsTypeEqualsAndLsKindEqualsAndSubject", "form" }, method = RequestMethod.GET)
    public String SubjectStateController.findSubjectStatesByLsTypeEqualsAndLsKindEqualsAndSubjectForm(Model uiModel) {
        uiModel.addAttribute("subjects", Subject.findAllSubjects());
        return "subjectstates/findSubjectStatesByLsTypeEqualsAndLsKindEqualsAndSubject";
    }
    
    @RequestMapping(params = "find=ByLsTypeEqualsAndLsKindEqualsAndSubject", method = RequestMethod.GET)
    public String SubjectStateController.findSubjectStatesByLsTypeEqualsAndLsKindEqualsAndSubject(@RequestParam("lsType") String lsType, @RequestParam("lsKind") String lsKind, @RequestParam("subject") Subject subject, Model uiModel) {
        uiModel.addAttribute("subjectstates", SubjectState.findSubjectStatesByLsTypeEqualsAndLsKindEqualsAndSubject(lsType, lsKind, subject).getResultList());
        return "subjectstates/list";
    }
    
    @RequestMapping(params = { "find=BySubject", "form" }, method = RequestMethod.GET)
    public String SubjectStateController.findSubjectStatesBySubjectForm(Model uiModel) {
        uiModel.addAttribute("subjects", Subject.findAllSubjects());
        return "subjectstates/findSubjectStatesBySubject";
    }
    
    @RequestMapping(params = "find=BySubject", method = RequestMethod.GET)
    public String SubjectStateController.findSubjectStatesBySubject(@RequestParam("subject") Subject subject, Model uiModel) {
        uiModel.addAttribute("subjectstates", SubjectState.findSubjectStatesBySubject(subject).getResultList());
        return "subjectstates/list";
    }
    
}
