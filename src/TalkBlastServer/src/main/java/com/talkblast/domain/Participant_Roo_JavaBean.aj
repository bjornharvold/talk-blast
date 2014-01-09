package com.talkblast.domain;

import java.lang.String;

privileged aspect Participant_Roo_JavaBean {
    
    public String Participant.getName() {
        return this.name;
    }
    
    public void Participant.setName(String name) {
        this.name = name;
    }
    
    public String Participant.getPhone() {
        return this.phone;
    }
    
    public void Participant.setPhone(String phone) {
        this.phone = phone;
    }
    
}
