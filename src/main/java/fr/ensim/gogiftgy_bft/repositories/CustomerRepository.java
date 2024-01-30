package fr.ensim.gogiftgy_bft.repositories;

import fr.ensim.gogiftgy_bft.model.Customer;
import org.springframework.data.repository.CrudRepository;

public interface CustomerRepository extends CrudRepository<Customer, Long> {

}