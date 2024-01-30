package fr.ensim.gogiftgy_bft.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "Salesman_t")
public class Salesman {

    @Id
    @GeneratedValue
    private Long idSalesman;
    private String lastName;
    private String firstName;
    private String password;
    private String email;

    public Long getIdSalesman() {return idSalesman;}

    public void setIdSalesman(Long idSalesman) {this.idSalesman = idSalesman;}

    public String getLastName() {return lastName;}

    public void setLastName(String lastName) {this.lastName = lastName;}

    public String getFirstName() {return firstName;}

    public void setFirstName(String firstName) {this.firstName = firstName;}

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
