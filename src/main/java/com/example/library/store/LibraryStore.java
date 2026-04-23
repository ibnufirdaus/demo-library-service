package com.example.library.store;

import com.example.library.domain.model.Book;
import com.example.library.domain.model.Loan;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.Collection;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

/**
 * In-memory data layer backed by ConcurrentHashMap.
 *
 * ⚠️ Not a plain HashMap — concurrent reads/writes from JAX-RS worker threads
 * require ConcurrentHashMap. Using HashMap here would cause silent data
 * corruption under load (no exception, wrong state).
 */
@ApplicationScoped
public class LibraryStore {

    private final ConcurrentHashMap<String, Book> books = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<String, Loan> loans = new ConcurrentHashMap<>();

    // --- Books ---

    public void saveBook(Book book) {
        books.put(book.id(), book);
    }

    public Optional<Book> findBook(String id) {
        return Optional.ofNullable(books.get(id));
    }

    public Collection<Book> allBooks() {
        return books.values();
    }

    // --- Loans ---

    public void saveLoan(Loan loan) {
        loans.put(loan.loanId(), loan);
    }

    public Optional<Loan> findLoan(String loanId) {
        return Optional.ofNullable(loans.get(loanId));
    }

    public Collection<Loan> allLoans() {
        return loans.values();
    }
}
