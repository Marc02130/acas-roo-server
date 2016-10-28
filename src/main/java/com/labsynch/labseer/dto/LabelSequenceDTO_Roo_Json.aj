// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.dto;

import com.labsynch.labseer.dto.LabelSequenceDTO;
import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

privileged aspect LabelSequenceDTO_Roo_Json {
    
    public String LabelSequenceDTO.toJson() {
        return new JSONSerializer().exclude("*.class").serialize(this);
    }
    
    public static LabelSequenceDTO LabelSequenceDTO.fromJsonToLabelSequenceDTO(String json) {
        return new JSONDeserializer<LabelSequenceDTO>().use(null, LabelSequenceDTO.class).deserialize(json);
    }
    
    public static String LabelSequenceDTO.toJsonArray(Collection<LabelSequenceDTO> collection) {
        return new JSONSerializer().exclude("*.class").serialize(collection);
    }
    
    public static Collection<LabelSequenceDTO> LabelSequenceDTO.fromJsonArrayToLabelSequenceDTO(String json) {
        return new JSONDeserializer<List<LabelSequenceDTO>>().use(null, ArrayList.class).use("values", LabelSequenceDTO.class).deserialize(json);
    }
    
}
