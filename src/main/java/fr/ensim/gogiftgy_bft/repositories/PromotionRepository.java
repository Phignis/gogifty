package fr.ensim.gogiftgy_bft.repositories;

import fr.ensim.gogiftgy_bft.model.Item;
import fr.ensim.gogiftgy_bft.model.Promotion;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface PromotionRepository extends CrudRepository<Promotion, Long> {

    @Query("SELECT DISTINCT i FROM Item i JOIN i.promotions applyingPromo WHERE applyingPromo.reductionPercent = 1.0 AND " +
            "applyingPromo.operatorPercent = '*'")
    List<Item> getAllFreeItems();
}
