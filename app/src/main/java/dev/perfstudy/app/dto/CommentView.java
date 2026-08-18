package dev.perfstudy.app.dto;

import java.time.LocalDateTime;

public record CommentView(Long id, String authorName, String content, LocalDateTime createdAt) {
}
