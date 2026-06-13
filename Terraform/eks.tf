resource "aws_eks_cluster" "project4_eks" {
  name     = "project4-eks"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.36"

  vpc_config {
    subnet_ids = [
      aws_subnet.project4_public_subnet_1.id,
      aws_subnet.project4_public_subnet_2.id,
      aws_subnet.project4_private_subnet_1.id,
      aws_subnet.project4_private_subnet_2.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = {
    Name = "project4-eks"
  }

}

resource "aws_eks_node_group" "project4_node_group" {
  cluster_name    = aws_eks_cluster.project4_eks.name
  node_group_name = "project4_node_group"
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = [aws_subnet.project4_private_subnet_1.id, aws_subnet.project4_private_subnet_2.id]
  instance_types  = ["t3.small"]

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_read_only,
  ]

  tags = {
    Name = "project4-node-group"
  }

}