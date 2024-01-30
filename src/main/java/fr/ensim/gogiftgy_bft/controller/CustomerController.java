package fr.ensim.gogiftgy_bft.controller;

import fr.ensim.gogiftgy_bft.model.Customer;
import fr.ensim.gogiftgy_bft.repositories.CustomerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping(path = "/customer")
public class CustomerController {
    @Autowired
    private CustomerRepository repository;

    @GetMapping(path="/all")
    public @ResponseBody Iterable<Customer> getCustomerList() {
        // This returns a JSON or XML with the users
        return repository.findAll();
    }
}
