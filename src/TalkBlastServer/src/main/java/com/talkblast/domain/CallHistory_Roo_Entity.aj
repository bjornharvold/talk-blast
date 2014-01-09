package com.talkblast.domain;

import com.talkblast.domain.CallHistory;
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

privileged aspect CallHistory_Roo_Entity {
    
    @PersistenceContext
    transient EntityManager CallHistory.entityManager;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long CallHistory.id;
    
    @Version
    @Column(name = "version")
    private Integer CallHistory.version;
    
    public Long CallHistory.getId() {
        return this.id;
    }
    
    public void CallHistory.setId(Long id) {
        this.id = id;
    }
    
    public Integer CallHistory.getVersion() {
        return this.version;
    }
    
    public void CallHistory.setVersion(Integer version) {
        this.version = version;
    }
    
    @Transactional
    public void CallHistory.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void CallHistory.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            CallHistory attached = this.entityManager.find(this.getClass(), this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void CallHistory.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public CallHistory CallHistory.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        CallHistory merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
    public static final EntityManager CallHistory.entityManager() {
        EntityManager em = new CallHistory().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long CallHistory.countCallHistorys() {
        return ((Number) entityManager().createQuery("select count(o) from CallHistory o").getSingleResult()).longValue();
    }
    
    @SuppressWarnings("unchecked")
    public static List<CallHistory> CallHistory.findAllCallHistorys() {
        return entityManager().createQuery("select o from CallHistory o").getResultList();
    }
    
    public static CallHistory CallHistory.findCallHistory(Long id) {
        if (id == null) return null;
        return entityManager().find(CallHistory.class, id);
    }
    
    @SuppressWarnings("unchecked")
    public static List<CallHistory> CallHistory.findCallHistoryEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("select o from CallHistory o").setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
}
