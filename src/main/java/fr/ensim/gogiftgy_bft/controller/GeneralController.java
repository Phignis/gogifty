package fr.ensim.gogiftgy_bft.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class GeneralController {
    @GetMapping({"/", "/home"})
    public String showHome() {
        return "home";
    }
}
