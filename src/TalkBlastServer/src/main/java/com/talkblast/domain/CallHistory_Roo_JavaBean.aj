package com.talkblast.domain;

import com.talkblast.domain.Participant;
import com.talkblast.domain.Uzer;
import java.lang.String;
import java.util.Date;
import java.util.Set;

privileged aspect CallHistory_Roo_JavaBean {
    
    public String CallHistory.getName() {
        return this.name;
    }
    
    public void CallHistory.setName(String name) {
        this.name = name;
    }
    
    public Date CallHistory.getCreated() {
        return this.created;
    }
    
    public void CallHistory.setCreated(Date created) {
        this.created = created;
    }
    
    public Date CallHistory.getDelivery() {
        return this.delivery;
    }
    
    public void CallHistory.setDelivery(Date delivery) {
        this.delivery = delivery;
    }
    
    public Set<Participant> CallHistory.getParticipants() {
        return this.participants;
    }
    
    public void CallHistory.setParticipants(Set<Participant> participants) {
        this.participants = participants;
    }
    
    public Uzer CallHistory.getUzer() {
        return this.uzer;
    }
    
    public void CallHistory.setUzer(Uzer uzer) {
        this.uzer = uzer;
    }
    
}
