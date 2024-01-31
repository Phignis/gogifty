package fr.ensim.gogiftgy_bft.controller;

import fr.ensim.gogiftgy_bft.model.Item;
import fr.ensim.gogiftgy_bft.repositories.PromotionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class GeneralController {
    @Autowired
    private PromotionRepository promotionRepository;
    @GetMapping({"/", "/home"})
    public String showHome(Model model) {
        // get all gift to display
        model.addAttribute("freeItems", promotionRepository.getAllFreeItems());
        return "home";
    }
}
