// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.web;

import com.labsynch.labseer.domain.Experiment;
import com.labsynch.labseer.domain.Protocol;
import com.labsynch.labseer.web.ExperimentController;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

privileged aspect ExperimentController_Roo_Controller_Finder {
    
    @RequestMapping(params = { "find=ByCodeNameEquals", "form" }, method = RequestMethod.GET)
    public String ExperimentController.findExperimentsByCodeNameEqualsForm(Model uiModel) {
        return "experiments/findExperimentsByCodeNameEquals";
    }
    
    @RequestMapping(params = "find=ByCodeNameEquals", method = RequestMethod.GET)
    public String ExperimentController.findExperimentsByCodeNameEquals(@RequestParam("codeName") String codeName, Model uiModel) {
        uiModel.addAttribute("experiments", Experiment.findExperimentsByCodeNameEquals(codeName).getResultList());
        return "experiments/list";
    }
    
    @RequestMapping(params = { "find=ByCodeNameLike", "form" }, method = RequestMethod.GET)
    public String ExperimentController.findExperimentsByCodeNameLikeForm(Model uiModel) {
        return "experiments/findExperimentsByCodeNameLike";
    }
    
    @RequestMapping(params = "find=ByCodeNameLike", method = RequestMethod.GET)
    public String ExperimentController.findExperimentsByCodeNameLike(@RequestParam("codeName") String codeName, Model uiModel) {
        uiModel.addAttribute("experiments", Experiment.findExperimentsByCodeNameLike(codeName).getResultList());
        return "experiments/list";
    }
    
    @RequestMapping(params = { "find=ByLsKindLike", "form" }, method = RequestMethod.GET)
    public String ExperimentController.findExperimentsByLsKindLikeForm(Model uiModel) {
        return "experiments/findExperimentsByLsKindLike";
    }
    
    @RequestMapping(params = "find=ByLsKindLike", method = RequestMethod.GET)
    public String ExperimentController.findExperimentsByLsKindLike(@RequestParam("lsKind") String lsKind, Model uiModel) {
        uiModel.addAttribute("experiments", Experiment.findExperimentsByLsKindLike(lsKind).getResultList());
        return "experiments/list";
    }
    
    @RequestMapping(params = { "find=ByLsTransaction", "form" }, method = RequestMethod.GET)
    public String ExperimentController.findExperimentsByLsTransactionForm(Model uiModel) {
        return "experiments/findExperimentsByLsTransaction";
    }
    
    @RequestMapping(params = "find=ByLsTransaction", method = RequestMethod.GET)
    public String ExperimentController.findExperimentsByLsTransaction(@RequestParam("lsTransaction") Long lsTransaction, Model uiModel) {
        uiModel.addAttribute("experiments", Experiment.findExperimentsByLsTransaction(lsTransaction).getResultList());
        return "experiments/list";
    }
    
    @RequestMapping(params = { "find=ByLsTypeEqualsAndLsKindEquals", "form" }, method = RequestMethod.GET)
    public String ExperimentController.findExperimentsByLsTypeEqualsAndLsKindEqualsForm(Model uiModel) {
        return "experiments/findExperimentsByLsTypeEqualsAndLsKindEquals";
    }
    
    @RequestMapping(params = "find=ByLsTypeEqualsAndLsKindEquals", method = RequestMethod.GET)
    public String ExperimentController.findExperimentsByLsTypeEqualsAndLsKindEquals(@RequestParam("lsType") String lsType, @RequestParam("lsKind") String lsKind, Model uiModel) {
        uiModel.addAttribute("experiments", Experiment.findExperimentsByLsTypeEqualsAndLsKindEquals(lsType, lsKind).getResultList());
        return "experiments/list";
    }
    
    @RequestMapping(params = { "find=ByLsTypeLike", "form" }, method = RequestMethod.GET)
    public String ExperimentController.findExperimentsByLsTypeLikeForm(Model uiModel) {
        return "experiments/findExperimentsByLsTypeLike";
    }
    
    @RequestMapping(params = "find=ByLsTypeLike", method = RequestMethod.GET)
    public String ExperimentController.findExperimentsByLsTypeLike(@RequestParam("lsType") String lsType, Model uiModel) {
        uiModel.addAttribute("experiments", Experiment.findExperimentsByLsTypeLike(lsType).getResultList());
        return "experiments/list";
    }
    
    @RequestMapping(params = { "find=ByProtocol", "form" }, method = RequestMethod.GET)
    public String ExperimentController.findExperimentsByProtocolForm(Model uiModel) {
        uiModel.addAttribute("protocols", Protocol.findAllProtocols());
        return "experiments/findExperimentsByProtocol";
    }
    
    @RequestMapping(params = "find=ByProtocol", method = RequestMethod.GET)
    public String ExperimentController.findExperimentsByProtocol(@RequestParam("protocol") Protocol protocol, Model uiModel) {
        uiModel.addAttribute("experiments", Experiment.findExperimentsByProtocol(protocol).getResultList());
        return "experiments/list";
    }
    
    @RequestMapping(params = { "find=ByRecordedByLike", "form" }, method = RequestMethod.GET)
    public String ExperimentController.findExperimentsByRecordedByLikeForm(Model uiModel) {
        return "experiments/findExperimentsByRecordedByLike";
    }
    
    @RequestMapping(params = "find=ByRecordedByLike", method = RequestMethod.GET)
    public String ExperimentController.findExperimentsByRecordedByLike(@RequestParam("recordedBy") String recordedBy, Model uiModel) {
        uiModel.addAttribute("experiments", Experiment.findExperimentsByRecordedByLike(recordedBy).getResultList());
        return "experiments/list";
    }
    
}
