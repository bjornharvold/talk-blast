package com.talkblast.domain;

import java.lang.String;

privileged aspect Uzer_Roo_JavaBean {
    
    public String Uzer.getUsername() {
        return this.username;
    }
    
    public void Uzer.setUsername(String username) {
        this.username = username;
    }
    
    public String Uzer.getPazzword() {
        return this.pazzword;
    }
    
    public void Uzer.setPazzword(String pazzword) {
        this.pazzword = pazzword;
    }
    
}
