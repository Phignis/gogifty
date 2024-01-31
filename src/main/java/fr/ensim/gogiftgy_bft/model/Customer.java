package fr.ensim.gogiftgy_bft.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Customer_t")
public class Customer {
    @Id
    private String idCustomer;
    private String lastName;
    private String firstName;
    private String password;
    private String email;
    private String phoneNumber;
    private int membershipPoints;

    @OneToOne
    @JoinColumn(name="idLevel", referencedColumnName = "idLevel")
    private MembershipLevel membershipLevel;
    @OneToOne
    @JoinColumn(name = "idSalesman", referencedColumnName = "idSalesman")
    private Salesman salesman;


    public String getIdCustomer() {
        return idCustomer;
    }

    public void setIdCustomer(String idCustomer) {
        this.idCustomer = idCustomer;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getPassword() {return password;}

    public void setPassword(String password) {this.password = password;}

    public String getEmail() {return email;}

    public void setEmail(String email) {this.email = email;}

    public String getPhoneNumber() {return phoneNumber;}

    public void setPhoneNumber(String phoneNumber) {this.phoneNumber = phoneNumber;}

    public int getMembershipPoints() {return membershipPoints;}

    public void setMembershipPoints(int membershipPoints) {this.membershipPoints = membershipPoints;}

    public Salesman getSalesman() {
        return salesman;
    }

    public void setSalesman(Salesman salesman) {
        this.salesman = salesman;
    }

    public MembershipLevel getMembershipLevel() {
        return membershipLevel;
    }

    public void setMembershipLevel(MembershipLevel membershipLevel) {
        this.membershipLevel = membershipLevel;
    }
}
