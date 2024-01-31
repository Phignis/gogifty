package fr.ensim.gogiftgy_bft.model;

import jakarta.persistence.*;

import java.util.Set;

@Entity
@Table(name = "Item_t")
public class Item {
    @Id
    @GeneratedValue
    private Long idItem;

    private String nameItem;

    private float initialPrice;

    private int givingPoints;

    @OneToOne
    @JoinColumn(name="idBrand", referencedColumnName = "idBrand")
    private Brand brand;


    @ManyToMany
    @JoinTable(name = "promotion_on_item_tj",
            joinColumns = @JoinColumn(name = "idItem"),
            inverseJoinColumns = @JoinColumn(name = "idPromotion"))
    private Set<Promotion> promotions;

    public Long getIdItem() {
        return idItem;
    }

    public void setIdItem(Long idItem) {
        this.idItem = idItem;
    }

    public String getNameItem() {
        return nameItem;
    }

    public void setNameItem(String nameItem) {
        this.nameItem = nameItem;
    }

    public float getInitialPrice() {
        return initialPrice;
    }

    public void setInitialPrice(float initialPrice) {
        this.initialPrice = initialPrice;
    }

    public int getGivingPoints() {
        return givingPoints;
    }

    public void setGivingPoints(int givingPoints) {
        this.givingPoints = givingPoints;
    }

    public Set<Promotion> getPromotions() {
        return promotions;
    }

    public void setPromotions(Set<Promotion> promotions) {
        this.promotions = promotions;
    }

    public Brand getBrand() {
        return brand;
    }

    public void setBrand(Brand brand) {
        this.brand = brand;
    }
}
