package dev.perfstudy.app.repository;

import dev.perfstudy.app.entity.Post;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PostRepository extends JpaRepository<Post, Long> {

    List<Post> findTop20ByTitleContainingOrderByCreatedAtDesc(String keyword);
}
