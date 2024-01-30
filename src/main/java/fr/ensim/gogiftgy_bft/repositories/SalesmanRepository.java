package fr.ensim.gogiftgy_bft.repositories;

import fr.ensim.gogiftgy_bft.model.Salesman;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface SalesmanRepository extends CrudRepository<Salesman, Long> {
    Salesman findByEmailAndPassword(String email, String password);
}
