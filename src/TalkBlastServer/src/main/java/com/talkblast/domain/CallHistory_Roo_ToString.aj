package com.talkblast.domain;

import java.lang.String;

privileged aspect CallHistory_Roo_ToString {
    
    public String CallHistory.toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Id: ").append(getId()).append(", ");
        sb.append("Version: ").append(getVersion()).append(", ");
        sb.append("Name: ").append(getName()).append(", ");
        sb.append("Created: ").append(getCreated()).append(", ");
        sb.append("Delivery: ").append(getDelivery()).append(", ");
        sb.append("Participants: ").append(getParticipants() == null ? "null" : getParticipants().size()).append(", ");
        sb.append("Uzer: ").append(getUzer());
        return sb.toString();
    }
    
}
