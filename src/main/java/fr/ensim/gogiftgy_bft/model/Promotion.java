package fr.ensim.gogiftgy_bft.model;

import jakarta.persistence.*;

import java.util.Date;
import java.util.Set;

@Entity
@Table(name = "Promotion_t")
public class Promotion {
    @Id
    @GeneratedValue
    private Long idPromotion;

    private Date startDate;

    private Date endDate;

    private float reductionPercent;

    private String operatorPercent;

    private float minAmountTrigger;


    public Long getIdPromotion() {
        return idPromotion;
    }

    public void setIdPromotion(Long idPromotion) {
        this.idPromotion = idPromotion;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public float getReductionPercent() {
        return reductionPercent;
    }

    public void setReductionPercent(float reductionPercent) {
        this.reductionPercent = reductionPercent;
    }

    public String getOperatorPercent() {
        return operatorPercent;
    }

    public void setOperatorPercent(String operatorPercent) {
        this.operatorPercent = operatorPercent;
    }

    public float getMinAmountTrigger() {
        return minAmountTrigger;
    }

    public void setMinAmountTrigger(float minAmountTrigger) {
        this.minAmountTrigger = minAmountTrigger;
    }
}
