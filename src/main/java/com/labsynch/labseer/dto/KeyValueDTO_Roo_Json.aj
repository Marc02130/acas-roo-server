// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.dto;

import com.labsynch.labseer.dto.KeyValueDTO;
import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

privileged aspect KeyValueDTO_Roo_Json {
    
    public String KeyValueDTO.toJson() {
        return new JSONSerializer().exclude("*.class").serialize(this);
    }
    
    public static KeyValueDTO KeyValueDTO.fromJsonToKeyValueDTO(String json) {
        return new JSONDeserializer<KeyValueDTO>().use(null, KeyValueDTO.class).deserialize(json);
    }
    
    public static String KeyValueDTO.toJsonArray(Collection<KeyValueDTO> collection) {
        return new JSONSerializer().exclude("*.class").serialize(collection);
    }
    
    public static Collection<KeyValueDTO> KeyValueDTO.fromJsonArrayToKeyValueDTO(String json) {
        return new JSONDeserializer<List<KeyValueDTO>>().use(null, ArrayList.class).use("values", KeyValueDTO.class).deserialize(json);
    }
    
}
