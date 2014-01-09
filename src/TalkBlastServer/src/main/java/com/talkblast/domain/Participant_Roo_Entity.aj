package com.talkblast.domain;

import com.talkblast.domain.Participant;
import java.lang.Integer;
import java.lang.Long;
import java.lang.SuppressWarnings;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.EntityManager;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.PersistenceContext;
import javax.persistence.Version;
import org.springframework.transaction.annotation.Transactional;

privileged aspect Participant_Roo_Entity {
    
    @PersistenceContext
    transient EntityManager Participant.entityManager;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long Participant.id;
    
    @Version
    @Column(name = "version")
    private Integer Participant.version;
    
    public Long Participant.getId() {
        return this.id;
    }
    
    public void Participant.setId(Long id) {
        this.id = id;
    }
    
    public Integer Participant.getVersion() {
        return this.version;
    }
    
    public void Participant.setVersion(Integer version) {
        this.version = version;
    }
    
    @Transactional
    public void Participant.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void Participant.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            Participant attached = this.entityManager.find(this.getClass(), this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void Participant.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public Participant Participant.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        Participant merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
    public static final EntityManager Participant.entityManager() {
        EntityManager em = new Participant().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long Participant.countParticipants() {
        return ((Number) entityManager().createQuery("select count(o) from Participant o").getSingleResult()).longValue();
    }
    
    @SuppressWarnings("unchecked")
    public static List<Participant> Participant.findAllParticipants() {
        return entityManager().createQuery("select o from Participant o").getResultList();
    }
    
    public static Participant Participant.findParticipant(Long id) {
        if (id == null) return null;
        return entityManager().find(Participant.class, id);
    }
    
    @SuppressWarnings("unchecked")
    public static List<Participant> Participant.findParticipantEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("select o from Participant o").setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
}
