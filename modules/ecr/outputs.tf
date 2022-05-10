output "repo_url" {
  description = "The URL of the repository"
  value       = aws_ecr_repository.this_repo.repository_url
}