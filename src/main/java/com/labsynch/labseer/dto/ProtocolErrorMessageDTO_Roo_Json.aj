// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.labsynch.labseer.dto;

import com.labsynch.labseer.dto.ProtocolErrorMessageDTO;
import flexjson.JSONDeserializer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

privileged aspect ProtocolErrorMessageDTO_Roo_Json {
    
    public static ProtocolErrorMessageDTO ProtocolErrorMessageDTO.fromJsonToProtocolErrorMessageDTO(String json) {
        return new JSONDeserializer<ProtocolErrorMessageDTO>().use(null, ProtocolErrorMessageDTO.class).deserialize(json);
    }
    
    public static Collection<ProtocolErrorMessageDTO> ProtocolErrorMessageDTO.fromJsonArrayToProtocolErroes(String json) {
        return new JSONDeserializer<List<ProtocolErrorMessageDTO>>().use(null, ArrayList.class).use("values", ProtocolErrorMessageDTO.class).deserialize(json);
    }
    
}
