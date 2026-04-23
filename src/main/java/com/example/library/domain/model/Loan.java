package com.example.library.domain.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.time.LocalDate;

/**
 * A borrowing record linking a member to a book.
 * {@code returnedOn} is null while the book is still on loan.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public record Loan(
        String loanId,
        String bookId,
        String memberName,
        LocalDate borrowedOn,
        LocalDate returnedOn
) {
    public boolean isActive() {
        return returnedOn == null;
    }

    public Loan withReturn(LocalDate date) {
        return new Loan(loanId, bookId, memberName, borrowedOn, date);
    }
}
