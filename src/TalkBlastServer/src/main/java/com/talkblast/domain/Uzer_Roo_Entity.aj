package com.talkblast.domain;

import com.talkblast.domain.Uzer;
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

privileged aspect Uzer_Roo_Entity {
    
    @PersistenceContext
    transient EntityManager Uzer.entityManager;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long Uzer.id;
    
    @Version
    @Column(name = "version")
    private Integer Uzer.version;
    
    public Long Uzer.getId() {
        return this.id;
    }
    
    public void Uzer.setId(Long id) {
        this.id = id;
    }
    
    public Integer Uzer.getVersion() {
        return this.version;
    }
    
    public void Uzer.setVersion(Integer version) {
        this.version = version;
    }
    
    @Transactional
    public void Uzer.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void Uzer.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            Uzer attached = this.entityManager.find(this.getClass(), this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void Uzer.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public Uzer Uzer.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        Uzer merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
    public static final EntityManager Uzer.entityManager() {
        EntityManager em = new Uzer().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long Uzer.countUzers() {
        return ((Number) entityManager().createQuery("select count(o) from Uzer o").getSingleResult()).longValue();
    }
    
    @SuppressWarnings("unchecked")
    public static List<Uzer> Uzer.findAllUzers() {
        return entityManager().createQuery("select o from Uzer o").getResultList();
    }
    
    public static Uzer Uzer.findUzer(Long id) {
        if (id == null) return null;
        return entityManager().find(Uzer.class, id);
    }
    
    @SuppressWarnings("unchecked")
    public static List<Uzer> Uzer.findUzerEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("select o from Uzer o").setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
}
