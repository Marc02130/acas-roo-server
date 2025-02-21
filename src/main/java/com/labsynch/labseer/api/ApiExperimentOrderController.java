@Controller
@RequestMapping("/api/v1/experimentorder")
public class ApiExperimentOrderController {

    @RequestMapping(value = "", method = RequestMethod.POST)
    @ResponseBody
    public ExperimentOrder saveExperimentOrder(@RequestBody ExperimentOrder experimentOrder) {
        // Save the experiment order first
        experimentOrder.persist();
        
        // Handle samples
        Collection<Sample> samples = experimentOrder.getSamples();
        if (samples != null) {
            for (Sample sample : samples) {
                ExperimentSample experimentSample = new ExperimentSample();
                experimentSample.setExperimentOrder(experimentOrder);
                experimentSample.setSample(sample);
                experimentSample.persist();
            }
        }

        return experimentOrder;
    }

    @RequestMapping(value = "/{id}/samples", method = RequestMethod.GET) 
    @ResponseBody
    public Collection<Sample> getExperimentSamples(@PathVariable("id") Long id) {
        ExperimentOrder experimentOrder = ExperimentOrder.findExperimentOrder(id);
        return experimentOrder.getSamples();
    }

    @RequestMapping(value = "/{id}/samples", method = RequestMethod.POST)
    @ResponseBody 
    public void updateExperimentSamples(@PathVariable("id") Long id, 
                                      @RequestBody Collection<Sample> samples) {
        ExperimentOrder experimentOrder = ExperimentOrder.findExperimentOrder(id);
        
        // Remove existing samples
        ExperimentSample.deleteByExperimentOrder(experimentOrder);
        
        // Add new samples
        for (Sample sample : samples) {
            ExperimentSample experimentSample = new ExperimentSample();
            experimentSample.setExperimentOrder(experimentOrder);
            experimentSample.setSample(sample);
            experimentSample.persist();
        }
    }
}