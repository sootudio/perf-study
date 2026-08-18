package dev.perfstudy.app.dto;

import java.time.LocalDateTime;

public record PostSummary(Long id, String title, int viewCount, LocalDateTime createdAt) {
}
