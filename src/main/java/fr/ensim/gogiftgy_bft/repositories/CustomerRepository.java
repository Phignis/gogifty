package fr.ensim.gogiftgy_bft.repositories;

import fr.ensim.gogiftgy_bft.model.Customer;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface CustomerRepository extends CrudRepository<Customer, String> {
    Customer findByEmailAndPassword(String email, String password);
    Optional<Customer> findById (String id);
}