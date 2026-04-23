package com.example.library.service;

import com.example.library.store.LibraryStore;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class LibraryServiceTest {

    @Mock
    LibraryStore store;

    LibraryService service;

    @BeforeEach
    void setUp() {
        service = new LibraryService();
        // Inject mock store via reflection (or use @InjectMocks)
        try {
            var field = LibraryService.class.getDeclaredField("store");
            field.setAccessible(true);
            field.set(service, store);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Test
    void shouldAddBook_andReturnWithGeneratedId() {
        // Given
        var title = "Clean Code";
        var author = "Robert C. Martin";
        var isbn = "978-0132350884";

        // When
        var book = service.addBook(title, author, isbn);

        // Then
        assertThat(book.id()).isNotBlank();
        assertThat(book.title()).isEqualTo("Clean Code");
        assertThat(book.author()).isEqualTo("Robert C. Martin");
        assertThat(book.available()).isTrue();
        verify(store).saveBook(argThat(b -> b.title().equals("Clean Code")));
    }

    @Test
    void shouldReturnEmpty_whenBookNotFound() {
        // Given
        when(store.findBook("unknown-id")).thenReturn(Optional.empty());

        // When
        var result = service.findById("unknown-id");

        // Then
        assertThat(result).isEmpty();
    }
}
