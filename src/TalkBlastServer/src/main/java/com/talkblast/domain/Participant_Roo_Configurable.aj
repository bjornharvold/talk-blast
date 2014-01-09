package com.talkblast.domain;

import org.springframework.beans.factory.annotation.Configurable;

privileged aspect Participant_Roo_Configurable {
    
    declare @type: Participant: @Configurable;
    
}
