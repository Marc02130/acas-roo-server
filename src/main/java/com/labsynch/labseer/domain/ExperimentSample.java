@RooJavaBean
@RooToString
@RooJpaActiveRecord
public class ExperimentSample {

    @ManyToOne
    @JoinColumn(name = "experiment_id")
    private ExperimentOrder experimentOrder;

    @ManyToOne 
    @JoinColumn(name = "sample_id")
    private Sample sample;

    // Other fields...
}