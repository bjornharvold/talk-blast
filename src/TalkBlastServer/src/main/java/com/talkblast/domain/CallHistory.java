package com.talkblast.domain;

import javax.persistence.Entity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import org.springframework.roo.addon.entity.RooEntity;
import java.util.Date;
import java.util.List;

import javax.persistence.Query;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import org.springframework.format.annotation.DateTimeFormat;
import java.util.Set;
import javax.persistence.ManyToMany;
import javax.persistence.CascadeType;
import com.talkblast.domain.Uzer;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;

@Entity
@RooJavaBean
@RooToString
@RooEntity
@SuppressWarnings("unchecked")
public class CallHistory {

    private String name;

    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "S-")
    private Date created;

    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "S-")
    private Date delivery;

    @ManyToMany(cascade = CascadeType.ALL)
    private Set<com.talkblast.domain.Participant> participants = new java.util.HashSet<com.talkblast.domain.Participant>();

    @ManyToOne(targetEntity = Uzer.class)
    @JoinColumn
    private Uzer uzer;
    
    public static List<CallHistory> findUserByUsername(String username) {
    	Query query = entityManager().createQuery("select ch from CallHistory ch where ch.uzer.username = :username");
    	query.setParameter("username", username);
        
    	return query.getResultList();
    }
}
