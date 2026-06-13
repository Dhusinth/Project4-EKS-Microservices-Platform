output "eks_cluster_name" {
  description = "Project4 EKS Cluster Name"
  value       = aws_eks_cluster.project4_eks.name
}

output "project4_vpc_id" {
  description = "Project4 VPC ID"
  value       = aws_vpc.project4_vpc.id
}

output "eks_endpoint" {
  description = "Project4 EKS Endpoint"
  value       = aws_eks_cluster.project4_eks.endpoint
}

output "eks_cluster_arn" {
  description = "Project4 EKS Cluster ARN"
  value       = aws_eks_cluster.project4_eks.arn
}

output "private_subnet_ids" {
  description = "Private Subnet IDs"
  value = [
    aws_subnet.project4_private_subnet_1.id,
    aws_subnet.project4_private_subnet_2.id
  ]
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value = [
    aws_subnet.project4_public_subnet_1.id,
    aws_subnet.project4_public_subnet_2.id
  ]
}