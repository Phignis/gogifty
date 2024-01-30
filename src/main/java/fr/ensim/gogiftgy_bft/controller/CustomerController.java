package fr.ensim.gogiftgy_bft.controller;

import fr.ensim.gogiftgy_bft.model.Customer;
import fr.ensim.gogiftgy_bft.model.Salesman;
import fr.ensim.gogiftgy_bft.repositories.CustomerRepository;
import fr.ensim.gogiftgy_bft.repositories.SalesmanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class CustomerController {
    @Autowired
    private CustomerRepository repository;

    @Autowired
    private SalesmanRepository sRepository;

    @GetMapping("/profile")
    public String showProfilePage() {
        return "profile";
    }
    @GetMapping("/login")
    public String showLoginPage() {
        return "login";
    }


    @PostMapping("/editProfile")
    public String editProfile(
            @RequestParam String editLastName,
            @RequestParam String editFirstName,
            @RequestParam String editEmail,
            @RequestParam int editPhoneNumber,
            @RequestParam String customerId,
            Model model) {

        Customer customer = repository.findById(customerId).orElse(null);

        if (customer != null) {
            customer.setLastName(editLastName);
            customer.setFirstName(editFirstName);
            customer.setEmail(editEmail);
            customer.setPhoneNumber(editPhoneNumber);

            repository.save(customer);

            model.addAttribute("customer", customer);
            return "profile";
        } else {
            return "error";
        }
    }


    @PostMapping(path="/login")
    public String login(@RequestParam String email, @RequestParam String password, @RequestParam String usertype, Model model) {
        if ("customer".equals(usertype)) {
            Customer customer = repository.findByEmailAndPassword(email, password);
            if (customer != null) {
                model.addAttribute("customer", customer);

                return "profile";
            }
        } else if ("salesman".equals(usertype)) {
            // Assurez-vous que vous avez un repository pour les Salesmen
            Salesman salesman = sRepository.findByEmailAndPassword(email, password);
            if (salesman != null) {
                model.addAttribute("salesman", salesman);
                return "salesmanProfile";
            }
        }
        model.addAttribute("error", "Invalid email or password");
        return "login";
    }

}
