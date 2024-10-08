package uz.pdp.uzummarket.repositories;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.transaction.Transactional;
import lombok.SneakyThrows;
import uz.pdp.uzummarket.entities.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;
import java.util.ArrayList;

public class ProductRepository implements BaseRepository<Product> {

    private final ShopRepository shopRepository = new ShopRepository();
    private static final EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("HIBERNATE-UNIT");
    private final EntityManager entityManager = entityManagerFactory.createEntityManager();

    @Transactional
    @Override
    public void save(Product product) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            entityManager.persist(product);
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        } finally {
            transaction.commit();
        }
    }

    public boolean delete(Product product) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();

            Product managedProduct = entityManager.find(Product.class, product.getId());
            if (managedProduct != null) {
                // Remove the entity if it exists
                entityManager.remove(managedProduct);
                transaction.commit();
                return true;
            } else {
                transaction.rollback();
                return false; // Product not found
            }
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback(); // Rollback on exception
            }
            e.printStackTrace(); // Log the exception
            return false; // Indicate failure
        }
    }

    @Override
    public Product get(Integer id) {
        return entityManager.find(Product.class, id);
    }

    @Override
    public List<Product> getAll() {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            return entityManager.createNativeQuery("SELECT * FROM products", Product.class).getResultList();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            transaction.commit();
        }
    }


    @Transactional
    @Override
    public void update(Product product) {
        entityManager.getTransaction().begin();
        Product managedProduct = entityManager.find(Product.class, product.getId());
        if (managedProduct != null) {
            managedProduct.setName(product.getName());
            managedProduct.setDescription(product.getDescription());
            managedProduct.setPrice(product.getPrice());
            managedProduct.setDiscount(product.getDiscount());
            managedProduct.setQuantity(product.getQuantity());
            managedProduct.setImages(product.getImages());
            managedProduct.setPriceAfterDiscount(product.getPriceAfterDiscount());
            managedProduct.setCategory(product.getCategory());
            managedProduct.setShop(product.getShop());
            entityManager.getTransaction().commit();
        } else {
            entityManager.getTransaction().rollback();
        }
    }
    public List<Product> findProductsByCategoryId(int categoryId) {
        return entityManager.createNativeQuery("SELECT * FROM products WHERE category_id = ?", Product.class)
                .setParameter(1, categoryId)
                .getResultList();
    }


    public List<Product> findProductsByName(String query) {
        return entityManager.createNativeQuery("SELECT * FROM products WHERE name LIKE ?", Product.class)
                .setParameter(1, query + "%")
                .getResultList();
    }



    public List<Product> findLatestProducts() {
        return entityManager.createNativeQuery("SELECT * FROM products ORDER BY id DESC LIMIT 10", Product.class)
                .getResultList();
    }


    public List<Product> findDiscountedProducts() {
        return entityManager.createNativeQuery("SELECT * FROM products WHERE discount > 0", Product.class)
                .getResultList();
    }


    @Transactional
    public List<Product> findProductsBySeller(User user) {
        if (user == null) {
            return Collections.emptyList();
        }
        List<Shop> shops = shopRepository.getSellerShops(user);

        List<Product> products = new ArrayList<>();
        for (Shop shop : shops) {
            products.addAll(shop.getProducts());
        }
        return products;
    }
}