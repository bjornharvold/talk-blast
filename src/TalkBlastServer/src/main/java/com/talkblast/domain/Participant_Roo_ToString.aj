package com.talkblast.domain;

import java.lang.String;

privileged aspect Participant_Roo_ToString {
    
    public String Participant.toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Id: ").append(getId()).append(", ");
        sb.append("Version: ").append(getVersion()).append(", ");
        sb.append("Name: ").append(getName()).append(", ");
        sb.append("Phone: ").append(getPhone());
        return sb.toString();
    }
    
}
