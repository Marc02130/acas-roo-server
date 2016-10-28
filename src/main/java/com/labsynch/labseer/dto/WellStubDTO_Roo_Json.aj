// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.dto;

import com.labsynch.labseer.dto.WellStubDTO;
import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

privileged aspect WellStubDTO_Roo_Json {
    
    public String WellStubDTO.toJson() {
        return new JSONSerializer().exclude("*.class").serialize(this);
    }
    
    public static WellStubDTO WellStubDTO.fromJsonToWellStubDTO(String json) {
        return new JSONDeserializer<WellStubDTO>().use(null, WellStubDTO.class).deserialize(json);
    }
    
    public static String WellStubDTO.toJsonArray(Collection<WellStubDTO> collection) {
        return new JSONSerializer().exclude("*.class").serialize(collection);
    }
    
    public static Collection<WellStubDTO> WellStubDTO.fromJsonArrayToWellStubDTO(String json) {
        return new JSONDeserializer<List<WellStubDTO>>().use(null, ArrayList.class).use("values", WellStubDTO.class).deserialize(json);
    }
    
}
