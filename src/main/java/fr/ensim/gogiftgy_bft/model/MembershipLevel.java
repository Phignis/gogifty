package fr.ensim.gogiftgy_bft.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "membership_t")
public class MembershipLevel {
    @Id
    @GeneratedValue
    private Long idLevel;

    private String nameLevel;

    private int nbDaysExpiryDelay;

    private int necessaryMemberPoints;

    public Long getIdLevel() {
        return idLevel;
    }

    public void setIdLevel(Long idLevel) {
        this.idLevel = idLevel;
    }

    public String getNameLevel() {
        return nameLevel;
    }

    public void setNameLevel(String nameLevel) {
        this.nameLevel = nameLevel;
    }

    public int getNbDaysExpiryDelay() {
        return nbDaysExpiryDelay;
    }

    public void setNbDaysExpiryDelay(int nbDaysExpiryDelay) {
        this.nbDaysExpiryDelay = nbDaysExpiryDelay;
    }

    public int getNecessaryMemberPoints() {
        return necessaryMemberPoints;
    }

    public void setNecessaryMemberPoints(int necessaryMemberPoints) {
        this.necessaryMemberPoints = necessaryMemberPoints;
    }
}
