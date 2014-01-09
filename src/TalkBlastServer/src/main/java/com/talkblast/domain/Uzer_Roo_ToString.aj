package com.talkblast.domain;

import java.lang.String;

privileged aspect Uzer_Roo_ToString {
    
    public String Uzer.toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Id: ").append(getId()).append(", ");
        sb.append("Version: ").append(getVersion()).append(", ");
        sb.append("Username: ").append(getUsername()).append(", ");
        sb.append("Pazzword: ").append(getPazzword());
        return sb.toString();
    }
    
}
