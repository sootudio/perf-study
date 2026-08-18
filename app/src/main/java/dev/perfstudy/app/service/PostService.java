package dev.perfstudy.app.service;

import dev.perfstudy.app.dto.CommentView;
import dev.perfstudy.app.dto.PostDetail;
import dev.perfstudy.app.dto.PostSummary;
import dev.perfstudy.app.entity.Post;
import dev.perfstudy.app.repository.CommentRepository;
import dev.perfstudy.app.repository.PostRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

import static org.springframework.http.HttpStatus.NOT_FOUND;

@Service
@Transactional(readOnly = true)
public class PostService {

    private final PostRepository postRepository;
    private final CommentRepository commentRepository;

    public PostService(PostRepository postRepository, CommentRepository commentRepository) {
        this.postRepository = postRepository;
        this.commentRepository = commentRepository;
    }

    public Page<PostSummary> getPosts(int page, int size) {
        PageRequest pageRequest = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        return postRepository.findAll(pageRequest)
                .map(p -> new PostSummary(p.getId(), p.getTitle(), p.getViewCount(), p.getCreatedAt()));
    }

    public PostDetail getPost(Long id) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(NOT_FOUND, "post not found: " + id));

        List<CommentView> comments = commentRepository.findByPostIdOrderByCreatedAtDesc(id).stream()
                .map(c -> new CommentView(c.getId(), c.getMember().getUsername(), c.getContent(), c.getCreatedAt()))
                .toList();

        return new PostDetail(
                post.getId(),
                post.getTitle(),
                post.getContent(),
                post.getMember().getUsername(),
                post.getViewCount(),
                post.getCreatedAt(),
                comments
        );
    }

    public List<PostSummary> search(String keyword) {
        return postRepository.findTop20ByTitleContainingOrderByCreatedAtDesc(keyword).stream()
                .map(p -> new PostSummary(p.getId(), p.getTitle(), p.getViewCount(), p.getCreatedAt()))
                .toList();
    }
}
